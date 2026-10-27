# AS-IS 액션 대조표 — FP00623

> 원천: `Doc/asisfacts/screens/FP00623/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 670행 · 메서드 115 · 종류 DATA_OP 260 · FLAG 68 · UI_PROP 54 · GRID_INIT 40 · CALL_EXT 37 · RETURN 32 · UI_MISC 31 · VALUE_SET 28 · POPUP 22 · ENDPOINT 21 · MESSAGE 13 · STATE 10 · GRID_SET 10 · THROW 8 · GRID_LOCK 7 · LIST_REBIND 7 · GRID_STYLE 6 · GRID_BIND 5 · EXCEL 3 · CALL_BASE 3 · LIST_BIND 2 · COMBO_DATA 2 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 40


## FP00623_InvDetail_Popup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79f14124 | (진입점 미연결) | FP00623_InvDetail_Popup.cs:339 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-86e5782e | (진입점 미연결) | FP00623_InvDetail_Popup.cs:342 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-56391262 | (진입점 미연결) | FP00623_InvDetail_Popup.cs:343 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00623_InvDetail_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ae8686e | this.Load | FP00623_InvDetail_Popup.cs:143 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ffe3b3b2 | this.Load | FP00623_InvDetail_Popup.cs:144 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7b672e22 | this.Load | FP00623_InvDetail_Popup.cs:145 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00623_InvDetail_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1fbf359 | this.Load | FP00623_InvDetail_Popup.cs:138 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00623_InvDetail_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-119ca2c1 | Dispose | FP00623_InvDetail_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00623_InvDetail_Popup.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ad9cf1f | ExcelButton | FP00623_InvDetail_Popup.cs:207 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00623_InvDetail_Popup.Find_Data_Line

진입점: this.Load [try ▸ lambda] / FindButton [try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cca9e43 | this.Load [try ▸ lambda] 외 2 | FP00623_InvDetail_Popup.cs:267 | try ▸ if (Filter["POP_TYPE"].ToString() == "RECEIPT") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00623", "find_BOH_Detail_Receipt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOH_Detail_Receipt] \| FP\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-76977432 | this.Load [try ▸ lambda] 외 2 | FP00623_InvDetail_Popup.cs:271 | try ▸ else of (Filter["POP_TYPE"].ToString() == "RECEIPT") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00623", "find_BOH_Detail", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOH_Detail] \| FP\Planning… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0ec458fc | this.Load [try ▸ lambda] 외 2 | FP00623_InvDetail_Popup.cs:304 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-4a018994 | this.Load [try ▸ lambda] 외 2 | FP00623_InvDetail_Popup.cs:308 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00623_InvDetail_Popup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9c92fc1 | this.Load 외 2 | FP00623_InvDetail_Popup.cs:222 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-04ba650b | this.Load 외 2 | FP00623_InvDetail_Popup.cs:228 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Line("SELECT", pSysFlag) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dcfa76f0 | this.Load 외 2 | FP00623_InvDetail_Popup.cs:235 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d18e0acf | this.Load 외 2 | FP00623_InvDetail_Popup.cs:238 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5544b812 | this.Load 외 2 | FP00623_InvDetail_Popup.cs:242 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-281f7265 | this.Load 외 2 | FP00623_InvDetail_Popup.cs:250 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-ec49bcbe | this.Load 외 2 | FP00623_InvDetail_Popup.cs:256 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP00623_InvDetail_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7523ba9 | this.Load | FP00623_InvDetail_Popup.cs:115 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2e7801fc | this.Load | FP00623_InvDetail_Popup.cs:117 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00623_InvDetail_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d823595c | this.Load | FP00623_InvDetail_Popup.cs:155 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f346add4 | this.Load | FP00623_InvDetail_Popup.cs:156 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00623_InvDetail_Popup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fa8840d | (진입점 미연결) | FP00623_InvDetail_Popup.cs:177 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00623_InvDetail_Popup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba9d2a95 | this.Load | FP00623_InvDetail_Popup.cs:162 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d2b81990 | this.Load | FP00623_InvDetail_Popup.cs:163 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-ed7008b2 | this.Load | FP00623_InvDetail_Popup.cs:167 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00623_InvDetail_Popup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3922998f | this.spdMain.CellClick | FP00623_InvDetail_Popup.cs:354 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-abd242f6 | this.spdMain.CellClick | FP00623_InvDetail_Popup.cs:355 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e4e00eeb | this.spdMain.CellClick | FP00623_InvDetail_Popup.cs:358 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00623_InvDetail_Popup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3869bb74 | this.spdMain.CellDoubleClick | FP00623_InvDetail_Popup.cs:364 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-50ae1a2e | this.spdMain.CellDoubleClick | FP00623_InvDetail_Popup.cs:365 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-047b86f4 | this.spdMain.CellDoubleClick | FP00623_InvDetail_Popup.cs:368 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-c5cdb8f2 | this.spdMain.CellDoubleClick | FP00623_InvDetail_Popup.cs:371 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00623_InvDetail_Popup.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33ed95f9 | this.spdMain.EditChange | FP00623_InvDetail_Popup.cs:498 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00623_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e110df7a | .ctor | FP00623_MeasureSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-acf4edc9 | .ctor | FP00623_MeasureSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-465b3fbb | .ctor | FP00623_MeasureSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-9551b6c4 | .ctor | FP00623_MeasureSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00623_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b24f7b9 | Dispose | FP00623_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00623_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd4de0be | this.Load | FP00623_MeasureSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00623_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa63de70 | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:157 |  | DATA_OP | ctrls.Add | (chk_assy) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2dd150a | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:158 |  | DATA_OP | ctrls.Add | (chk_coater_yield) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c830260 | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:160 |  | DATA_OP | ctrls.Add | (chk_coater) | 데이터 객체 조작/조회 |  |  |  |
| AC-938f8042 | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:161 |  | DATA_OP | ctrls.Add | (chk_shipment) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf93592f | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:163 |  | DATA_OP | ctrls.Add | (chk_shipment_in) | 데이터 객체 조작/조회 |  |  |  |
| AC-92324cb9 | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:164 |  | DATA_OP | ctrls.Add | (chk_inv) | 데이터 객체 조작/조회 |  |  |  |
| AC-742a0973 | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:166 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8ad861e | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:171 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-fab5cc82 | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:171 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-a3851b0a | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:178 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-80539b37 | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:182 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |

## FP00623_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e4aa25c | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:121 |  | VALUE_SET | chk_assy.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d8f9e3f0 | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:122 |  | VALUE_SET | chk_coater_yield.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f1225275 | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:124 |  | VALUE_SET | chk_coater.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-98cc716b | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:125 |  | VALUE_SET | chk_shipment.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-65e76a78 | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:127 |  | VALUE_SET | chk_shipment_in.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-193c391c | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:128 |  | VALUE_SET | chk_inv.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-dfafebe6 | this.Load 외 1 | FP00623_MeasureSetForm_Popup.cs:130 |  | VALUE_SET | chk_total.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00623_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01e4b763 | (진입점 미연결) | FP00623_MeasureSetForm_Popup.cs:245 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-83693394 | (진입점 미연결) | FP00623_MeasureSetForm_Popup.cs:256 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a2c1bce1 | (진입점 미연결) | FP00623_MeasureSetForm_Popup.cs:267 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00623_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8af3c2ae | this.Load | FP00623_MeasureSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-37b724e7 | this.Load | FP00623_MeasureSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00623_MeasureSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e29d3e59 | this.usrButton1.Click | FP00623_MeasureSetForm_Popup.cs:229 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-75023723 | this.usrButton1.Click | FP00623_MeasureSetForm_Popup.cs:229 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-3808de4a | this.usrButton1.Click | FP00623_MeasureSetForm_Popup.cs:231 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-3db001b3 | this.usrButton1.Click | FP00623_MeasureSetForm_Popup.cs:235 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-ab6eb733 | this.usrButton1.Click | FP00623_MeasureSetForm_Popup.cs:236 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-c4e0f78c | this.usrButton1.Click | FP00623_MeasureSetForm_Popup.cs:238 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-97663059 | this.usrButton1.Click | FP00623_MeasureSetForm_Popup.cs:240 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP00623_MeasureSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-658fd0e7 | this.usrButton2.Click | FP00623_MeasureSetForm_Popup.cs:203 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-e6c3b13f | this.usrButton2.Click | FP00623_MeasureSetForm_Popup.cs:203 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-3fba5a9a | this.usrButton2.Click | FP00623_MeasureSetForm_Popup.cs:205 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-647b17ea | this.usrButton2.Click | FP00623_MeasureSetForm_Popup.cs:209 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-f869260f | this.usrButton2.Click | FP00623_MeasureSetForm_Popup.cs:210 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-8e6b95e0 | this.usrButton2.Click | FP00623_MeasureSetForm_Popup.cs:211 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-18d9e49b | this.usrButton2.Click | FP00623_MeasureSetForm_Popup.cs:212 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00623_Pancake_Simulation_Elec..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0879006 | .ctor | FP00623_Pancake_Simulation_Elec.cs:108 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00623_Pancake_Simulation_Elec.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_ELEC") ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ lambda ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78c313c9 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1365 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-639c1dac | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1366 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-adc6bc06 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1367 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-39ddd48b | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1368 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c670f67a | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1369 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0985715f | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1371 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00600_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-6c92f848 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1371 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00600_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a5f16d3a | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1372 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00600_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-cb0ef5b9 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1372 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00600_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6be32792 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1373 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00600_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-95d8e3da | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1373 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00600_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-495d7109 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1374 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00600_PlanAmend", "find_BukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-46b5f1e7 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1374 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00600_PlanAmend", "find_BukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-03bf942e | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1387 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-b322127b | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1388 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-d50730cc | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1389 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-086dfa91 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1390 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-b9cae139 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1391 |  | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-1a31ac0b | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1392 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-09b7d379 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1393 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-9c41c9c7 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1394 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.ApplySearchCondition_Simul

진입점: popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_ELEC") ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ lambda ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc8c72df | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1959 |  | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-e38c3f09 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1960 |  | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-ccab0fe5 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1962 |  | DATA_OP | Filter["TABLE_NAME"] | "FP_AMEND_SIM_CELL_PACK_R" | 행/컬럼 값 대입 |  |  |  |
| AC-714d67b2 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1966 | if (Filter["RELEASE_FLAG"] == "Y" \|\| Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["TABLE_NAME"] | "FP_AMEND_SIM_CELL_PACK_H" | 행/컬럼 값 대입 |  |  |  |
| AC-f6af2184 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1970 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1e3fb3c2 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1972 |  | DATA_OP | Filter["CHK_PLAN_ID"] | "N" | 행/컬럼 값 대입 |  |  |  |

## FP00623_Pancake_Simulation_Elec.btnBucket_Click

진입점: this.btn_bucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eee4b8c2 | this.btn_bucket.Click | FP00623_Pancake_Simulation_Elec.cs:1482 |  | POPUP | new FP00599_BucketSetForm_Popup | ("FP00623", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-8a198eb0 | this.btn_bucket.Click | FP00623_Pancake_Simulation_Elec.cs:1484 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-41b1a0e0 | this.btn_bucket.Click | FP00623_Pancake_Simulation_Elec.cs:1485 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-230d7913 | this.btn_bucket.Click | FP00623_Pancake_Simulation_Elec.cs:1486 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d5b4f792 | this.btn_bucket.Click | FP00623_Pancake_Simulation_Elec.cs:1490 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP00623_Pancake_Simulation_Elec.btnCatagory_Click

진입점: this.btn_category.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e9575cb | this.btn_category.Click | FP00623_Pancake_Simulation_Elec.cs:1449 |  | POPUP | new FP00623_MeasureSetForm_Popup | ("FP00623", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-aa66d3e5 | this.btn_category.Click | FP00623_Pancake_Simulation_Elec.cs:1451 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-78c08ee5 | this.btn_category.Click | FP00623_Pancake_Simulation_Elec.cs:1452 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3be224d2 | this.btn_category.Click | FP00623_Pancake_Simulation_Elec.cs:1453 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dde8373d | this.btn_category.Click | FP00623_Pancake_Simulation_Elec.cs:1457 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP00623_Pancake_Simulation_Elec.btnPlanInfo_Click

진입점: this.btnPlanInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9839c086 | this.btnPlanInfo.Click | FP00623_Pancake_Simulation_Elec.cs:1591 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-547b6fd5 | this.btnPlanInfo.Click | FP00623_Pancake_Simulation_Elec.cs:1592 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6fe9f2bc | this.btnPlanInfo.Click | FP00623_Pancake_Simulation_Elec.cs:1595 |  | POPUP | new FP00623_PlanInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9a78083a | this.btnPlanInfo.Click | FP00623_Pancake_Simulation_Elec.cs:1596 |  | UI_PROP | planInfoPopup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-7ac9cfec | this.btnPlanInfo.Click | FP00623_Pancake_Simulation_Elec.cs:1596 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3926d34f | this.btnPlanInfo.Click | FP00623_Pancake_Simulation_Elec.cs:1597 |  | DATA_OP | planInfoPopup.Filter["MASTER_ID"] | planInfoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-148f7cb2 | this.btnPlanInfo.Click | FP00623_Pancake_Simulation_Elec.cs:1597 |  | DATA_OP | planInfoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5976a232 | this.btnPlanInfo.Click | FP00623_Pancake_Simulation_Elec.cs:1598 |  | DATA_OP | planInfoPopup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-f1943a88 | this.btnPlanInfo.Click | FP00623_Pancake_Simulation_Elec.cs:1599 |  | DATA_OP | planInfoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-85a4c550 | this.btnPlanInfo.Click | FP00623_Pancake_Simulation_Elec.cs:1601 |  | DATA_OP | planInfoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b876fbef | this.btnPlanInfo.Click | FP00623_Pancake_Simulation_Elec.cs:1602 |  | DATA_OP | planInfoPopup.Filter["RELEASE_FLAG"] | Filter["RELEASE_FLAG"] | 행/컬럼 값 대입 |  |  |  |
| AC-8d8a81f5 | this.btnPlanInfo.Click | FP00623_Pancake_Simulation_Elec.cs:1603 |  | DATA_OP | planInfoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f77fb1fa | this.btnPlanInfo.Click | FP00623_Pancake_Simulation_Elec.cs:1604 |  | DATA_OP | planInfoPopup.Filter["PROG_ID"] | "FP00623" | 행/컬럼 값 대입 |  |  |  |
| AC-d97eacae | this.btnPlanInfo.Click | FP00623_Pancake_Simulation_Elec.cs:1606 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0f981e2d | this.btnPlanInfo.Click | FP00623_Pancake_Simulation_Elec.cs:1607 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00623_Pancake_Simulation_Elec.btnSimulColumn_Click

진입점: this.btn_column.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26f5402e | this.btn_column.Click | FP00623_Pancake_Simulation_Elec.cs:2569 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00623", SpdSheet.shtSimul, true, cboPlanId.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-27cb9a1f | this.btn_column.Click | FP00623_Pancake_Simulation_Elec.cs:2573 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6c9e4840 | this.btn_column.Click | FP00623_Pancake_Simulation_Elec.cs:2574 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00623_Pancake_Simulation_Elec.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7222165f | this.btnSql.Click | FP00623_Pancake_Simulation_Elec.cs:1015 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a1882cfd | this.btnSql.Click | FP00623_Pancake_Simulation_Elec.cs:1016 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-04fa1504 | this.btnSql.Click | FP00623_Pancake_Simulation_Elec.cs:1018 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00623_PANCAKE_SIMUL_ELEC") | 데이터 객체 조작/조회 |  |  |  |
| AC-1fd97f92 | this.btnSql.Click | FP00623_Pancake_Simulation_Elec.cs:1019 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY") | 데이터 객체 조작/조회 |  |  |  |
| AC-38a8ef7e | this.btnSql.Click | FP00623_Pancake_Simulation_Elec.cs:1020 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00623_Pancake_Simulation_Elec.btnToggleSave_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0578c3cc | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1515 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.BuildStockVersion

진입점: this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try] / FindButton [try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-caff778c | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2408 |  | CALL_EXT | dsSimulBoh.Tables[0].AsEnumerable().GroupBy | (x => new { COMPANY_ID = x.Field<string>("COMPANY_ID"), DIVISION_ID = x.Field<string>("DIV… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1652abc0 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2410 | lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-071e2cbb | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2411 | lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e572cfb | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2412 | lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9ff601a1 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2413 | lambda | DATA_OP | x.Field | ("PROD_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-81050fce | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2414 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4759dffa | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2419 |  | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("STOCK_VERSION_ALL", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3abebcb9 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2420 |  | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("WM_VERSION_ALL", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e0734c7 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2421 |  | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("STOCK_VERSION_SEL", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e359897 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2425 |  | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("STOCK_VERSION0", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3c657f3 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2426 |  | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("STOCK_VERSION1", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c43753ac | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2427 |  | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("STOCK_VERSION2", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-251ea98a | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2428 |  | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("STOCK_VERSION3", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-659637fd | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2429 |  | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("STOCK_VERSION4", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9e34918 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2450 | foreach (var group_version in group3) ▸ foreach (var group_rows in group_version) | DATA_OP | eachVersionLines.Contains | (aver) | 데이터 객체 조작/조회 |  |  |  |
| AC-71a3e224 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2452 | foreach (var group_version in group3) ▸ foreach (var group_rows in group_version) ▸ if (!eachVersionLines.Contains(aver)) | DATA_OP | eachVersionLines.Add | (aver) | 데이터 객체 조작/조회 |  |  |  |
| AC-458d3303 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2453 | foreach (var group_version in group3) ▸ foreach (var group_rows in group_version) ▸ if (!eachVersionLines.Contains(aver)) | DATA_OP | VersionVsWorkModel.Add | (aver, wm) | 데이터 객체 조작/조회 |  |  |  |
| AC-36a3c6eb | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2464 | foreach (var group_version in group3) ▸ foreach (KeyValuePair<string, string> kvp in VersionVsWorkModel) | DATA_OP | ms.Add | (kvp.Key + ":" + kvp.Value) | 데이터 객체 조작/조회 |  |  |  |
| AC-48046f4b | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2467 | foreach (var group_version in group3) | CALL_EXT | dsSimulDate.Tables[0].AsEnumerable() .Where(x => ( x.Field<string>("COMPANY_ID") == fRow["… | (r => { r["STOCK_VERSION_ALL"] = v_all; r["STOCK_VERSION_SEL"] = v_all; r["WM_VERSION_ALL"… | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc12f89a | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2469 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-38d685a4 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2470 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f58ed2b4 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2471 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c714bb1 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2472 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("PROD_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-323a4b7b | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2473 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4936beda | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2478 | foreach (var group_version in group3) ▸ lambda | DATA_OP | r["STOCK_VERSION_ALL"] | v_all | 행/컬럼 값 대입 |  |  |  |
| AC-4ddbc60d | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2479 | foreach (var group_version in group3) ▸ lambda | DATA_OP | r["STOCK_VERSION_SEL"] | v_all | 행/컬럼 값 대입 |  |  |  |
| AC-95e25b18 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2480 | foreach (var group_version in group3) ▸ lambda | DATA_OP | r["WM_VERSION_ALL"] | match | 행/컬럼 값 대입 |  |  |  |
| AC-598925fa | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2486 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf16ce9c | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2487 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-205b0fe0 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2488 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-40a3a93a | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2489 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("PROD_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-c1548a39 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2490 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-97b270b4 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2502 | foreach (var group_version in group3) ▸ foreach (DataRow eR in categoryLines) | CALL_EXT | eR["CATEGORY_ID"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c24adae | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2503 | foreach (var group_version in group3) ▸ foreach (DataRow eR in categoryLines) | DATA_OP | cates.Add | (idx, eR) | 데이터 객체 조작/조회 |  |  |  |
| AC-2af41925 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2551 | foreach (var group_version in group3) ▸ for (i < lenVersionLines) | DATA_OP | cates.ContainsKey | (cateFinder) | 데이터 객체 조작/조회 |  |  |  |
| AC-d39fa744 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:2558 | foreach (var group_version in group3) ▸ for (i < lenVersionLines) ▸ if (row != null) | DATA_OP | row[colname] | eachVersionLines[i] | 행/컬럼 값 대입 |  |  |  |

## FP00623_Pancake_Simulation_Elec.cboInstance_changed

진입점: cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04df44d9 | cbo_plan_group.SelectedIndexChanged | FP00623_Pancake_Simulation_Elec.cs:415 |  | STATE | chk_release.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9f4c30a7 | cbo_plan_group.SelectedIndexChanged | FP00623_Pancake_Simulation_Elec.cs:416 |  | STATE | cboPlanId.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00623_Pancake_Simulation_Elec.cboUomType_changed

진입점: cboUomType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75778dc9 | cboUomType.SelectedIndexChanged | FP00623_Pancake_Simulation_Elec.cs:2870 | if (dsSimulDate != null) | GRID_INIT | siSimul.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00623_Pancake_Simulation_Elec.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-358778a1 | this.Load | FP00623_Pancake_Simulation_Elec.cs:640 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-aac66c95 | this.Load | FP00623_Pancake_Simulation_Elec.cs:640 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-51bb190f | this.Load | FP00623_Pancake_Simulation_Elec.cs:642 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00599_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b99dcf29 | this.Load | FP00623_Pancake_Simulation_Elec.cs:642 |  | POPUP | new FP00599_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-26602950 | this.Load | FP00623_Pancake_Simulation_Elec.cs:645 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-402e1c45 | this.Load | FP00623_Pancake_Simulation_Elec.cs:646 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-f8ccd912 | this.Load | FP00623_Pancake_Simulation_Elec.cs:647 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-80c22581 | this.Load | FP00623_Pancake_Simulation_Elec.cs:648 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-2405b6eb | this.Load | FP00623_Pancake_Simulation_Elec.cs:649 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-a9adc268 | this.Load | FP00623_Pancake_Simulation_Elec.cs:650 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP00623_Pancake_Simulation_Elec.chk_release_CheckedChanged

진입점: chk_release.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5df2dac | chk_release.CheckedChanged | FP00623_Pancake_Simulation_Elec.cs:470 | if (chk_release.Checked) | STATE | cboPlanId.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-97a398eb | chk_release.CheckedChanged | FP00623_Pancake_Simulation_Elec.cs:471 | if (chk_release.Checked) | STATE | drpPlanDate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-614c2ebd | chk_release.CheckedChanged | FP00623_Pancake_Simulation_Elec.cs:480 | if (chk_release.Checked) ▸ if (cboPlanId.Items.Count > 0) | VALUE_CLEAR | cboPlanId.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-b34210b3 | chk_release.CheckedChanged | FP00623_Pancake_Simulation_Elec.cs:498 | else of (chk_release.Checked) | STATE | cboPlanId.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-66be9956 | chk_release.CheckedChanged | FP00623_Pancake_Simulation_Elec.cs:499 | else of (chk_release.Checked) | STATE | drpPlanDate.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00623_Pancake_Simulation_Elec.CommaList

진입점: cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ foreach (var group_version in group3) ▸ if (!set_to_empty)] / this.spdMain.CellDoubleClick [try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version))] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsSimulDate != null) ▸ if (dsSimulDate != null) ▸ foreach (var group_version in group3) ▸ if (!set_to_empty)] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsSimulDate != null) ▸ if (dsSimulDa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e02c6464 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:1995 | if (string.IsNullOrWhiteSpace(list_src)) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-0851ad47 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:1998 | if (spl == null \|\| spl.Length < 1) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-72212a2d | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2003 | for (i < spl.Length) ▸ if (!string.IsNullOrWhiteSpace(spl[i])) | DATA_OP | res.Add | (spl[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce03a9a8 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2005 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## FP00623_Pancake_Simulation_Elec.CommaStr

진입점: this.spdMain.CellDoubleClick [try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_version))] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ foreach (var group_version in group3)] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ foreach (v…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-867b9755 | this.spdMain.CellDoubleClick [try ▸ if (colname.ToUpper().Co… 외 3 | FP00623_Pancake_Simulation_Elec.cs:2015 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FP00623_Pancake_Simulation_Elec.CreateFilterDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4d83742 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1035 |  | DATA_OP | dsResult.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3d807535 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1035 |  | RETURN | return dsResult.Copy(); |  | 처리 중단/반환 |  |  |  |

## FP00623_Pancake_Simulation_Elec.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-137a0dac | this.Load | FP00623_Pancake_Simulation_Elec.cs:597 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtSimul, SpdSheet.shtSimul, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b21e232c | this.Load | FP00623_Pancake_Simulation_Elec.cs:598 |  | FLAG | siSimul | GetSheetInfo(spdMain.Name, SpdSheet.shtSimul) | 화면 필드/플래그 변경 |  |  |  |
| AC-50bdd87e | this.Load | FP00623_Pancake_Simulation_Elec.cs:599 |  | GRID_INIT | siSimul.ChangeSheet | (SpdSheet.shtSimul) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00623_Pancake_Simulation_Elec.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37e2a48f | DeleteButton | FP00623_Pancake_Simulation_Elec.cs:848 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00623_Pancake_Simulation_Elec.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d455210 | Dispose | FP00623_Pancake_Simulation_Elec.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00623_Pancake_Simulation_Elec.DrawHeader_Simul

진입점: this.Load [try] / cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ if (!dsSimulDate.Good()) ▸ try ▸ if (monthInfo == null \|\| dsSimulDate == null)] / this.spdMain.CellDoubleClick [try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!dsSimulDate.Good()) ▸ try ▸ if (monthInfo == null \|\| dsSimulDate == null)] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsSimulDate != null) ▸ else of (dsSimulDate != null)] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsSimulDate != null…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54076d96 | this.Load [try] 외 6 | FP00623_Pancake_Simulation_Elec.cs:2363 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-8b1f2643 | this.Load [try] 외 6 | FP00623_Pancake_Simulation_Elec.cs:2364 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-b91581dc | this.Load [try] 외 6 | FP00623_Pancake_Simulation_Elec.cs:2365 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-a85903e6 | this.Load [try] 외 6 | FP00623_Pancake_Simulation_Elec.cs:2366 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-2cb14bfd | this.Load [try] 외 6 | FP00623_Pancake_Simulation_Elec.cs:2378 | if (monthInfo != null) ▸ if (with_day_part == false) | GRID_INIT | siSimul.SetSheetHeaderColumn_FP | (siSimul, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-b428be50 | this.Load [try] 외 6 | FP00623_Pancake_Simulation_Elec.cs:2379 | if (monthInfo != null) ▸ if (with_day_part == false) | GRID_INIT | siSimul.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-61c106cb | this.Load [try] 외 6 | FP00623_Pancake_Simulation_Elec.cs:2380 | if (monthInfo != null) ▸ if (with_day_part == false) | GRID_INIT | siSimul.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2ba279c9 | this.Load [try] 외 6 | FP00623_Pancake_Simulation_Elec.cs:2381 | if (monthInfo != null) ▸ if (with_day_part == false) | GRID_INIT | siSimul.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2247d285 | this.Load [try] 외 6 | FP00623_Pancake_Simulation_Elec.cs:2386 | if (monthInfo != null) ▸ else of (with_day_part == false) | CALL_EXT | siSimul.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d06be85 | this.Load [try] 외 6 | FP00623_Pancake_Simulation_Elec.cs:2389 | if (monthInfo != null) ▸ else of (with_day_part == false) ▸ if (added_columns_count == -1) | GRID_INIT | siSimul.SetSheetHeaderFromDataSource | (siSimul, dsSimulFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-a73bb0a2 | this.Load [try] 외 6 | FP00623_Pancake_Simulation_Elec.cs:2390 | if (monthInfo != null) ▸ else of (with_day_part == false) ▸ if (added_columns_count == -1) | GRID_BIND | siSimul.Query | (dsSimulFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ab3cad85 | this.Load [try] 외 6 | FP00623_Pancake_Simulation_Elec.cs:2394 | if (monthInfo != null) ▸ else of (with_day_part == false) ▸ if (added_columns_count == -1) | GRID_INIT | siSimul.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-79cafe6f | this.Load [try] 외 6 | FP00623_Pancake_Simulation_Elec.cs:2395 | if (monthInfo != null) ▸ else of (with_day_part == false) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a482b75b | this.Load [try] 외 6 | FP00623_Pancake_Simulation_Elec.cs:2397 | if (monthInfo != null) ▸ else of (with_day_part == false) | GRID_INIT | siSimul.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-921da157 | this.Load [try] 외 6 | FP00623_Pancake_Simulation_Elec.cs:2398 | if (monthInfo != null) ▸ else of (with_day_part == false) | GRID_INIT | siSimul.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a49d85b8 | this.Load [try] 외 6 | FP00623_Pancake_Simulation_Elec.cs:2400 | if (monthInfo != null) ▸ else of (with_day_part == false) | GRID_SET | siSimul.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.DrawSheet_Simul

진입점: cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ if (!dsSimulDate.Good()) ▸ try ▸ else of (monthInfo == null \|\| dsSimulDate == null)] / this.spdMain.CellDoubleClick [try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!dsSimulDate.Good()) ▸ try ▸ else of (monthInfo == null \|\| dsSimulDate == null)] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsSimulDate != null) ▸ if (dsSimulDate != null) ▸ if (!dsSimulDate.Good()) ▸ try ▸ else of (monthInfo == null \|\| dsSimulDate == null)] / this.btn_category.Click [if (frm.DialogRe…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a632618 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2050 |  | UI_PROP | numCell.DecimalPlaces | 1 | 속성 DecimalPlaces 설정 |  |  |  |
| AC-e491d7da | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2051 |  | UI_PROP | numCell.Separator | "," | 속성 Separator 설정 |  |  |  |
| AC-96b87a97 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2052 |  | UI_PROP | numCell.ShowSeparator | true | 속성 ShowSeparator 설정 |  |  |  |
| AC-95cce17f | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2054 |  | CALL_EXT | siSimul.UnderLineOptions.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bb9eef87 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2055 |  | CALL_EXT | siSimul.AddUnderLine | ("ITEM_ID", FarPoint.Win.ComplexBorderSideStyle.ThickLine, Color.Black, SpreadInfo.LengthO… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f5abfef | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2060 |  | CALL_EXT | siSimul.SetRightMerge | (siSimul.GetMaxColumnIndex(), true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-318cf77b | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2066 | if (idx > 0) | CALL_EXT | siSimul.SetRightMerge | (idx, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c7f7256f | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2069 |  | GRID_BIND | siSimul.Query | (dsSimulFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-376cbc64 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2070 |  | CALL_EXT | siSimul.SetMergeRange | (0, idx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f8f4b2e | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2081 |  | GRID_INIT | siSimul.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-676b90f2 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2093 | if (dsSimulFiltered.Good()) ▸ if (!siSimul.SpreadObject.IsLayoutSuspended) | UI_MISC | siSimul.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-05931a2b | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2101 | if (dsSimulFiltered.Good()) ▸ for (i < 5) | DATA_OP | version_colname[i] | string.Format("STOCK_VERSION{0}", i) | 행/컬럼 값 대입 |  |  |  |
| AC-a3586417 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2102 | if (dsSimulFiltered.Good()) ▸ for (i < 5) | DATA_OP | version_colidx[i] | siSimul.GetColumnIndex(version_colname[i]) | 행/컬럼 값 대입 |  |  |  |
| AC-36e956c7 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2113 | if (dsSimulFiltered.Good()) | CALL_EXT | FPExtensions.ColorFromName | (selColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6becc900 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2114 | if (dsSimulFiltered.Good()) | CALL_EXT | FPExtensions.ColorFromName | (deColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e982d165 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2132 | if (dsSimulFiltered.Good()) ▸ if (current_src != null && calendar != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (all_match != nu… | DATA_OP | VerisonVsWorkModel.ContainsKey | (kv[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-b17918da | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2134 | if (dsSimulFiltered.Good()) ▸ if (current_src != null && calendar != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (all_match != nu… | DATA_OP | VerisonVsWorkModel.Add | (kv[0], kv[1]) | 데이터 객체 조작/조회 |  |  |  |
| AC-29e2d4a6 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2148 | if (dsSimulFiltered.Good()) ▸ if (current_src != null && calendar != null) ▸ foreach (DataRow row in current_src.Rows) ▸ for (i < 5) ▸ if (c… | DATA_OP | sel_version.Contains | (curversion) | 데이터 객체 조작/조회 |  |  |  |
| AC-74c934b6 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2150 | if (dsSimulFiltered.Good()) ▸ if (current_src != null && calendar != null) ▸ foreach (DataRow row in current_src.Rows) ▸ for (i < 5) ▸ if (c… | GRID_STYLE | siSimul.SetBGColor2 | (rowindex, colidx, rowindex, colidx, colorS) | 그리드 표시 설정 |  |  |  |
| AC-60c4d6a7 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2154 | if (dsSimulFiltered.Good()) ▸ if (current_src != null && calendar != null) ▸ foreach (DataRow row in current_src.Rows) ▸ for (i < 5) ▸ if (c… | GRID_STYLE | siSimul.SetBGColor2 | (rowindex, colidx, rowindex, colidx, colorD) | 그리드 표시 설정 |  |  |  |
| AC-8084ffd7 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2155 | if (dsSimulFiltered.Good()) ▸ if (current_src != null && calendar != null) ▸ foreach (DataRow row in current_src.Rows) ▸ for (i < 5) ▸ if (c… | GRID_STYLE | siSimul.SetFGColor2 | (rowindex, colidx, rowindex, colidx, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-a55b3474 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2184 | if (calendar != null && dsSimulFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fbf6c5e7 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2188 | if (calendar != null && dsSimulFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if… | GRID_SET | siSimul.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-d341c87c | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2190 | if (calendar != null && dsSimulFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c981c7a9 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2194 | if (calendar != null && dsSimulFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if… | GRID_SET | siSimul.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-8915bff4 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2209 | if (calendar != null && dsSimulFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_item in calendar.Weeks) ▸… | GRID_STYLE | siSimul.SetBGColor3 | (0, index, dsSimulFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(… | 그리드 표시 설정 |  |  |  |
| AC-23fd812e | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2224 | if (calendar != null && dsSimulFiltered.Good()) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var month_item in calendar.Month… | GRID_STYLE | siSimul.SetBGColor3 | (0, index, dsSimulFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink… | 그리드 표시 설정 |  |  |  |
| AC-267266d3 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2230 |  | DATA_OP | Filter2["DIVISION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fbe46bad | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2231 |  | DATA_OP | Filter2["SITE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-df89876f | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2232 |  | DATA_OP | Filter2["ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bcd686a0 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2233 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("DIO", "list_dio", Filter2.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_dio] \| FP\MASTER\DIO#list… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2f500d52 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2261 | if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ foreach (FarPoint.Win.Spread.Row arow in siSimul.Active… | DATA_OP | lookup.Tables[0].Select | ("DIVISION_ID = '" + division_id + "' AND " + "SITE_ID = '" + site_id + "' AND " + "ITEM_I… | 데이터 객체 조작/조회 |  |  |  |
| AC-d9a55628 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2330 | if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ foreach (FarPoint.Win.Spread.Row arow in siSimul.Active… | GRID_SET | siSimul.ActiveSheet.Cells[arow.Index, colidx].ForeColor | red | 그리드 속성/값 설정 |  |  |  |
| AC-f6ac18c1 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2331 | if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ foreach (FarPoint.Win.Spread.Row arow in siSimul.Active… | GRID_SET | siSimul.ActiveSheet.Cells[arow.Index, colidx].BackColor | grey | 그리드 속성/값 설정 |  |  |  |
| AC-10f3bbf3 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2335 | if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ foreach (FarPoint.Win.Spread.Row arow in siSimul.Active… | GRID_SET | siSimul.ActiveSheet.Cells[arow.Index, colidx].BackColor | grey | 그리드 속성/값 설정 |  |  |  |
| AC-6985ab75 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2339 | if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ foreach (FarPoint.Win.Spread.Row arow in siSimul.Active… | GRID_SET | siSimul.ActiveSheet.Cells[arow.Index, colidx].BackColor | orangeLight | 그리드 속성/값 설정 |  |  |  |
| AC-7a0a94ac | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2343 | if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ foreach (FarPoint.Win.Spread.Row arow in siSimul.Active… | GRID_SET | siSimul.ActiveSheet.Cells[arow.Index, colidx].BackColor | orange | 그리드 속성/값 설정 |  |  |  |
| AC-e68a8038 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2347 | if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ foreach (FarPoint.Win.Spread.Row arow in siSimul.Active… | GRID_SET | siSimul.ActiveSheet.Cells[arow.Index, colidx].BackColor | red | 그리드 속성/값 설정 |  |  |  |
| AC-cf686fd8 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2350 | if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ foreach (FarPoint.Win.Spread.Row arow in siSimul.Active… | GRID_SET | siSimul.ActiveSheet.Cells[arow.Index, colidx].CellType | numCell | 그리드 속성/값 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.drpPeriod_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8c63c5f | dCalendar_planrange.ValueChanged | FP00623_Pancake_Simulation_Elec.cs:573 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c22fa07 | dCalendar_planrange.ValueChanged | FP00623_Pancake_Simulation_Elec.cs:580 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-7522f1d1 | dCalendar_planrange.ValueChanged | FP00623_Pancake_Simulation_Elec.cs:581 | if (dayCount > 366) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37a632ca | EditButton | FP00623_Pancake_Simulation_Elec.cs:856 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00623_Pancake_Simulation_Elec.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d9a65c1 | ExcelButton | FP00623_Pancake_Simulation_Elec.cs:696 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00623_Pancake_Simulation_Elec.FindBohData

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00623_PANCAKE_SIMUL_ELEC") ▸ if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY")] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ lambda] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ lambda] / FindButton [try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ t…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1108e35a | popSql.OnSql [else of (programID == "PR_UI_FP00623_PANCAKE_S… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1982 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY", Filter, CurrentUser, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-afaf3586 | popSql.OnSql [else of (programID == "PR_UI_FP00623_PANCAKE_S… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1983 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-483c9107 | popSql.OnSql [else of (programID == "PR_UI_FP00623_PANCAKE_S… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1987 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00623_Pancake_Simulation_Elec.FindSimulData

진입점: popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_ELEC")] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ lambda] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ lambda] / FindButton [try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8da52864 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1943 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00623_PANCAKE_SIMUL_ELEC", Filter, CurrentUser, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-38fb384f | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1945 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-35eba947 | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1949 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00623_Pancake_Simulation_Elec.FindTotalColorStart

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ba6d1d5 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:673 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00623_Pancake_Simulation_Elec.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28d298b8 | this.Load | FP00623_Pancake_Simulation_Elec.cs:144 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00623_Pancake_Simulation_Elec.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_ELEC") ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try] / FindButton [try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f440d5af | popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_… 외 3 | FP00623_Pancake_Simulation_Elec.cs:1300 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00623_Pancake_Simulation_Elec.GetIsPast

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / chk_release.CheckedChanged [if (chk_release.Checked)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffe9506b | this.Load 외 2 | FP00623_Pancake_Simulation_Elec.cs:342 |  | FLAG | dtIsPast | Data_FP.CallGeneralProcedure2(("PR_UI_FP00623_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-c804c65b | this.Load 외 2 | FP00623_Pancake_Simulation_Elec.cs:342 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00623_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "IS_PAST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00623_Pancake_Simulation_Elec.GetPlanGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2614751 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:336 |  | FLAG | dtInstance | Data_FP.CallGeneralProcedure2(("PR_UI_FP00623_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-81cd9e86 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:336 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00623_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "INSTANCE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6d03d5fc | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:337 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00623_Pancake_Simulation_Elec.GetPlanId

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / drpPlanDate.ValueChanged / chk_release.CheckedChanged [else of (chk_release.Checked)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-303d8fb5 | this.Load 외 3 | FP00623_Pancake_Simulation_Elec.cs:300 |  | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP00623_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-2b77ea33 | this.Load 외 3 | FP00623_Pancake_Simulation_Elec.cs:300 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00623_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-184b1bcf | this.Load 외 3 | FP00623_Pancake_Simulation_Elec.cs:302 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cboPlanId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d66fd16c | this.Load 외 3 | FP00623_Pancake_Simulation_Elec.cs:305 | if (cboPlanId.Items.Count > 0) | VALUE_SET | cboPlanId.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.GetPlanPeriod

진입점: this.Load / drpPlanDate.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b712f82d | this.Load 외 1 | FP00623_Pancake_Simulation_Elec.cs:353 | if (!dtPlanId.Good()) | UI_PROP | dCalendar_planrange.Value1 | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-b2834558 | this.Load 외 1 | FP00623_Pancake_Simulation_Elec.cs:354 | if (!dtPlanId.Good()) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-bf74336c | this.Load 외 1 | FP00623_Pancake_Simulation_Elec.cs:377 | else of (!dtPlanId.Good()) | UI_PROP | dCalendar_planrange.Text1 | sStart | 속성 Text1 설정 |  |  |  |
| AC-cd0e3b2a | this.Load 외 1 | FP00623_Pancake_Simulation_Elec.cs:378 | else of (!dtPlanId.Good()) | UI_PROP | dCalendar_planrange.Text2 | sEnd | 속성 Text2 설정 |  |  |  |
| AC-8f9e8721 | this.Load 외 1 | FP00623_Pancake_Simulation_Elec.cs:382 |  | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-3e99cb2c | this.Load 외 1 | FP00623_Pancake_Simulation_Elec.cs:383 |  | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00623_Pancake_Simulation_Elec.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d3b2477 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1316 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP00623_Pancake_Simulation_Elec.GoDrawCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82e232eb | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:863 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4404e75b | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:865 |  | UI_MISC | siSimul.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f949b350 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:928 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-235e97ed | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:929 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siSimul.SetBGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-9bc8e349 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1005 |  | UI_MISC | siSimul.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00623_Pancake_Simulation_Elec.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee67d344 | this.Load | FP00623_Pancake_Simulation_Elec.cs:159 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b06eee0d | this.Load | FP00623_Pancake_Simulation_Elec.cs:163 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-38b49857 | this.Load | FP00623_Pancake_Simulation_Elec.cs:164 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-39dfdfec | this.Load | FP00623_Pancake_Simulation_Elec.cs:168 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-fe4074b6 | this.Load | FP00623_Pancake_Simulation_Elec.cs:173 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bede0326 | this.Load | FP00623_Pancake_Simulation_Elec.cs:179 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-415e8ee5 | this.Load | FP00623_Pancake_Simulation_Elec.cs:181 |  | FLAG | dtCellType | Data_FP.CallGeneralProcedure2(("PR_UI_FP00623_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-396d02e1 | this.Load | FP00623_Pancake_Simulation_Elec.cs:181 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00623_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "CELL_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4d3664d2 | this.Load | FP00623_Pancake_Simulation_Elec.cs:182 |  | LIST_REBIND | clsCtrl.setListBox | (dtCellType, cboCellType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ee165a10 | this.Load | FP00623_Pancake_Simulation_Elec.cs:184 |  | FLAG | dtPancakeType | Data_FP.CallGeneralProcedure2(("PR_UI_FP00623_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-cf904983 | this.Load | FP00623_Pancake_Simulation_Elec.cs:184 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00623_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PANCAKE_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-76fd2e93 | this.Load | FP00623_Pancake_Simulation_Elec.cs:185 |  | LIST_REBIND | clsCtrl.setListBox | (dtPancakeType, cboPancakeType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5e26a0b0 | this.Load | FP00623_Pancake_Simulation_Elec.cs:187 |  | FLAG | dtInstance | Data_FP.CallGeneralProcedure2(("PR_UI_FP00623_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-43e9dfc9 | this.Load | FP00623_Pancake_Simulation_Elec.cs:187 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00623_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "INSTANCE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-78d0469d | this.Load | FP00623_Pancake_Simulation_Elec.cs:189 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-f2bc3dd2 | this.Load | FP00623_Pancake_Simulation_Elec.cs:191 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a16bceae | this.Load | FP00623_Pancake_Simulation_Elec.cs:194 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-59f83cc4 | this.Load | FP00623_Pancake_Simulation_Elec.cs:196 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-8f10689b | this.Load | FP00623_Pancake_Simulation_Elec.cs:196 |  | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-1079b9c3 | this.Load | FP00623_Pancake_Simulation_Elec.cs:214 |  | FLAG | dtUomType | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP00623_Pancake_simulation", "UOM_T… | 화면 필드/플래그 변경 |  |  |  |
| AC-e2441c2e | this.Load | FP00623_Pancake_Simulation_Elec.cs:214 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP00623_Pancake_simulation", "UOM_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-163172ba | this.Load | FP00623_Pancake_Simulation_Elec.cs:220 |  | LIST_REBIND | clsCtrl.setListBox | (dtUomType, cboUomType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-66ae7ecf | this.Load | FP00623_Pancake_Simulation_Elec.cs:222 |  | FLAG | dtUnit | new DataTable("Table") | 화면 필드/플래그 변경 |  |  |  |
| AC-c6cf108f | this.Load | FP00623_Pancake_Simulation_Elec.cs:223 |  | DATA_OP | dtUnit.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-84f8c647 | this.Load | FP00623_Pancake_Simulation_Elec.cs:224 |  | DATA_OP | dtUnit.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-194a4f04 | this.Load | FP00623_Pancake_Simulation_Elec.cs:225 |  | DATA_OP | dtUnit.Rows.Add | ("1", "1") | 데이터 객체 조작/조회 |  |  |  |
| AC-271d8ed1 | this.Load | FP00623_Pancake_Simulation_Elec.cs:226 |  | DATA_OP | dtUnit.Rows.Add | ("1000", "1,000") | 데이터 객체 조작/조회 |  |  |  |
| AC-fcb19556 | this.Load | FP00623_Pancake_Simulation_Elec.cs:227 |  | LIST_REBIND | clsCtrl.setListBox | (dtUnit, cboUnit, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00623_Pancake_Simulation_Elec.InitSpread

진입점: this.Load / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try] / FindButton [try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2e611a7 | this.Load 외 3 | FP00623_Pancake_Simulation_Elec.cs:611 | try | GRID_INIT | siSimul.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d094bd63 | this.Load 외 3 | FP00623_Pancake_Simulation_Elec.cs:612 | try | GRID_INIT | siSimul.ChangeActiveSheet | (SpdSheet.shtSimul) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-50182d0d | this.Load 외 3 | FP00623_Pancake_Simulation_Elec.cs:614 | try | GRID_INIT | siSimul.SetSheetHeaderColumn_FP | (siSimul, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-e250fadd | this.Load 외 3 | FP00623_Pancake_Simulation_Elec.cs:618 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00623_Pancake_Simulation_Elec.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b96f3551 | InsertButton | FP00623_Pancake_Simulation_Elec.cs:840 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00623_Pancake_Simulation_Elec.RefreshHeadAndBody_Simul

진입점: cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ if (!dsSimulDate.Good())] / this.spdMain.CellDoubleClick [try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!dsSimulDate.Good())] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsSimulDate != null) ▸ if (dsSimulDate != null) ▸ if (!dsSimulDate.Good())] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsSimulDate != null) ▸ if (dsSimulDate != null) ▸ if (!dsSimulDate.Good())] / this.btn_column.Click [if (frm.DialogResult == Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2929e797 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2022 | try | UI_MISC | siSimul.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-44c77738 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2037 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-7848cd67 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null) ▸ … 외 5 | FP00623_Pancake_Simulation_Elec.cs:2041 | finally | UI_MISC | siSimul.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00623_Pancake_Simulation_Elec.RefreshSpreadSheet_Simul

진입점: cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] / this.spdMain.CellDoubleClick [try ▸ if (colname.ToUpper().Contains("STOCK_VERSION"))] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsSimulDate != null) ▸ if (dsSimulDate != null)] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsSimulDate != null) ▸ if (dsSimulDate != null)] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsSimulDate != null)] / FindButton [try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e390fb9b | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1619 | if (!dsSimulDate.Good()) | FLAG | dsSimulFiltered | dsSimulDate.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-47956950 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1619 | if (!dsSimulDate.Good()) | DATA_OP | dsSimulDate.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-959255e7 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1621 | if (!dsSimulDate.Good()) | GRID_LOCK | siSimul.LockColumn | (0, siSimul.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-014c59e9 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1622 | if (!dsSimulDate.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-82fd6e1b | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1624 |  | DATA_OP | this.dsSimulDate.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-943f5839 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1639 | if (uom_cell) ▸ for (i < daymax) | DATA_OP | colname_src[i] | string.Format("D{0}_CELL", i) | 행/컬럼 값 대입 |  |  |  |
| AC-49014b8a | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1640 | if (uom_cell) ▸ for (i < daymax) | DATA_OP | colname_tar[i] | string.Format("D{0}", i) | 행/컬럼 값 대입 |  |  |  |
| AC-f559da3a | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1650 | if (uom_cell) ▸ for (j < rowscnt) ▸ for (i < daymax) | DATA_OP | row[colname_tar[i]] | row[colname_src[i]] | 행/컬럼 값 대입 |  |  |  |
| AC-2d9c7e3d | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1657 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("GOOD_STOCK_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-443214cd | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1658 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("GOOD_REWORK_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-058e9d9d | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1659 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("GOOD_BOFORE_NT_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-58cb2cd6 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1661 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("QMS_STOCK_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d403a52f | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1662 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("QMS_REWORK_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c305496 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1663 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("QMS_BOFORE_NT_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-68838b64 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1665 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("GMES_STOCK_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0776056 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1666 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("GMES_REWORK_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f6ae87a | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1667 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("GMES_BOFORE_NT_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c040b2d2 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1669 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("PANCAKE_GOOD_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc292a5f | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1670 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("PANCAKE_GOOD_QTY_SUM2", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bad5f648 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1672 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("RECEIPT_GOOD_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-08de7969 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1673 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("RECEIPT_HOLD_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b29bb377 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1675 |  | CALL_EXT | simulData.Tables[0].AsEnumerable().GroupBy | (x => new { COMPANY_ID = x.Field<string>("COMPANY_ID"), DIVISION_ID = x.Field<string>("DIV… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0387aa42 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1677 | lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-de15b5ae | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1678 | lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2c2639df | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1679 | lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-11d9a8a8 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1680 | lambda | DATA_OP | x.Field | ("PROD_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-511a2ea9 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1681 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c824d190 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1682 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dac7a38e | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1694 | if (uom_cell) ▸ foreach (DataRow row in simulData.Tables[0].Rows) | DATA_OP | row["RECEIPT_GOOD_QTY_SUM"] | row["RECEIPT_GOOD_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-71c0a95a | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1695 | if (uom_cell) ▸ foreach (DataRow row in simulData.Tables[0].Rows) | DATA_OP | row["RECEIPT_HOLD_QTY_SUM"] | row["RECEIPT_HOLD_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-b5ab3338 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1697 | if (uom_cell) ▸ foreach (DataRow row in simulData.Tables[0].Rows) | DATA_OP | row["PANCAKE_GOOD_QTY_SUM2"] | row["RECEIPT_GOOD_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-ef117b13 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1704 | else of (uom_cell) ▸ foreach (DataRow row in simulData.Tables[0].Rows) | DATA_OP | row["RECEIPT_GOOD_QTY_SUM"] | row["RECEIPT_GOOD_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-a5c5d9f3 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1705 | else of (uom_cell) ▸ foreach (DataRow row in simulData.Tables[0].Rows) | DATA_OP | row["RECEIPT_HOLD_QTY_SUM"] | row["RECEIPT_HOLD_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-6be56abc | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1707 | else of (uom_cell) ▸ foreach (DataRow row in simulData.Tables[0].Rows) | DATA_OP | row["PANCAKE_GOOD_QTY_SUM2"] | row["RECEIPT_GOOD_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-2c198d42 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1729 | foreach (var group_version in group3) ▸ if (fRow != null) | CALL_EXT | simulData.Tables[0].AsEnumerable() .Where(x => ( x.Field<string>("COMPANY_ID") == fRow["CO… | (r => { r["GOOD_STOCK_QTY_SUM"] = 0; r["GOOD_REWORK_QTY_SUM"] = 0; r["GOOD_BOFORE_NT_QTY_S… | ⚠ 의미 확인 필요 |  |  |  |
| AC-34a47173 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1731 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c7127918 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1732 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-aee5a994 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1733 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f38e88ad | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1734 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | x.Field | ("PROD_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-873de1de | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1735 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f8f89754 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1736 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e3b9a09 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1740 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["GOOD_STOCK_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-db733cb0 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1741 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["GOOD_REWORK_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-970b0961 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1742 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["GOOD_BOFORE_NT_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-5c37953a | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1744 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["QMS_STOCK_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-3416a124 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1745 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["QMS_REWORK_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-45494d5b | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1746 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["QMS_BOFORE_NT_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-479b7a30 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1748 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["GMES_STOCK_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-c4931b70 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1749 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["GMES_REWORK_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-0310e54a | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1750 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["GMES_BOFORE_NT_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-d7de856a | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1752 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["PANCAKE_GOOD_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-3621df06 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1764 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) | CALL_EXT | dsSimulBoh.Tables[0].AsEnumerable() .Where(x => ( x.Field<string>("COMPANY_ID") == c["COMP… | (r => { if (uom_cell) { c["GOOD_STOCK_QTY_SUM"] = c["GOOD_STOCK_QTY_SUM"].SafeDouble() + r… | ⚠ 의미 확인 필요 |  |  |  |
| AC-246623a4 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1766 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-994fccc9 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1767 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d48768d | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1768 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-50e91d05 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1769 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda | DATA_OP | x.Field | ("PROD_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-bb580abd | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1770 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d6a899a8 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1771 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda | DATA_OP | version_all.Contains | (x.Field<string>("VERSION")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0101ddb7 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1771 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda | DATA_OP | x.Field | ("VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-4985d7be | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1777 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["GOOD_STOCK_QTY_SUM"] | c["GOOD_STOCK_QTY_SUM"].SafeDouble() + r["GOOD_STOCK_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-e7298d02 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1778 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["GOOD_REWORK_QTY_SUM"] | c["GOOD_REWORK_QTY_SUM"].SafeDouble() + r["GOOD_REWORK_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-d6487c02 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1779 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["GOOD_BOFORE_NT_QTY_SUM"] | c["GOOD_BOFORE_NT_QTY_SUM"].SafeDouble() + r["GOOD_BOFORE_NT_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-4f32dd88 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1781 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["QMS_STOCK_QTY_SUM"] | c["QMS_STOCK_QTY_SUM"].SafeDouble() + r["QMS_STOCK_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-cc01ccf6 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1782 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["QMS_REWORK_QTY_SUM"] | c["QMS_REWORK_QTY_SUM"].SafeDouble() + r["QMS_REWORK_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-b94e141f | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1783 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["QMS_BOFORE_NT_QTY_SUM"] | c["QMS_BOFORE_NT_QTY_SUM"].SafeDouble() + r["QMS_BOFORE_NT_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-669e918b | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1785 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["GMES_STOCK_QTY_SUM"] | c["GMES_STOCK_QTY_SUM"].SafeDouble() + r["GMES_STOCK_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-1e5c1067 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1786 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["GMES_REWORK_QTY_SUM"] | c["GMES_REWORK_QTY_SUM"].SafeDouble() + r["GMES_REWORK_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-8743fb72 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1787 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["GMES_BOFORE_NT_QTY_SUM"] | c["GMES_BOFORE_NT_QTY_SUM"].SafeDouble() + r["GMES_BOFORE_NT_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-cd545773 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1791 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["PANCAKE_GOOD_QTY_SUM"] | c["PANCAKE_GOOD_QTY_SUM"].SafeDouble() + r["PANCAKE_GOOD_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-e49ff035 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1792 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["PANCAKE_GOOD_QTY_SUM2"] | c["PANCAKE_GOOD_QTY_SUM2"].SafeDouble() + r["PANCAKE_GOOD_CELL_QTY2"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-20b02ba7 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1797 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["GOOD_STOCK_QTY_SUM"] | c["GOOD_STOCK_QTY_SUM"].SafeDouble() + r["GOOD_STOCK_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-7a8c8d88 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1798 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["GOOD_REWORK_QTY_SUM"] | c["GOOD_REWORK_QTY_SUM"].SafeDouble() + r["GOOD_REWORK_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-b662ccfd | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1799 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["GOOD_BOFORE_NT_QTY_SUM"] | c["GOOD_BOFORE_NT_QTY_SUM"].SafeDouble() + r["GOOD_BOFORE_NT_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-713a415d | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1801 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["QMS_STOCK_QTY_SUM"] | c["QMS_STOCK_QTY_SUM"].SafeDouble() + r["QMS_STOCK_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-505f5800 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1802 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["QMS_REWORK_QTY_SUM"] | c["QMS_REWORK_QTY_SUM"].SafeDouble() + r["QMS_REWORK_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-7bcb9978 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1803 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["QMS_BOFORE_NT_QTY_SUM"] | c["QMS_BOFORE_NT_QTY_SUM"].SafeDouble() + r["QMS_BOFORE_NT_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-0284e886 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1805 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["GMES_STOCK_QTY_SUM"] | c["GMES_STOCK_QTY_SUM"].SafeDouble() + r["GMES_STOCK_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-df96b1bf | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1806 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["GMES_REWORK_QTY_SUM"] | c["GMES_REWORK_QTY_SUM"].SafeDouble() + r["GMES_REWORK_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-f1d4aa35 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1807 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["GMES_BOFORE_NT_QTY_SUM"] | c["GMES_BOFORE_NT_QTY_SUM"].SafeDouble() + r["GMES_BOFORE_NT_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-d5e6c129 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1810 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["PANCAKE_GOOD_QTY_SUM"] | c["PANCAKE_GOOD_QTY_SUM"].SafeDouble() + r["PANCAKE_GOOD_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-9c28d835 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1811 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["PANCAKE_GOOD_QTY_SUM2"] | c["PANCAKE_GOOD_QTY_SUM2"].SafeDouble() + r["PANCAKE_GOOD_QTY2"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-1803b142 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1822 |  | CALL_EXT | simulData.Tables[0].AsEnumerable().GroupBy | (x => new { COMPANY_ID = x.Field<string>("COMPANY_ID"), DIVISION_ID = x.Field<string>("DIV… | ⚠ 의미 확인 필요 |  |  |  |
| AC-98b3a4aa | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1824 | lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad3a3466 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1825 | lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bcb40968 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1826 | lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2976eaf1 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1827 | lambda | DATA_OP | x.Field | ("PROD_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-846458a6 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1828 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-34af6e36 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1862 | foreach (var triple in dateworker) | CALL_EXT | DateTime.TryParseExact | (plan_date, "yyyyMMdd", enUS, System.Globalization.DateTimeStyles.None, out pDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-37619633 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1874 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) | DATA_OP | DIO_Row[day_colname] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-af7c6c6b | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1879 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ if (d.Date == pDat… | DATA_OP | Inventory_Row[day_colname] | Assy_Row["PANCAKE_GOOD_QTY_SUM2"].SafeDouble() - Assy_Row[day_colname].SafeDouble() + Coat… | 행/컬럼 값 대입 |  |  |  |
| AC-f292487b | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1887 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ else of (d.Date ==… | DATA_OP | Inventory_Row[day_colname] | Inventory_Row[prev_day_colname].SafeDouble() - Assy_Row[day_colname].SafeDouble() + Coater… | 행/컬럼 값 대입 |  |  |  |
| AC-148f11c1 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1895 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ if (assy == 0) ▸ i… | DATA_OP | DIO_Row[day_colname] | 365 | 행/컬럼 값 대입 |  |  |  |
| AC-fdb200e7 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1897 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ if (assy == 0) ▸ e… | DATA_OP | DIO_Row[day_colname] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-efc5df90 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1899 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ if (assy == 0) ▸ e… | DATA_OP | DIO_Row[day_colname] | -365 | 행/컬럼 값 대입 |  |  |  |
| AC-96743bc0 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1902 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ else of (assy == 0… | DATA_OP | DIO_Row[day_colname] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-db21ba03 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1906 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ else of (assy == 0… | CALL_EXT | Math.Truncate | (dio * 10.0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f8a471eb | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1907 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ else of (assy == 0… | DATA_OP | DIO_Row[day_colname] | dio | 행/컬럼 값 대입 |  |  |  |
| AC-65054c30 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1927 |  | FLAG | dsSimulFiltered | simulData | 화면 필드/플래그 변경 |  |  |  |
| AC-2a478f69 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 5 | FP00623_Pancake_Simulation_Elec.cs:1931 | if (dsSimulFiltered.Good()) | GRID_LOCK | siSimul.LockColumn | (0, siSimul.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00623_Pancake_Simulation_Elec.RestoreView_Simul

진입점: cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] / this.spdMain.CellDoubleClick [try ▸ if (colname.ToUpper().Contains("STOCK_VERSION"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cf45d32 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 1 | FP00623_Pancake_Simulation_Elec.cs:554 |  | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00623_Pancake_Simulation_Elec.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c329be2 | popSql.OnSql | FP00623_Pancake_Simulation_Elec.cs:1346 | if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_ELEC") | RETURN | return FindSimulData(false); |  | 처리 중단/반환 |  |  |  |
| AC-cf5b82c6 | popSql.OnSql | FP00623_Pancake_Simulation_Elec.cs:1350 | else of (programID == "PR_UI_FP00623_PANCAKE_SIMUL_ELEC") ▸ if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY") | RETURN | return FindBohData(false); |  | 처리 중단/반환 |  |  |  |
| AC-ba67e892 | popSql.OnSql | FP00623_Pancake_Simulation_Elec.cs:1352 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00623_Pancake_Simulation_Elec.SaveView_Simul

진입점: cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] / this.spdMain.CellDoubleClick [try ▸ if (colname.ToUpper().Contains("STOCK_VERSION"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71e2a9a6 | cboUomType.SelectedIndexChanged [if (dsSimulDate != null)] 외 1 | FP00623_Pancake_Simulation_Elec.cs:549 |  | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00623_Pancake_Simulation_Elec.SetCurrentDate

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / chk_release.CheckedChanged [if (chk_release.Checked)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2172a342 | this.Load 외 2 | FP00623_Pancake_Simulation_Elec.cs:397 |  | VALUE_SET | drpPlanDate.Value | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a89b0805 | this.Load | FP00623_Pancake_Simulation_Elec.cs:118 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-476bcaee | this.Load | FP00623_Pancake_Simulation_Elec.cs:120 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0c7468ae | this.Load | FP00623_Pancake_Simulation_Elec.cs:124 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2240159b | this.Load | FP00623_Pancake_Simulation_Elec.cs:126 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.SetFilter

진입점: this.Load / cbo_plan_group.SelectedIndexChanged [if (dtInstance.Good())] / cboPlanId.SelectedIndexChanged [if (cboPlanId.SelectedIndex > -1)] / edtTopItemId.TextChanged / edtItem.TextChanged / edtNickName.TextChanged / edtModelNickName.TextChanged / cboCellType.SelectedIndexChanged / cboPancakeType.SelectedIndexChanged / cboUomType.SelectedIndexChanged / cboUnit.SelectedIndexChanged / dCalendar_planrange.ValueChanged / drpPlanDate.ValueChanged / chk_release.CheckedChanged [if (chk_release.Checked)] / chkTotal.CheckedChanged / popSql.OnSql [if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_ELEC") ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86aa02d4 | this.Load 외 18 | FP00623_Pancake_Simulation_Elec.cs:1295 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00623_Pancake_Simulation_Elec.SetInventory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2707ecd5 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1144 |  | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-0ffb49f8 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1145 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-30b82a63 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1146 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-d34fd6fd | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1147 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-6f7914b9 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1149 |  | DATA_OP | dsResult.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-53d43081 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1174 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-23dae891 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1175 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a1870fdb | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1176 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ lambda | DATA_OP | x.Field | ("MODEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-12ad21f9 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1177 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-26b14c18 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1172 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == row["DIVISION_ID"].ToString() && x.Fi… |  | 처리 중단/반환 |  |  |  |
| AC-04ee00eb | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1191 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ foreach (DataRow related_row in relating… | DATA_OP | loc.ASSY.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-96342182 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1194 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ foreach (DataRow related_row in relating… | DATA_OP | loc.POST.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a4b35b6 | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1197 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ foreach (DataRow related_row in relating… | DATA_OP | loc.COATER.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0c0108b | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1200 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ foreach (DataRow related_row in relating… | DATA_OP | loc.SHIP.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd6160fd | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1203 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ foreach (DataRow related_row in relating… | DATA_OP | loc.SHIP_IN.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3dbe74a | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1234 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ if (relating_rows.Count() > 0) ▸ foreach… | CALL_EXT | Convert.ToInt16 | (sColName.Substring(1, lastIndex - 1)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2636e58d | (진입점 미연결) | FP00623_Pancake_Simulation_Elec.cs:1259 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ if (relating_rows.Count() > 0) ▸ foreach… | DATA_OP | row[sColName] | Convert.ToDecimal(nInv) | 행/컬럼 값 대입 |  |  |  |

## FP00623_Pancake_Simulation_Elec.SetSpreadInit

진입점: this.Load [try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null) ▸ try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ try] / FindButton [try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65875357 | this.Load [try] 외 3 | FP00623_Pancake_Simulation_Elec.cs:626 | if (sheetName.Equals(SpdSheet.shtSimul)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1792a942 | this.Load [try] 외 3 | FP00623_Pancake_Simulation_Elec.cs:627 | if (sheetName.Equals(SpdSheet.shtSimul)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-276357f1 | this.spdMain.ButtonClicked | FP00623_Pancake_Simulation_Elec.cs:1583 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3f48e4e | this.spdMain.CellClick | FP00623_Pancake_Simulation_Elec.cs:1442 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdMain_ChildControlDeactivated

진입점: this.spdMain.ChildControlDeactivated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a778a696 | this.spdMain.ChildControlDeactivated | FP00623_Pancake_Simulation_Elec.cs:1540 |  | VALUE_SET | tbLog.Text | "spdMain_ChildControlDeactivated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdMain_DragFillBlockCompleted

진입점: this.spdMain.DragFillBlockCompleted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3490d087 | this.spdMain.DragFillBlockCompleted | FP00623_Pancake_Simulation_Elec.cs:1550 |  | VALUE_SET | tbLog.Text | "spdMain_DragFillBlockCompleted" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-107917c0 | this.spdMain.EditChange | FP00623_Pancake_Simulation_Elec.cs:1434 |  | VALUE_SET | tbLog.Text | "spdMain_EditChange" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb3ac41d | this.spdMain.EditModeOff | FP00623_Pancake_Simulation_Elec.cs:1568 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5830153 | this.spdMain.EditModeOn | FP00623_Pancake_Simulation_Elec.cs:1574 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-2a1f637a | this.spdMain.EditModeOn | FP00623_Pancake_Simulation_Elec.cs:1575 |  | FLAG | EditingValue | siSimul.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9724e496 | this.spdMain.EditorFocused | FP00623_Pancake_Simulation_Elec.cs:1562 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdMain_Enter

진입점: this.spdMain.Enter

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62841828 | this.spdMain.Enter | FP00623_Pancake_Simulation_Elec.cs:1525 |  | VALUE_SET | tbLog.Text | "spdMain_Enter" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdMain_Leave

진입점: this.spdMain.Leave

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80b2a38c | this.spdMain.Leave | FP00623_Pancake_Simulation_Elec.cs:1520 |  | VALUE_SET | tbLog.Text | "spdMain_Leave" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdMain_SubEditorClosed

진입점: this.spdMain.SubEditorClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-754c43c2 | this.spdMain.SubEditorClosed | FP00623_Pancake_Simulation_Elec.cs:1556 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorClosed" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdMain_SubEditorOpening

진입점: this.spdMain.SubEditorOpening

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b7a9f3d | this.spdMain.SubEditorOpening | FP00623_Pancake_Simulation_Elec.cs:1545 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorOpening" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdMain_TableChanged

진입점: this.spdMain.TableChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c884507b | this.spdMain.TableChanged | FP00623_Pancake_Simulation_Elec.cs:1422 | if (this.IsEditMode == true) ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) | CALL_EXT | dsSimulFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-742aaaa0 | this.spdMain.TableChanged | FP00623_Pancake_Simulation_Elec.cs:1424 | if (this.IsEditMode == true) ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ if (row != null) ▸ if (siSimul.ActiveSheet.RowCount… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdMain_TextChanged

진입점: this.spdMain.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6a15fdb | this.spdMain.TextChanged | FP00623_Pancake_Simulation_Elec.cs:1405 | if (this.IsEditMode == true) ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) | CALL_EXT | dsSimulFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c017d850 | this.spdMain.TextChanged | FP00623_Pancake_Simulation_Elec.cs:1407 | if (this.IsEditMode == true) ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ if (row != null) ▸ if (siSimul.ActiveSheet.RowCount… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdMain_Validated

진입점: this.spdMain.Validated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-327fe725 | this.spdMain.Validated | FP00623_Pancake_Simulation_Elec.cs:1530 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdMain_Validating

진입점: this.spdMain.Validating

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3717fbcf | this.spdMain.Validating | FP00623_Pancake_Simulation_Elec.cs:1535 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00623_Pancake_Simulation_Elec.spdSimul_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b8a5541 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2653 | try | DATA_OP | colname.ToUpper().Contains | ("STOCK_VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff5c87d2 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2665 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) | DATA_OP | all_v_list.Contains | (toggle_version) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4ca405b | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2667 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | sell_v_list.Contains | (toggle_version) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfd9f820 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2670 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | sell_v_list.Remove | (toggle_version) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9f63ff9 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2675 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | sell_v_list.Add | (toggle_version) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbd26b18 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2679 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | CALL_EXT | dsSimulDate.Tables[0].AsEnumerable() .Where(x => ( x.Field<string>("COMPANY_ID") == fRow["… | (r => { r["STOCK_VERSION_SEL"] = sell_list; } ) | ⚠ 의미 확인 필요 |  |  |  |
| AC-012a7d8e | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2681 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c75c0b3b | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2682 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff7c34fd | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2683 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5bef76d0 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2684 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | x.Field | ("PROD_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-58cc4b03 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2685 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b3a42e85 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2689 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | r["STOCK_VERSION_SEL"] | sell_list | 행/컬럼 값 대입 |  |  |  |
| AC-f8442737 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2705 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | CALL_EXT | BaseForm.CreateManualSearchCondtion | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4e698b3 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2706 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_division", row["DIVISION_ID"].SafeString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4364a843 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2707 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_site", row["SITE_ID"].SafeString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-245db0b1 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2708 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | CALL_EXT | BaseForm.SetManualCondition | (Msc, "txtItemID", row["ITEM_ID"].SafeString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa67bf58 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2709 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | CALL_BASE | openSubMenu | ("FPC0623", true, true, Msc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce447b65 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2717 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | DATA_OP | inputFilter["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3dd7a16b | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2718 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | DATA_OP | inputFilter["PLAN_DATE"] | Filter["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8f9fdde4 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2719 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | DATA_OP | inputFilter["DIVISION_ID"] | clicked_row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3134342f | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2720 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | DATA_OP | inputFilter["SITE_ID"] | clicked_row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a8955277 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2721 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | DATA_OP | inputFilter["ITEM_ID"] | clicked_row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d2b1ad1f | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2732 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | DATA_OP | inputFilter["DAY_VALUE"] | aDay | 행/컬럼 값 대입 |  |  |  |
| AC-ec5f80d4 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2739 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | POPUP | new FP00623_receipt_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-4be83137 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2740 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | UI_PROP | popup.Filter | inputFilter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-bd076164 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2740 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | DATA_OP | inputFilter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-386853e6 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2741 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-6489621a | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2742 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-1db9024e | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2743 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cef06541 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2754 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("GOOD_STOCK") | 데이터 객체 조작/조회 |  |  |  |
| AC-2fca0268 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2755 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("GOOD_REWORK") | 데이터 객체 조작/조회 |  |  |  |
| AC-6780d9ca | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2756 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("GOOD_BOFORE") | 데이터 객체 조작/조회 |  |  |  |
| AC-82ae64e1 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2757 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("QMS_STOCK") | 데이터 객체 조작/조회 |  |  |  |
| AC-ec2ba334 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2758 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("QMS_REWORK") | 데이터 객체 조작/조회 |  |  |  |
| AC-5dbba0df | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2759 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("QMS_BOFORE_NT") | 데이터 객체 조작/조회 |  |  |  |
| AC-09346218 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2760 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("GMES_STOCK") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff53efd0 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2761 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("GMES_REWORK") | 데이터 객체 조작/조회 |  |  |  |
| AC-35437428 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2762 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("GMES_BOFORE_NT") | 데이터 객체 조작/조회 |  |  |  |
| AC-393e99c6 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2763 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("PANCAKE_GOOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-6cde992e | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2769 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["POP_TYPE"] | "BOH" | 행/컬럼 값 대입 |  |  |  |
| AC-d87c8c3c | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2770 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c899dcfc | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2771 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["PLAN_DATE"] | Filter["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-afacb8d9 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2772 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["DIVISION_ID"] | clicked_row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-365fa868 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2773 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["SITE_ID"] | clicked_row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ab5b9260 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2774 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["ITEM_ID"] | clicked_row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-896d2190 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2777 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("GOOD_STOCK") | 데이터 객체 조작/조회 |  |  |  |
| AC-7d4ecca6 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2777 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.GOOD_ELEC_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-274b8d6f | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2778 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("GOOD_REWORK") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d108b96 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2778 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.GOOD_RW_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-7dca0001 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2779 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("GOOD_BOFORE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f9616c09 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2779 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.GOOD_ASSY_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-2bac3cb3 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2780 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("QMS_STOCK") | 데이터 객체 조작/조회 |  |  |  |
| AC-00fc1c23 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2780 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.QMS_ELEC_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-b55dda66 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2781 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("QMS_REWORK") | 데이터 객체 조작/조회 |  |  |  |
| AC-64acc611 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2781 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.QMS_RW_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-8d5a685a | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2782 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("QMS_BOFORE_NT") | 데이터 객체 조작/조회 |  |  |  |
| AC-18f4f1a1 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2782 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.QMS_ASSY_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-14ecbdc9 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2783 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("GMES_STOCK") | 데이터 객체 조작/조회 |  |  |  |
| AC-e8aca850 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2783 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.GMES_ELEC_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-027f8c50 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2784 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("GMES_REWORK") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a893563 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2784 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.GMES_RW_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-ec654416 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2785 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("GMES_BOFORE_NT") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e93cb55 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2785 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.GMES_ASSY_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-3e89a7c1 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2786 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("PANCAKE_GOOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-e91f3fff | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2786 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.GOOD_ELEC_QTY + A.GOOD_RW_QTY + A.GOOD_ASSY_QTY > 0 AND A.LANE = 1" | 행/컬럼 값 대입 |  |  |  |
| AC-a05aafea | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2804 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_VERSION_LT"] | "AND A.VERSION IN ( " + sVer + " )" | 행/컬럼 값 대입 |  |  |  |
| AC-a4495133 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2808 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_VERSION_LT"] | "AND A.VERSION IS NULL" | 행/컬럼 값 대입 |  |  |  |
| AC-adf5295d | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2812 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | POPUP | new FP00623_InvDetail_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-05f27d8e | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2813 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | UI_PROP | popup.Filter | inputFilter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-3a0e337f | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2813 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-66cd5112 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2814 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-dcc434b0 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2815 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-3c5bbe55 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2816 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-423bb737 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2825 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | colname.ToUpper().Contains | ("RECEIPT_GOOD_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-44a1bdd5 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2826 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | colname.ToUpper().Contains | ("RECEIPT_HOLD_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-b430511e | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2831 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter["POP_TYPE"] | "RECEIPT" | 행/컬럼 값 대입 |  |  |  |
| AC-8a1fb711 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2832 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3d6df119 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2833 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter["PLAN_DATE"] | Filter["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c72f084d | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2834 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter["DIVISION_ID"] | clicked_row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2ddec871 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2835 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter["SITE_ID"] | clicked_row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fd130117 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2836 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter["ITEM_ID"] | clicked_row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b8462789 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2839 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | colname.ToUpper().Contains | ("RECEIPT_GOOD_QTY_SUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-5fc68f86 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2839 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND B.STOCK_TYPE = 'GOOD'" | 행/컬럼 값 대입 |  |  |  |
| AC-d7cd8fa4 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2840 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | colname.ToUpper().Contains | ("RECEIPT_HOLD_QTY_SUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-63cd910d | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2840 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND B.STOCK_TYPE = 'GOOD'" | 행/컬럼 값 대입 |  |  |  |
| AC-bd9d510c | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2842 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | POPUP | new FP00623_InvDetail_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-e7a0eab2 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2843 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | UI_PROP | popup.Filter | inputFilter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-173729ff | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2843 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c60a5a3d | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2844 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-5b032db0 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2845 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-064281dd | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2846 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e04d9758 | this.spdMain.CellDoubleClick | FP00623_Pancake_Simulation_Elec.cs:2858 | catch ((Exception ee)) | THROW | throw ee; |  | 예외 발생 |  |  |  |

## FP00623_Pancake_Simulation_Elec.UIFindData

진입점: this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null)] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsSimulDate != null)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c18d6222 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:709 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7cdcba79 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:710 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c749ec89 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:713 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6430a1d4 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:716 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-4c19d131 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:722 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) ▸ if (!Filter["POPUP_OPEN"].ToString().Equals("Y")) | VALUE_SET | chk_release.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-840d4039 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:729 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"]) && !Filter["RELEASE_FLAG"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("You need to select one plan to proceed") | 메시지 표시 |  |  |  |
| AC-7155d37a | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:731 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"]) && !Filter["RELEASE_FLAG"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3660ba5f | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:735 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) | GRID_LOCK | siSimul.SetLockFlag | (SpdSheet.shtSimul, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1f147900 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:742 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-dc233f7b | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:752 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ if (sInstance == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-56d47ee1 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:753 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try ▸ if (sInstance == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a576e2cf | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:760 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try | FLAG | dsSimulDate | null | 화면 필드/플래그 변경 |  |  |  |
| AC-12eed736 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:761 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e7b0fce1 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:764 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try | UI_MISC | siSimul.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9226d668 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:765 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e1171764 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:774 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-eff5af87 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:775 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try | FLAG | dsSimulDate | await proxyPivot.ExecuteAsync<DataSet>(() => FindSimulData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-76dc0e27 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:775 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try | ENDPOINT | proxyPivot.ExecuteAsync | (() => FindSimulData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0fba9541 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:778 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5d3df8ee | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:779 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-527385c1 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:781 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d8246c79 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:782 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try | FLAG | dsSimulBoh | await proxyPivot.ExecuteAsync<DataSet>(() => FindBohData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-505538a1 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:782 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try | ENDPOINT | proxyPivot.ExecuteAsync | (() => FindBohData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5e0d564f | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:786 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-44294bfd | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:790 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ try | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-70cc37bc | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:804 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8500bc2b | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:809 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-625393f1 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:811 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c14f4adc | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:813 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) ▸ finally | UI_MISC | siSimul.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1d728ac0 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:819 | try ▸ if (siSimul.ActiveSheet.SheetName == SpdSheet.shtSimul) | GRID_LOCK | siSimul.SetLockFlag | (SpdSheet.shtSimul, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e8242934 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:826 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-00a5196b | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00623_Pancake_Simulation_Elec.cs:830 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00623_PlanInfoPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f89df0d | .ctor | FP00623_PlanInfoPopup.cs:117 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-d068d99d | .ctor | FP00623_PlanInfoPopup.cs:118 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00623_PlanInfoPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d6e929c | this.btnClose.Click | FP00623_PlanInfoPopup.cs:301 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00623_PlanInfoPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4a78192 | this.Load | FP00623_PlanInfoPopup.cs:155 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-66b6ae7f | this.Load | FP00623_PlanInfoPopup.cs:156 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ddee58b5 | this.Load | FP00623_PlanInfoPopup.cs:157 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00623_PlanInfoPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f33695df | this.Load | FP00623_PlanInfoPopup.cs:150 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00623_PlanInfoPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-749069e6 | Dispose | FP00623_PlanInfoPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00623_PlanInfoPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2be52f6a | FindButton | FP00623_PlanInfoPopup.cs:190 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b10bef57 | FindButton | FP00623_PlanInfoPopup.cs:191 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3433404d | FindButton | FP00623_PlanInfoPopup.cs:193 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00623_PlanInfoPopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8ee41a0 | this.Load 외 1 | FP00623_PlanInfoPopup.cs:227 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-74e4cccd | this.Load 외 1 | FP00623_PlanInfoPopup.cs:227 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-defaf6a5 | this.Load 외 1 | FP00623_PlanInfoPopup.cs:231 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-59343137 | this.Load 외 1 | FP00623_PlanInfoPopup.cs:232 |  | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ce42ed62 | this.Load 외 1 | FP00623_PlanInfoPopup.cs:239 | try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-05c1e96f | this.Load 외 1 | FP00623_PlanInfoPopup.cs:242 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00623_ETC").ToUpper(), Filter, Filter["USER_ID"], "SELECT", "PLAN_INFO_POPUP") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a65e2dea | this.Load 외 1 | FP00623_PlanInfoPopup.cs:244 | try | CALL_BASE | this.Invoke | (new Action(delegate () { siMain.Query(set, true); siMain.LockColumn(0, siMain.GetMaxColum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a8e62432 | this.Load 외 1 | FP00623_PlanInfoPopup.cs:246 | try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-efa88e62 | this.Load 외 1 | FP00623_PlanInfoPopup.cs:247 | try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7aedfa59 | this.Load 외 1 | FP00623_PlanInfoPopup.cs:257 | finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b81649a6 | this.Load 외 1 | FP00623_PlanInfoPopup.cs:260 | finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c597b1a7 | this.Load 외 1 | FP00623_PlanInfoPopup.cs:261 | finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00623_PlanInfoPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cc6b41b | this.Load | FP00623_PlanInfoPopup.cs:126 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-db214851 | this.Load | FP00623_PlanInfoPopup.cs:128 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00623_PlanInfoPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae7bfae5 | this.Load | FP00623_PlanInfoPopup.cs:166 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-3234be06 | this.Load | FP00623_PlanInfoPopup.cs:169 | if (Filter["CONFIRM_AREA"].ToString() != "BUILDING") | GRID_INIT | siMain.SetColumnHeader | (0, 1, "Plan Group") | 그리드 재구성/초기화 |  |  |  |

## FP00623_PlanInfoPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ca26a4f | (진입점 미연결) | FP00623_PlanInfoPopup.cs:181 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00623_PlanInfoPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b6c03af | this.Load | FP00623_PlanInfoPopup.cs:175 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d676a638 | this.Load | FP00623_PlanInfoPopup.cs:176 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00623_receipt_Popup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93156d6c | (진입점 미연결) | FP00623_receipt_Popup.cs:332 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-025de1dc | (진입점 미연결) | FP00623_receipt_Popup.cs:335 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5c0608fd | (진입점 미연결) | FP00623_receipt_Popup.cs:336 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00623_receipt_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c8ab444 | this.Load | FP00623_receipt_Popup.cs:143 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-04f7676b | this.Load | FP00623_receipt_Popup.cs:144 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c8208b2a | this.Load | FP00623_receipt_Popup.cs:145 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00623_receipt_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9969599e | this.Load | FP00623_receipt_Popup.cs:138 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00623_receipt_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bcec8db | Dispose | FP00623_receipt_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00623_receipt_Popup.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2034267 | ExcelButton | FP00623_receipt_Popup.cs:207 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00623_receipt_Popup.Find_Data_Line

진입점: this.Load [try ▸ lambda] / FindButton [try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-261ce923 | this.Load [try ▸ lambda] 외 2 | FP00623_receipt_Popup.cs:265 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00623", "find_intransit_Detail", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_intransit_Detail] \| FP\Pl… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ab97ff5a | this.Load [try ▸ lambda] 외 2 | FP00623_receipt_Popup.cs:297 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-451d2f45 | this.Load [try ▸ lambda] 외 2 | FP00623_receipt_Popup.cs:301 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00623_receipt_Popup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c187e4e | this.Load 외 2 | FP00623_receipt_Popup.cs:222 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9b714a57 | this.Load 외 2 | FP00623_receipt_Popup.cs:228 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Line("SELECT", pSysFlag) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cb42a7e4 | this.Load 외 2 | FP00623_receipt_Popup.cs:235 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-94d7c234 | this.Load 외 2 | FP00623_receipt_Popup.cs:238 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5af5d6ab | this.Load 외 2 | FP00623_receipt_Popup.cs:242 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-bfd92096 | this.Load 외 2 | FP00623_receipt_Popup.cs:250 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-1ab05c0c | this.Load 외 2 | FP00623_receipt_Popup.cs:256 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP00623_receipt_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e47d9a07 | this.Load | FP00623_receipt_Popup.cs:115 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-75cd1d29 | this.Load | FP00623_receipt_Popup.cs:117 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00623_receipt_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae888205 | this.Load | FP00623_receipt_Popup.cs:155 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-acbdbd9c | this.Load | FP00623_receipt_Popup.cs:156 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00623_receipt_Popup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ac6c318 | (진입점 미연결) | FP00623_receipt_Popup.cs:177 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00623_receipt_Popup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a544f0e9 | this.Load | FP00623_receipt_Popup.cs:162 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-047c5f74 | this.Load | FP00623_receipt_Popup.cs:163 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-de2ab5bd | this.Load | FP00623_receipt_Popup.cs:167 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00623_receipt_Popup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ded034f | this.spdMain.CellClick | FP00623_receipt_Popup.cs:347 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-2d64d62c | this.spdMain.CellClick | FP00623_receipt_Popup.cs:348 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5b29eb32 | this.spdMain.CellClick | FP00623_receipt_Popup.cs:351 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00623_receipt_Popup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1603068a | this.spdMain.CellDoubleClick | FP00623_receipt_Popup.cs:357 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-84f7394b | this.spdMain.CellDoubleClick | FP00623_receipt_Popup.cs:358 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-40ebd37a | this.spdMain.CellDoubleClick | FP00623_receipt_Popup.cs:361 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-fb944d4f | this.spdMain.CellDoubleClick | FP00623_receipt_Popup.cs:364 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00623_receipt_Popup.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e60844d4 | this.spdMain.EditChange | FP00623_receipt_Popup.cs:491 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

