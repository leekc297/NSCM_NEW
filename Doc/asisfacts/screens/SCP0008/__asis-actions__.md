# AS-IS 액션 대조표 — SCP0008

> 원천: `Doc/asisfacts/screens/SCP0008/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 43행 · 메서드 9 · 종류 DATA_OP 10 · RETURN 5 · GRID_INIT 4 · UI_MISC 4 · LIST_REBIND 4 · FLAG 3 · ENDPOINT 3 · MESSAGE 2 · POPUP 2 · VALIDATE 2 · UI_PROP 2 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 0


## SCP0008_ItemMaster.checkValidItem

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d72fd6d | FindButton [try] | SCP0008_ItemMaster.cs:363 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00246", new object[] { layoutControlItem1.CustomizationFormText, "5" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-daa51a1d | FindButton [try] | SCP0008_ItemMaster.cs:366 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0008_ItemMaster.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0972b307 | this.Load | SCP0008_ItemMaster.cs:172 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5600a2e9 | this.Load | SCP0008_ItemMaster.cs:173 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-08ba892c | this.Load | SCP0008_ItemMaster.cs:174 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0008_ItemMaster.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac228319 | Dispose | SCP0008_ItemMaster.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0008_ItemMaster.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41ac31be | EditButton | SCP0008_ItemMaster.cs:250 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f7511a6d | EditButton | SCP0008_ItemMaster.cs:251 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0008_ItemMaster.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89b349cf | FindButton | SCP0008_ItemMaster.cs:259 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-db7c621c | FindButton | SCP0008_ItemMaster.cs:263 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-823b520e | FindButton | SCP0008_ItemMaster.cs:263 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d0f07696 | FindButton | SCP0008_ItemMaster.cs:265 | try ▸ if (!checkValidItem()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-94d6a39c | FindButton | SCP0008_ItemMaster.cs:271 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3d0ba331 | FindButton | SCP0008_ItemMaster.cs:287 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5ce3ea9f | FindButton | SCP0008_ItemMaster.cs:288 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6fce8891 | FindButton | SCP0008_ItemMaster.cs:292 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0008_GET_ITEM_MASTER") ⇒ SCP.SCP0008_GET_ITEM_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-24ea18c3 | FindButton | SCP0008_ItemMaster.cs:293 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a766fc5f | FindButton | SCP0008_ItemMaster.cs:294 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division.Equals("ALL") ? DBNull.Value : division | 행/컬럼 값 대입 |  |  |  |
| AC-3cec6eae | FindButton | SCP0008_ItemMaster.cs:295 | try ▸ lambda | DATA_OP | request.Parameters["p_class1"] | pClass1.Equals("ALL") ? DBNull.Value : pClass1 | 행/컬럼 값 대입 |  |  |  |
| AC-46bfdb7e | FindButton | SCP0008_ItemMaster.cs:296 | try ▸ lambda | DATA_OP | request.Parameters["p_class2"] | pClass2.Equals("ALL") ? DBNull.Value : pClass2 | 행/컬럼 값 대입 |  |  |  |
| AC-1884ef48 | FindButton | SCP0008_ItemMaster.cs:297 | try ▸ lambda | DATA_OP | request.Parameters["p_material_type"] | pMaterial_type.Equals("ALL") ? DBNull.Value : pMaterial_type | 행/컬럼 값 대입 |  |  |  |
| AC-781c3f06 | FindButton | SCP0008_ItemMaster.cs:298 | try ▸ lambda | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-edc156ab | FindButton | SCP0008_ItemMaster.cs:299 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | pScmSiteID.Equals("") ? DBNull.Value : pScmSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-f60fb71e | FindButton | SCP0008_ItemMaster.cs:300 | try ▸ lambda | DATA_OP | request.Parameters["p_item_class"] | pItemClass.Equals("") ? DBNull.Value : pItemClass | 행/컬럼 값 대입 |  |  |  |
| AC-a7c4207f | FindButton | SCP0008_ItemMaster.cs:301 | try ▸ lambda | DATA_OP | request.Parameters["p_item_name"] | pItemName.Equals("") ? DBNull.Value : pItemName | 행/컬럼 값 대입 |  |  |  |
| AC-f245f3f4 | FindButton | SCP0008_ItemMaster.cs:303 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0abb4cc8 | FindButton | SCP0008_ItemMaster.cs:305 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-fbe4ae07 | FindButton | SCP0008_ItemMaster.cs:312 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8a5db464 | FindButton | SCP0008_ItemMaster.cs:313 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3e25c59c | FindButton | SCP0008_ItemMaster.cs:316 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1548f6b3 | FindButton | SCP0008_ItemMaster.cs:329 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0008_ItemMaster.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92dd0db3 | this.Load | SCP0008_ItemMaster.cs:121 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0008_ItemMaster.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fe8641b | this.Load | SCP0008_ItemMaster.cs:138 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2ee0ad40 | this.Load | SCP0008_ItemMaster.cs:141 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-fb4ff64d | this.Load | SCP0008_ItemMaster.cs:144 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa158c55 | this.Load | SCP0008_ItemMaster.cs:146 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0b315a23 | this.Load | SCP0008_ItemMaster.cs:147 |  | LIST_REBIND | clsCtrl.setListBox | (dtClass1, clbClass1, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5a431ef5 | this.Load | SCP0008_ItemMaster.cs:149 |  | LIST_REBIND | clsCtrl.setListBox | (dtMaterialType, clbMaterialType, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0008_ItemMaster.InitSpread

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ea95410 | this.Load 외 1 | SCP0008_ItemMaster.cs:181 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-767f7f1f | this.Load 외 1 | SCP0008_ItemMaster.cs:235 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## SCP0008_ItemMaster.SetChangeControl

진입점: this.Load / clbClass1.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7189b7a | this.Load 외 1 | SCP0008_ItemMaster.cs:160 |  | FLAG | dtClass2 | DBUtils.Filter(dtClass2All, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-cda7a9a0 | this.Load 외 1 | SCP0008_ItemMaster.cs:160 |  | DATA_OP | DBUtils.Filter | (dtClass2All, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d4167ebc | this.Load 외 1 | SCP0008_ItemMaster.cs:162 |  | LIST_REBIND | clsCtrl.setListBox | (dtClass2, clbClass2, true) | 목록 컨트롤 재구성 |  |  |  |

