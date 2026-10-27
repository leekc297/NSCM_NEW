# AS-IS 액션 대조표 — SCP0032

> 원천: `Doc/asisfacts/screens/SCP0032/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 111행 · 메서드 12 · 종류 GRID_INIT 35 · FLAG 21 · CALL_EXT 11 · DATA_OP 8 · LIST_REBIND 6 · COMBO_DATA 5 · VALUE_SET 5 · UI_MISC 4 · GRID_CLEAR 3 · ENDPOINT 3 · POPUP 2 · VALIDATE 2 · RETURN 2 · UI_PROP 2 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 11


## SCP0032_Unplan_List.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2035d21f | cboPlanDate.SelectedIndexChanged | SCP0032_Unplan_List.cs:160 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-8082aed9 | cboPlanDate.SelectedIndexChanged | SCP0032_Unplan_List.cs:160 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ec5f2d23 | cboPlanDate.SelectedIndexChanged | SCP0032_Unplan_List.cs:161 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5c002051 | cboPlanDate.SelectedIndexChanged | SCP0032_Unplan_List.cs:162 | if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-66ea8a06 | cboPlanDate.SelectedIndexChanged | SCP0032_Unplan_List.cs:164 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0032_Unplan_List.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea71a20d | cboPlanSeq.SelectedIndexChanged | SCP0032_Unplan_List.cs:187 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0032_Unplan_List.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ae77c96 | cboPlanType.SelectedIndexChanged | SCP0032_Unplan_List.cs:177 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-58d4e510 | cboPlanType.SelectedIndexChanged | SCP0032_Unplan_List.cs:177 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6efe9834 | cboPlanType.SelectedIndexChanged | SCP0032_Unplan_List.cs:178 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3cf3158e | cboPlanType.SelectedIndexChanged | SCP0032_Unplan_List.cs:180 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-d19d8b36 | cboPlanType.SelectedIndexChanged | SCP0032_Unplan_List.cs:182 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0032_Unplan_List.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14697e46 | this.Load | SCP0032_Unplan_List.cs:192 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtNoBom, SpdSheet.shtNoBom, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b039a21d | this.Load | SCP0032_Unplan_List.cs:193 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPreferNoBom, SpdSheet.shtPreferNoBom, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-562e9c97 | this.Load | SCP0032_Unplan_List.cs:194 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtNoItem, SpdSheet.shtNoItem, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0ae2011f | this.Load | SCP0032_Unplan_List.cs:195 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPreferNoProduct, SpdSheet.shtPreferNoProduct, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f07a5ba8 | this.Load | SCP0032_Unplan_List.cs:196 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPreferNoSite, SpdSheet.shtPreferNoSite, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7e99e0d3 | this.Load | SCP0032_Unplan_List.cs:197 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtNoBod, SpdSheet.shtNoBod, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2798462e | this.Load | SCP0032_Unplan_List.cs:198 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtNoBodElectrodePair, SpdSheet.shtNoBodElectrodePair, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c7ab9a54 | this.Load | SCP0032_Unplan_List.cs:199 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPreferNoBod, SpdSheet.shtPreferNoBod, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-47a87091 | this.Load | SCP0032_Unplan_List.cs:200 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPreferNoBodElectrodePair, SpdSheet.shtPreferNoBodElectrodePair, 1, 1… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-17bd8a12 | this.Load | SCP0032_Unplan_List.cs:201 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPreferNoBodCal, SpdSheet.shtPreferNoBodCal, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fa5861eb | this.Load | SCP0032_Unplan_List.cs:202 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtNoResource, SpdSheet.shtNoResource, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-feedec1f | this.Load | SCP0032_Unplan_List.cs:203 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPreferNoResource, SpdSheet.shtPreferNoResource, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d2a65033 | this.Load | SCP0032_Unplan_List.cs:204 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPastDue, SpdSheet.shtPastDue, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7d398d76 | this.Load | SCP0032_Unplan_List.cs:205 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtOutOfHorizon, SpdSheet.shtOutOfHorizon, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2ea9a4c9 | this.Load | SCP0032_Unplan_List.cs:207 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtNoBom) | 화면 필드/플래그 변경 |  |  |  |
| AC-9727dd7b | this.Load | SCP0032_Unplan_List.cs:208 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtNoBom) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-deee3d40 | this.Load | SCP0032_Unplan_List.cs:211 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPreferNoBom) | 화면 필드/플래그 변경 |  |  |  |
| AC-21ffb333 | this.Load | SCP0032_Unplan_List.cs:212 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPreferNoBom) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a374558b | this.Load | SCP0032_Unplan_List.cs:215 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtNoItem) | 화면 필드/플래그 변경 |  |  |  |
| AC-354f7ed1 | this.Load | SCP0032_Unplan_List.cs:216 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtNoItem) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9d48296d | this.Load | SCP0032_Unplan_List.cs:219 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPreferNoProduct) | 화면 필드/플래그 변경 |  |  |  |
| AC-6f7e44df | this.Load | SCP0032_Unplan_List.cs:220 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPreferNoProduct) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2fcb28d5 | this.Load | SCP0032_Unplan_List.cs:223 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPreferNoSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-caff2f87 | this.Load | SCP0032_Unplan_List.cs:224 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPreferNoSite) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f9fb1f4b | this.Load | SCP0032_Unplan_List.cs:227 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtNoBod) | 화면 필드/플래그 변경 |  |  |  |
| AC-b772c265 | this.Load | SCP0032_Unplan_List.cs:228 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtNoBod) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ce52101c | this.Load | SCP0032_Unplan_List.cs:231 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtNoBodElectrodePair) | 화면 필드/플래그 변경 |  |  |  |
| AC-4d4f4d33 | this.Load | SCP0032_Unplan_List.cs:232 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtNoBodElectrodePair) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0e2ce2b2 | this.Load | SCP0032_Unplan_List.cs:235 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPreferNoBod) | 화면 필드/플래그 변경 |  |  |  |
| AC-47361a2f | this.Load | SCP0032_Unplan_List.cs:236 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPreferNoBod) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-85d8fea5 | this.Load | SCP0032_Unplan_List.cs:239 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPreferNoBodElectrodePair) | 화면 필드/플래그 변경 |  |  |  |
| AC-ab95b8a8 | this.Load | SCP0032_Unplan_List.cs:240 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPreferNoBodElectrodePair) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-166e095d | this.Load | SCP0032_Unplan_List.cs:243 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPreferNoBodCal) | 화면 필드/플래그 변경 |  |  |  |
| AC-95368a4b | this.Load | SCP0032_Unplan_List.cs:244 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPreferNoBodCal) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e77dbf3a | this.Load | SCP0032_Unplan_List.cs:247 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtNoResource) | 화면 필드/플래그 변경 |  |  |  |
| AC-b6287244 | this.Load | SCP0032_Unplan_List.cs:248 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtNoResource) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b58cb91 | this.Load | SCP0032_Unplan_List.cs:251 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPreferNoResource) | 화면 필드/플래그 변경 |  |  |  |
| AC-a4d087c2 | this.Load | SCP0032_Unplan_List.cs:252 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPreferNoResource) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fc94ed34 | this.Load | SCP0032_Unplan_List.cs:255 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPastDue) | 화면 필드/플래그 변경 |  |  |  |
| AC-7fe56824 | this.Load | SCP0032_Unplan_List.cs:256 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPastDue) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-be130244 | this.Load | SCP0032_Unplan_List.cs:259 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtOutOfHorizon) | 화면 필드/플래그 변경 |  |  |  |
| AC-0a32baf5 | this.Load | SCP0032_Unplan_List.cs:260 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtOutOfHorizon) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-37b3e716 | this.Load | SCP0032_Unplan_List.cs:265 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0032_Unplan_List.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a97b52ef | Dispose | SCP0032_Unplan_List.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0032_Unplan_List.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a38e8c01 | FindButton | SCP0032_Unplan_List.cs:309 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1e202a77 | FindButton | SCP0032_Unplan_List.cs:313 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d806d4b5 | FindButton | SCP0032_Unplan_List.cs:313 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7136aa9 | FindButton | SCP0032_Unplan_List.cs:316 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c3030bd6 | FindButton | SCP0032_Unplan_List.cs:318 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, siMain.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-7f31d92f | FindButton | SCP0032_Unplan_List.cs:319 | try | GRID_INIT | siMain.ChangeSheet | (siMain.ActiveSheet.SheetName) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4126d33e | FindButton | SCP0032_Unplan_List.cs:332 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e1420240 | FindButton | SCP0032_Unplan_List.cs:333 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Validation.WSL/FoxDataSer… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-31d40f66 | FindButton | SCP0032_Unplan_List.cs:337 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0032_GET_UNPLAN_LIST") ⇒ SCP.SCP0032_GET_UNPLAN_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-a903c8b2 | FindButton | SCP0032_Unplan_List.cs:338 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ce006632 | FindButton | SCP0032_Unplan_List.cs:339 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-726ac95e | FindButton | SCP0032_Unplan_List.cs:340 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a58ebbdb | FindButton | SCP0032_Unplan_List.cs:341 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-dc3ebb25 | FindButton | SCP0032_Unplan_List.cs:342 | try ▸ lambda | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-f6eeb329 | FindButton | SCP0032_Unplan_List.cs:343 | try ▸ lambda | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-b7e2097b | FindButton | SCP0032_Unplan_List.cs:345 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c3c98169 | FindButton | SCP0032_Unplan_List.cs:347 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1e6f9390 | FindButton | SCP0032_Unplan_List.cs:354 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-53f0195d | FindButton | SCP0032_Unplan_List.cs:355 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-629bc864 | FindButton | SCP0032_Unplan_List.cs:358 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bbe3a8fd | FindButton | SCP0032_Unplan_List.cs:360 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-940dcb06 | FindButton | SCP0032_Unplan_List.cs:371 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0032_Unplan_List.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d95fa3b | this.Load | SCP0032_Unplan_List.cs:88 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0032_Unplan_List.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4684620d | this.Load | SCP0032_Unplan_List.cs:118 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-0e0d8db5 | this.Load | SCP0032_Unplan_List.cs:121 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-eb52b9a8 | this.Load | SCP0032_Unplan_List.cs:123 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-68b9433e | this.Load | SCP0032_Unplan_List.cs:124 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c856c1b | this.Load | SCP0032_Unplan_List.cs:125 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-75bee348 | this.Load | SCP0032_Unplan_List.cs:127 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9cea738a | this.Load | SCP0032_Unplan_List.cs:131 |  | VALUE_SET | this.usrLabel2.Text | "1. NO BOM : " + MessageHelper.GetMessageInfo("MSG00235", UserInfoContext.Current[UserInfo… | 컨트롤 값 설정 |  |  |  |
| AC-92f6a7fb | this.Load | SCP0032_Unplan_List.cs:131 |  | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00235", UserInfoContext.Current[UserInfoProperites.Language]) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0032_Unplan_List.InitSpread

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8d17a86 | this.Load 외 1 | SCP0032_Unplan_List.cs:270 |  | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-34da131a | this.Load 외 1 | SCP0032_Unplan_List.cs:271 |  | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-6c5a0b3a | this.Load 외 1 | SCP0032_Unplan_List.cs:272 |  | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0032_Unplan_List.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a792caf | this.Load 외 1 | SCP0032_Unplan_List.cs:140 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDate, false, division) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 화면 필드/플래그 변경 |  |  |  |
| AC-6edc5415 | this.Load 외 1 | SCP0032_Unplan_List.cs:140 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanDate, false, division) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b556765c | this.Load 외 1 | SCP0032_Unplan_List.cs:141 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-05981e96 | this.Load 외 1 | SCP0032_Unplan_List.cs:145 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-362a4944 | this.Load 외 1 | SCP0032_Unplan_List.cs:145 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4dc94299 | this.Load 외 1 | SCP0032_Unplan_List.cs:146 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bdce918a | this.Load 외 1 | SCP0032_Unplan_List.cs:147 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-6f987988 | this.Load 외 1 | SCP0032_Unplan_List.cs:150 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-7e81f9d3 | this.Load 외 1 | SCP0032_Unplan_List.cs:150 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-38269291 | this.Load 외 1 | SCP0032_Unplan_List.cs:151 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0032_Unplan_List.SpdMain_ActiveSheetChanged

진입점: spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4b2454e | spdMain.ActiveSheetChanged | SCP0032_Unplan_List.cs:400 | if (sActiveSheetName == SpdSheet.shtNoBom \|\| sActiveSheetName == SpdSheet.shtPreferNoBom) | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00235", UserInfoContext.Current[UserInfoProperites.Language]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e3d9ff7 | spdMain.ActiveSheetChanged | SCP0032_Unplan_List.cs:405 | else of (sActiveSheetName == SpdSheet.shtNoBom \|\| sActiveSheetName == SpdSheet.shtPreferNoBom) ▸ if (sActiveSheetName == SpdSheet.shtNoIte… | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00236", UserInfoContext.Current[UserInfoProperites.Language]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d3416119 | spdMain.ActiveSheetChanged | SCP0032_Unplan_List.cs:410 | else of (sActiveSheetName == SpdSheet.shtNoBom \|\| sActiveSheetName == SpdSheet.shtPreferNoBom) ▸ else of (sActiveSheetName == SpdSheet.sht… | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00237", UserInfoContext.Current[UserInfoProperites.Language]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-158e287f | spdMain.ActiveSheetChanged | SCP0032_Unplan_List.cs:415 | else of (sActiveSheetName == SpdSheet.shtNoBom \|\| sActiveSheetName == SpdSheet.shtPreferNoBom) ▸ else of (sActiveSheetName == SpdSheet.sht… | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00245", UserInfoContext.Current[UserInfoProperites.Language]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8a475ee | spdMain.ActiveSheetChanged | SCP0032_Unplan_List.cs:420 | else of (sActiveSheetName == SpdSheet.shtNoBom \|\| sActiveSheetName == SpdSheet.shtPreferNoBom) ▸ else of (sActiveSheetName == SpdSheet.sht… | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00238", UserInfoContext.Current[UserInfoProperites.Language]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a069c0e2 | spdMain.ActiveSheetChanged | SCP0032_Unplan_List.cs:425 | else of (sActiveSheetName == SpdSheet.shtNoBom \|\| sActiveSheetName == SpdSheet.shtPreferNoBom) ▸ else of (sActiveSheetName == SpdSheet.sht… | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00239", UserInfoContext.Current[UserInfoProperites.Language]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fb245560 | spdMain.ActiveSheetChanged | SCP0032_Unplan_List.cs:430 | else of (sActiveSheetName == SpdSheet.shtNoBom \|\| sActiveSheetName == SpdSheet.shtPreferNoBom) ▸ else of (sActiveSheetName == SpdSheet.sht… | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00240", UserInfoContext.Current[UserInfoProperites.Language]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8a020ea | spdMain.ActiveSheetChanged | SCP0032_Unplan_List.cs:435 | else of (sActiveSheetName == SpdSheet.shtNoBom \|\| sActiveSheetName == SpdSheet.shtPreferNoBom) ▸ else of (sActiveSheetName == SpdSheet.sht… | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00241", UserInfoContext.Current[UserInfoProperites.Language]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3dabf560 | spdMain.ActiveSheetChanged | SCP0032_Unplan_List.cs:440 | else of (sActiveSheetName == SpdSheet.shtNoBom \|\| sActiveSheetName == SpdSheet.shtPreferNoBom) ▸ else of (sActiveSheetName == SpdSheet.sht… | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00242", UserInfoContext.Current[UserInfoProperites.Language]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6cf3044c | spdMain.ActiveSheetChanged | SCP0032_Unplan_List.cs:445 | else of (sActiveSheetName == SpdSheet.shtNoBom \|\| sActiveSheetName == SpdSheet.shtPreferNoBom) ▸ else of (sActiveSheetName == SpdSheet.sht… | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00243", UserInfoContext.Current[UserInfoProperites.Language]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f77da18 | spdMain.ActiveSheetChanged | SCP0032_Unplan_List.cs:448 |  | VALUE_SET | this.usrLabel2.Text | sMessage | 컨트롤 값 설정 |  |  |  |

## SCP0032_Unplan_List.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1865a50e | spdMain.TopChange | SCP0032_Unplan_List.cs:387 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

