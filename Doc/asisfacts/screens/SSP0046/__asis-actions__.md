# AS-IS 액션 대조표 — SSP0046

> 원천: `Doc/asisfacts/screens/SSP0046/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 862행 · 메서드 94 · 종류 FLAG 147 · DATA_OP 144 · GRID_INIT 104 · GRID_SET 88 · ENDPOINT 49 · UI_PROP 46 · RETURN 45 · UI_MISC 34 · COMBO_DATA 31 · POPUP 26 · MESSAGE 25 · LIST_REBIND 22 · GRID_LOCK 20 · CALL_EXT 20 · VALUE_SET 18 · STATE 15 · GRID_STYLE 15 · GRID_BIND 6 · GRID_COMBO 4 · STATE_RESET 1 · VALIDATE 1 · CALL_BASE 1 · ⚠ 의미 확인 필요 21


## SSP0046_GetBODItemPrjRoutePopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4262c3a | .ctor | SSP0046_GetBODItemPrjRoutePopup.cs:164 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SSP0046_GetBODItemPrjRoutePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-983a10dd | this.btnButtonList.UsrButtonList_Click_Detected | SSP0046_GetBODItemPrjRoutePopup.cs:327 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0046_GetBODItemPrjRoutePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-640efe7e | this.Load | SSP0046_GetBODItemPrjRoutePopup.cs:198 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f715502d | this.Load | SSP0046_GetBODItemPrjRoutePopup.cs:199 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-582f55e4 | this.Load | SSP0046_GetBODItemPrjRoutePopup.cs:200 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0046_GetBODItemPrjRoutePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25fd4cd3 | Dispose | SSP0046_GetBODItemPrjRoutePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0046_GetBODItemPrjRoutePopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a95a901 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:294 |  | ENDPOINT | proxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM,sBinding)) { var… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8aecc2bb | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:297 | lambda | ENDPOINT | new FoxDataRequest | (procdName) ⇒ {?string.Empty} \| SSP.SSP0046_GET_BODITEM_FOR_PRJROUTE_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-73ded1ed | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:299 | lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4706c1e2 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:300 | lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-7d6695a7 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:301 | lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-44979e4b | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:303 | lambda | UI_PROP | req.CommandTimeout | 60 * 3 | 속성 CommandTimeout 설정 |  |  |  |
| AC-04927dcd | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:305 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e90ad99f | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:306 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d63ff753 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:310 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-48a71adf | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:311 |  | GRID_LOCK | siMain.LockColumn | (1, siMain.GetColumnIndex(DefColumns.LEAD_TIME), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7f32ed25 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:313 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0046_GetBODItemPrjRoutePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1af0b9ca | this.Load | SSP0046_GetBODItemPrjRoutePopup.cs:174 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0046_GetBODItemPrjRoutePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f5fcf9c | this.Load | SSP0046_GetBODItemPrjRoutePopup.cs:193 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## SSP0046_GetBODItemPrjRoutePopup.InitSpread

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d402dcf | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:205 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-f7427ec8 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:208 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.LOCK, DefColumns.LOCK, FPMerge.None, 90, false, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca05a317 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:209 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.FROM_SITE, DefColumns.FROM_SITE, FPMerge.None, 110, false , FPHAlign.Left,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b7c63fee | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:210 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.FROM_DIVISION_ID, DefColumns.FROM_DIVISION_ID, FPMerge.None, 110, false, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-186bfb8f | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:211 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.FROM_SITE_NAME, DefColumns.FROM_SITE_NAME, FPMerge.None, 140, true, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-242e5d83 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:212 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.TO_SITE, DefColumns.TO_SITE, FPMerge.None, 110, false, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94f3505c | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:213 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.TO_DIVISION_ID, DefColumns.TO_DIVISION_ID, FPMerge.None, 110, false, FPHAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d32a2484 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:214 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.TO_SITE_NAME, DefColumns.TO_SITE_NAME, FPMerge.None, 140, true, FPHAlign.L… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ec4ef99d | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:215 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.ITEM_ID, DefColumns.ITEM_ID, FPMerge.None, 150, true, FPHAlign.Left, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-83693249 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:216 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.PRIORITY, DefColumns.PRIORITY, FPMerge.None, 70, true, FPHAlign.Center, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-070c40e3 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:217 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.BOD_ID, DefColumns.BOD_ID, FPMerge.None, 110, false, FPHAlign.Left, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48d2a8f6 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:218 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.FROZEN_YYYYMMDD, DefColumns.FROZEN_YYYYMMDD, FPMerge.None, 110, false, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e76eba78 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:219 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.INCOTERMS, DefColumns.INCOTERMS , FPMerge.None, 70, true, FPHAlign.Left , … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aa4d2dab | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:220 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.TRANSPORT_MODE, DefColumns.TRANSPORT_MODE, FPMerge.None, 70, true, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bde899d8 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:221 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.BOD_ITEM_VALID, DefColumns.BOD_ITEM_VALID, FPMerge.None, 60, true, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fc7e274c | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:222 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.VOYAGE_MON, DefColumns.VOYAGE_MON , FPMerge.None, 45, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb328fe7 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:223 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.VOYAGE_TUE, DefColumns.VOYAGE_TUE , FPMerge.None, 45, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c7528be | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:224 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.VOYAGE_WED, DefColumns.VOYAGE_WED , FPMerge.None, 45, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2fcdedde | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:225 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.VOYAGE_THU, DefColumns.VOYAGE_THU , FPMerge.None, 45, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72765128 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:226 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.VOYAGE_FRI, DefColumns.VOYAGE_FRI , FPMerge.None, 45, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f92a835f | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:227 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.VOYAGE_SAT, DefColumns.VOYAGE_SAT , FPMerge.None, 45, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-431d4378 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:228 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.VOYAGE_SUN, DefColumns.VOYAGE_SUN , FPMerge.None, 45, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b223c467 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:229 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.LEAD_TIME, DefColumns.LEAD_TIME, FPMerge.None, 90, true, FPHAlign.Right, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-582b4aca | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:230 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.END_CUSTOMER, DefColumns.END_CUSTOMER, FPMerge.None, 90, false, FPHAlign.R… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2932149c | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:231 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.DEPT_NAME_KO, DefColumns.DEPT_NAME_KO, FPMerge.None, 90, false, FPHAlign.R… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-357967e8 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:234 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.LOCK), 2, 1, 30, DefColumnLabel.LOCK, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-920888ce | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:235 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.FROM_SITE), 2, 1, 30, DefColumnLabel.FROM_SITE, FPHAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-afafa766 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:236 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.FROM_DIVISION_ID), 2, 1, 30, DefColumnLabel.FROM_DIVI… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae4c7f98 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:237 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.FROM_SITE_NAME), 2, 1, 30, DefColumnLabel.FROM_SITE_N… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1643728d | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:238 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.TO_SITE), 2, 1, 30, DefColumnLabel.TO_SITE, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-52e58667 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:239 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.TO_DIVISION_ID), 2, 1, 30, DefColumnLabel.TO_DIVISION… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3e3bcca9 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:240 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.TO_SITE_NAME), 2, 1, 30, DefColumnLabel.TO_SITE_NAME,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1569e3d | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:241 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.ITEM_ID), 2, 1, 30, DefColumnLabel.ITEM_ID, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5084005d | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:242 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.PRIORITY), 2, 1, 30, DefColumnLabel.PRIORITY, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-130f12db | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:243 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.BOD_ID), 2, 1, 30, DefColumnLabel.BOD_ID, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94076ade | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:244 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.FROZEN_YYYYMMDD), 2, 1, 30, DefColumnLabel.FROZEN_YYY… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13a0f623 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:245 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.INCOTERMS), 2, 1, 30, DefColumnLabel.INCOTERMS, FPHAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3fbfd539 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:246 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), 2, 1, 30, DefColumnLabel.TRANSPORT_M… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c57f8f1 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:247 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.BOD_ITEM_VALID), 2, 1, 30, DefColumnLabel.BOD_ITEM_VA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-810e3a11 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:248 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.LEAD_TIME), 2, 1, 30, DefColumnLabel.LEAD_TIME, FPHAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0d227a6f | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:249 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.VOYAGE_MON), 1, 7, 30, "Voyage", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f9a171fd | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:250 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.VOYAGE_MON), 1, 1, 30, DefColumnLabel.VOYAGE_MON, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b6614cce | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:251 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.VOYAGE_TUE), 1, 1, 30, DefColumnLabel.VOYAGE_TUE, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb6819a5 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:252 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.VOYAGE_WED), 1, 1, 30, DefColumnLabel.VOYAGE_WED, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b4253b20 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:253 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.VOYAGE_THU), 1, 1, 30, DefColumnLabel.VOYAGE_THU, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6660fb93 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:254 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.VOYAGE_FRI), 1, 1, 30, DefColumnLabel.VOYAGE_FRI, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d5f6ed5c | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:255 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.VOYAGE_SAT), 1, 1, 30, DefColumnLabel.VOYAGE_SAT, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cc365f49 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:256 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.VOYAGE_SUN), 1, 1, 30, DefColumnLabel.VOYAGE_SUN, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-851d81ee | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:257 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), 2, 1, 30, DefColumnLabel.END_CUSTOMER,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c8326cee | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:258 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.DEPT_NAME_KO), 2, 1, 30, DefColumnLabel.DEPT_NAME_KO,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5bfa3c79 | this.Load 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:260 |  | GRID_LOCK | siMain.LockColumn | (4 , siMain.GetColumnIndex(DefColumns.LEAD_TIME), true) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0046_GetBODItemPrjRoutePopup.SetProject

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9936bc2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:340 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-beda048e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:342 |  | FLAG | FromSite | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FROM_SITE)) | 화면 필드/플래그 변경 |  |  |  |
| AC-b2c22274 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:343 |  | FLAG | ToSite | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TO_SITE)) | 화면 필드/플래그 변경 |  |  |  |
| AC-d4415a83 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:344 |  | FLAG | Incoterms | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INCOTERMS)) | 화면 필드/플래그 변경 |  |  |  |
| AC-27cdba90 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:345 |  | FLAG | TransportMode | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | 화면 필드/플래그 변경 |  |  |  |
| AC-701104e5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:346 |  | FLAG | BodId | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BOD_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-c238451e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:347 |  | FLAG | EndCustomer | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) | 화면 필드/플래그 변경 |  |  |  |
| AC-7b4591e3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_GetBODItemPrjRoutePopup.cs:348 |  | FLAG | DeptNameKo | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_NAME_KO)) | 화면 필드/플래그 변경 |  |  |  |

## SSP0046_GetBODItemPrjRoutePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1b2c6ea | this.spdMain.CellDoubleClick | SSP0046_GetBODItemPrjRoutePopup.cs:335 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0046_ItembyDivisionPopupEx.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f9c1cab | this.btnButtonList.UsrButtonList_Click_Detected | SSP0046_ItembyDivisionPopupEx.cs:454 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-1a6d53be | this.btnButtonList.UsrButtonList_Click_Detected | SSP0046_ItembyDivisionPopupEx.cs:457 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0046_ItembyDivisionPopupEx.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fce4c5ec | this.clbDivision.SelectedIndexChanged | SSP0046_ItembyDivisionPopupEx.cs:464 |  | FLAG | dtScmSite | GetDivisionbyScmSite(clbDivision.ControlValues, CAppSetting.StringALL, CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-dca0eb94 | this.clbDivision.SelectedIndexChanged | SSP0046_ItembyDivisionPopupEx.cs:465 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0046_ItembyDivisionPopupEx.CreateSpread

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-577e687b | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:293 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-223ee7b3 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:294 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cdd966b7 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:295 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0046_ItembyDivisionPopupEx.DefineProperty

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d94ae3e | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:288 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SSP0046_ItembyDivisionPopupEx.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0f5bc06 | Dispose | SSP0046_ItembyDivisionPopupEx.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0046_ItembyDivisionPopupEx.FindData

진입점: this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load [if (!blnVali)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e11ad49 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:368 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-091745dc | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:373 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-37df4e84 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:379 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c4fcf309 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:381 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { //… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dd81c796 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:386 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_GET_ITEM_BY_DIVISION_POPUPEx") ⇒ SSP.SSP0046_GET_ITEM_BY_DIVISION_POPUPEx | 엔드포인트 요청 생성 |  |  |  |
| AC-1b706e40 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:388 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1de5c6e2 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:390 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e69e9e08 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:391 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-6ab91c3f | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:392 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-34c8f35b | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:393 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-b87756d2 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:394 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbScmSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-58f0e21b | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:395 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-db9b0e99 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:396 | try ▸ lambda | DATA_OP | request.Parameters["p_biz_type"] | sBizType | 행/컬럼 값 대입 |  |  |  |
| AC-a140c749 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:397 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-782c0f31 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:399 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c6bc42cf | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:406 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-bb048dff | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:408 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1d560a69 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:409 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2e0b7ba1 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:417 | try | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-04d4b0af | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:424 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3fb08a1c | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:428 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3180d62a | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:430 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0046_ItembyDivisionPopupEx.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-543392e1 | this.Load | SSP0046_ItembyDivisionPopupEx.cs:181 | if (!blnVali) | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3d8f37a6 | this.Load | SSP0046_ItembyDivisionPopupEx.cs:182 | if (!blnVali) | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-097c5766 | this.Load | SSP0046_ItembyDivisionPopupEx.cs:191 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-14d4c9f8 | this.Load | SSP0046_ItembyDivisionPopupEx.cs:192 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-689cfd50 | this.Load | SSP0046_ItembyDivisionPopupEx.cs:193 |  | FLAG | sProject | _ProjectCode | 화면 필드/플래그 변경 |  |  |  |
| AC-ee5f9d26 | this.Load | SSP0046_ItembyDivisionPopupEx.cs:194 |  | FLAG | sScmSiteId | _ScmSiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-6add4688 | this.Load | SSP0046_ItembyDivisionPopupEx.cs:195 |  | FLAG | sItemId | _ItemID | 화면 필드/플래그 변경 |  |  |  |
| AC-29646e8e | this.Load | SSP0046_ItembyDivisionPopupEx.cs:196 |  | FLAG | sBizType | _BizType | 화면 필드/플래그 변경 |  |  |  |
| AC-fb8428f7 | this.Load | SSP0046_ItembyDivisionPopupEx.cs:198 |  | FLAG | DeptID | _DeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-2aaacc1b | this.Load | SSP0046_ItembyDivisionPopupEx.cs:199 |  | FLAG | EndCustomer | _EndCustomer | 화면 필드/플래그 변경 |  |  |  |
| AC-7ae2b049 | this.Load | SSP0046_ItembyDivisionPopupEx.cs:204 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-0dd38547 | this.Load | SSP0046_ItembyDivisionPopupEx.cs:205 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-51a27063 | this.Load | SSP0046_ItembyDivisionPopupEx.cs:206 |  | FLAG | sProject | _ProjectCode | 화면 필드/플래그 변경 |  |  |  |
| AC-baac8028 | this.Load | SSP0046_ItembyDivisionPopupEx.cs:207 |  | FLAG | sScmSiteId | _ScmSiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-7a8089b6 | this.Load | SSP0046_ItembyDivisionPopupEx.cs:208 |  | FLAG | sItemId | _ItemID | 화면 필드/플래그 변경 |  |  |  |
| AC-51954e65 | this.Load | SSP0046_ItembyDivisionPopupEx.cs:209 |  | FLAG | sBizType | _BizType | 화면 필드/플래그 변경 |  |  |  |
| AC-73b46cc4 | this.Load | SSP0046_ItembyDivisionPopupEx.cs:211 |  | FLAG | DeptID | _DeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-3680a29b | this.Load | SSP0046_ItembyDivisionPopupEx.cs:212 |  | FLAG | EndCustomer | _EndCustomer | 화면 필드/플래그 변경 |  |  |  |
| AC-99616f5b | this.Load | SSP0046_ItembyDivisionPopupEx.cs:213 |  | FLAG | bCtlEnable | bEnable | 화면 필드/플래그 변경 |  |  |  |

## SSP0046_ItembyDivisionPopupEx.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87e8d318 | (진입점 미연결) | SSP0046_ItembyDivisionPopupEx.cs:559 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_GET_DIVISION") ⇒ SSP.SSP0046_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-c7540c4b | (진입점 미연결) | SSP0046_ItembyDivisionPopupEx.cs:561 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5d9ad2d3 | (진입점 미연결) | SSP0046_ItembyDivisionPopupEx.cs:564 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0046_ItembyDivisionPopupEx.GetDivisionbyScmSite

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dcd2c479 | this.clbDivision.SelectedIndexChanged | SSP0046_ItembyDivisionPopupEx.cs:573 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_GET_SITE_BY_DIVISION") ⇒ SSP.SSP0046_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-7723f738 | this.clbDivision.SelectedIndexChanged | SSP0046_ItembyDivisionPopupEx.cs:574 |  | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-544c429b | this.clbDivision.SelectedIndexChanged | SSP0046_ItembyDivisionPopupEx.cs:575 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-b4fa9e91 | this.clbDivision.SelectedIndexChanged | SSP0046_ItembyDivisionPopupEx.cs:576 |  | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-b943a68e | this.clbDivision.SelectedIndexChanged | SSP0046_ItembyDivisionPopupEx.cs:578 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8a614816 | this.clbDivision.SelectedIndexChanged | SSP0046_ItembyDivisionPopupEx.cs:581 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0046_ItembyDivisionPopupEx.GetEndCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16f7d430 | (진입점 미연결) | SSP0046_ItembyDivisionPopupEx.cs:604 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_GET_CUSTOMER_BY_DIVISION") ⇒ SSP.SSP0046_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-2b311c21 | (진입점 미연결) | SSP0046_ItembyDivisionPopupEx.cs:605 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-689b0cb8 | (진입점 미연결) | SSP0046_ItembyDivisionPopupEx.cs:606 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-d7fbb476 | (진입점 미연결) | SSP0046_ItembyDivisionPopupEx.cs:607 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-355292dc | (진입점 미연결) | SSP0046_ItembyDivisionPopupEx.cs:610 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0046_ItembyDivisionPopupEx.GetSpdTitle

진입점: this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load [if (!blnVali)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f4aa769 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:481 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_GET_COMMON_SPREAD_TITLE") ⇒ SSP.SSP0046_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-241f7f94 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:482 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6e619a5a | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:483 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f1334897 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:484 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-16093b0a | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:486 |  | DATA_OP | request.Parameters["p_program_id"] | "SCM0002_40" | 행/컬럼 값 대입 |  |  |  |
| AC-c71e0322 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:487 |  | DATA_OP | request.Parameters["p_sheet_name"] | "ItemPopup" | 행/컬럼 값 대입 |  |  |  |
| AC-89c5118e | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:488 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-dec504d4 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:490 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-1786c3cb | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:490 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-39c26bd8 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:493 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SSP0046_ItembyDivisionPopupEx.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8e36ee4 | (진입점 미연결) | SSP0046_ItembyDivisionPopupEx.cs:590 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_GET_TEAM_BY_DIVISION") ⇒ SSP.SSP0046_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-1e2e40e6 | (진입점 미연결) | SSP0046_ItembyDivisionPopupEx.cs:591 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c031dc11 | (진입점 미연결) | SSP0046_ItembyDivisionPopupEx.cs:592 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4b9c654d | (진입점 미연결) | SSP0046_ItembyDivisionPopupEx.cs:595 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0046_ItembyDivisionPopupEx.InitControls

진입점: this.Load [if (!blnVali)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc1d6cb5 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:223 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-44dd496d | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:223 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-03fce6d0 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:224 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6c7382d9 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:231 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-075e3403 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:231 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1b49f000 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:232 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-154e4495 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:241 | if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-b9d2c676 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:241 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d99227b8 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:242 | if (sDivision == "40") | UI_PROP | lblProject.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e495a70a | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:246 | else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-46bb2dd4 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:246 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d161d843 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:247 | else of (sDivision == "40") | UI_PROP | lblProject.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-719cec76 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:251 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-07a470a9 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:256 |  | FLAG | dtScmSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-97a803ee | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:256 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9e41b006 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:257 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bbe590ef | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:260 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-436569bb | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:261 |  | VALUE_SET | txtProject.ControlValues | sProject | 컨트롤 값 설정 |  |  |  |
| AC-2cec0654 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:262 |  | VALUE_SET | clbScmSite.ControlValues | sScmSiteId | 컨트롤 값 설정 |  |  |  |
| AC-9d08e3e5 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:263 |  | VALUE_SET | txtItemID.Text | sItemId | 컨트롤 값 설정 |  |  |  |
| AC-c8555455 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:264 |  | VALUE_SET | clbTeam.ControlValues | DeptID | 컨트롤 값 설정 |  |  |  |
| AC-704e9072 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:265 |  | VALUE_SET | clbEndCustomer.ControlValues | EndCustomer | 컨트롤 값 설정 |  |  |  |
| AC-f66d5019 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:270 | if (bCtlEnable == true) | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ed74ae07 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:271 | if (bCtlEnable == true) | STATE | txtProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-21ae9a9f | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:272 | if (bCtlEnable == true) | STATE | clbScmSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-05a84c8c | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:273 | if (bCtlEnable == true) | STATE | clbTeam.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2ca8d272 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:274 | if (bCtlEnable == true) | STATE | clbEndCustomer.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3678416a | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:278 | else of (bCtlEnable == true) | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bf7f6382 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:279 | else of (bCtlEnable == true) | STATE | txtProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cbc28954 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:280 | else of (bCtlEnable == true) | STATE | clbScmSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cd9c79ca | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:281 | else of (bCtlEnable == true) | STATE | clbTeam.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3c260483 | this.Load [if (!blnVali)] | SSP0046_ItembyDivisionPopupEx.cs:282 | else of (bCtlEnable == true) | STATE | clbEndCustomer.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SSP0046_ItembyDivisionPopupEx.InitSpread

진입점: this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load [if (!blnVali)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d62c459 | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:304 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## SSP0046_ItembyDivisionPopupEx.InitSpread_X

진입점: this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load [if (!blnVali)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-791d157a | this.txtItemID.KeyDown [if (e.KeyCode == System.Windows.Form… 외 3 | SSP0046_ItembyDivisionPopupEx.cs:331 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0046_ItembyDivisionPopupEx.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-785029f4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:498 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eaad6386 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:500 |  | FLAG | itemID | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c0c8cc94 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:516 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemID | this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6aa6462e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:517 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemName | this.dtFindData.Rows[iRow][DefColumns.ItemName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9dc2dd26 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:518 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemType | this.dtFindData.Rows[iRow][DefColumns.ItemType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-bb67ccdd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:519 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | nickName | this.dtFindData.Rows[iRow][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0a03bd6e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:520 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemclassname | this.dtFindData.Rows[iRow][DefColumns.ItemClassName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-242d2c2d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:521 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | currency | this.dtFindData.Rows[iRow][DefColumns.CURRENCY].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-59617711 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:525 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemID | itemID + "," + this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7840605a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:526 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemName | itemName + "," + this.dtFindData.Rows[iRow][DefColumns.ItemName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2b748a8b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:527 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemType | itemType + "," + this.dtFindData.Rows[iRow][DefColumns.ItemType].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c7145820 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:528 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | nickName | nickName + "," + this.dtFindData.Rows[iRow][DefColumns.NickName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1c383101 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:529 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemclassname | itemclassname + "," + this.dtFindData.Rows[iRow][DefColumns.ItemClassName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-bf692aa7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:530 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | currency | currency + "," + this.dtFindData.Rows[iRow][DefColumns.CURRENCY].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2cd85e6c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:538 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12a8202f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:543 | else of (bMulltiSelect) | FLAG | itemID | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-dce01a12 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:544 | else of (bMulltiSelect) | FLAG | itemName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-1b4c7614 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:545 | else of (bMulltiSelect) | FLAG | itemType | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemType)) | 화면 필드/플래그 변경 |  |  |  |
| AC-b865fd9b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:546 | else of (bMulltiSelect) | FLAG | nickName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NickName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-0e13fa10 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:547 | else of (bMulltiSelect) | FLAG | itemclassname | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemClassName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-f5ab5fed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ItembyDivisionPopupEx.cs:548 | else of (bMulltiSelect) | FLAG | currency | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY)) | 화면 필드/플래그 변경 |  |  |  |

## SSP0046_ItembyDivisionPopupEx.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a11adf5e | this.spdMain.CellDoubleClick | SSP0046_ItembyDivisionPopupEx.cs:471 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0046_ProjectbyDivisionPopupEx.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f72cbf2 | this.btnButtonList.UsrButtonList_Click_Detected | SSP0046_ProjectbyDivisionPopupEx.cs:432 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-5ff205be | this.btnButtonList.UsrButtonList_Click_Detected | SSP0046_ProjectbyDivisionPopupEx.cs:435 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0046_ProjectbyDivisionPopupEx.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cf33eec | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:273 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a0621e4b | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:274 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-72d2a0a8 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:275 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0046_ProjectbyDivisionPopupEx.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-642a6b48 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:268 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SSP0046_ProjectbyDivisionPopupEx.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6192d2f0 | Dispose | SSP0046_ProjectbyDivisionPopupEx.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0046_ProjectbyDivisionPopupEx.FindData

진입점: this.txtProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ebc7987 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:355 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d88e006b | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:356 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-834ecb68 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:359 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-12b14116 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:364 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a8168175 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:368 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX") ⇒ SSP.SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX | 엔드포인트 요청 생성 |  |  |  |
| AC-0c574a73 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:372 | lambda | DATA_OP | request.Parameters["p_division_id"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-03dd3da1 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:373 | lambda | DATA_OP | request.Parameters["p_dept_id"] | CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-dba7b42b | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:374 | lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-7f8e956a | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:375 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-db2dec56 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:378 | lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-6c5affcd | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:379 | lambda | DATA_OP | request.Parameters["p_etc"] | sETC | 행/컬럼 값 대입 |  |  |  |
| AC-fe04af69 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:380 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-41700c3f | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:382 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-89bcde9d | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:386 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e49027a5 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:387 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-14521252 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:390 |  | CALL_EXT | (new CUIControl()).SetPreferredWidth | (siMain.SpreadObject, 0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0bf5a3e9 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:394 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-b63636ab | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:396 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0046_ProjectbyDivisionPopupEx.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-480a7d1d | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:167 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b0a77a2d | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:168 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-26fad912 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:177 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-d570750e | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:178 |  | FLAG | division | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-d91eaa3c | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:179 |  | FLAG | sProject | _ProjectCode | 화면 필드/플래그 변경 |  |  |  |
| AC-cce9ecf8 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:181 |  | FLAG | DeptID | _DeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-c368d8c4 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:182 |  | FLAG | EndCustomer | _EndCustomer | 화면 필드/플래그 변경 |  |  |  |
| AC-e01a855c | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:183 |  | FLAG | SCM_SITE_ID | _SCM_SITE_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-7dbe3826 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:190 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-69eabc0c | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:191 |  | FLAG | division | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-34e2156c | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:192 |  | FLAG | sProject | _ProjectCode | 화면 필드/플래그 변경 |  |  |  |
| AC-c7d1c2f7 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:194 |  | FLAG | DeptID | _DeptID | 화면 필드/플래그 변경 |  |  |  |
| AC-ff1654b3 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:195 |  | FLAG | EndCustomer | _EndCustomer | 화면 필드/플래그 변경 |  |  |  |
| AC-a51793c7 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:196 |  | FLAG | SCM_SITE_ID | _SCM_SITE_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-dce91428 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:197 |  | FLAG | ETC | _ETC | 화면 필드/플래그 변경 |  |  |  |

## SSP0046_ProjectbyDivisionPopupEx.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97e172af | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:534 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_GET_DIVISION") ⇒ SSP.SSP0046_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-ec7baa80 | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:536 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-72b32665 | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:539 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0046_ProjectbyDivisionPopupEx.GetEndCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1223eb4d | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:561 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_GET_CUSTOMER_BY_DIVISION") ⇒ SSP.SSP0046_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d8859f35 | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:562 |  | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-f53c8ead | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:563 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-70401ea9 | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:564 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d3880229 | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:567 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0046_ProjectbyDivisionPopupEx.GetScmSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12940264 | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:576 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046__GET_SITE_BY_DIVISION") ⇒ SSP.SSP0046__GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-8d921a4d | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:577 |  | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-1fbe522e | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:578 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-3e7e77af | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:579 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-3991e67c | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:580 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8a1441d5 | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:583 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0046_ProjectbyDivisionPopupEx.GetSpdTitle

진입점: this.txtProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdbd33eb | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:452 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_GET_COMMON_SPREAD_TITLE_EX") ⇒ SSP.SSP0046_GET_COMMON_SPREAD_TITLE_EX | 엔드포인트 요청 생성 |  |  |  |
| AC-f89586d7 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:453 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-37979507 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:454 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-731ea0c8 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:455 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d1deac15 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:456 |  | DATA_OP | request.Parameters["p_program_id"] | "SSP0046" | 행/컬럼 값 대입 |  |  |  |
| AC-0dd4d598 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:457 |  | DATA_OP | request.Parameters["p_sheet_name"] | "ProjectPopup" | 행/컬럼 값 대입 |  |  |  |
| AC-2138db82 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:459 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-9f74a80e | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:459 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9effad86 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:462 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SSP0046_ProjectbyDivisionPopupEx.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1d46946 | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:547 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_GET_TEAM_BY_DIVISION") ⇒ SSP.SSP0046_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-3c190760 | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:548 |  | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-c2dda869 | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:549 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-20f4b0af | (진입점 미연결) | SSP0046_ProjectbyDivisionPopupEx.cs:552 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0046_ProjectbyDivisionPopupEx.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99fab319 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:219 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-a816838e | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:219 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-37d881db | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:220 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e237f6f9 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:225 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-c509cc14 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:225 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dfa1ce5b | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:226 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ea7b7717 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:231 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-4a8d7398 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:231 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, division, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d1883034 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:233 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-871aa94c | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:238 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-ddcfec8d | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:238 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b387b82b | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:239 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-74c450da | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:241 |  | VALUE_SET | clbDivision.ControlValues | division | 컨트롤 값 설정 |  |  |  |
| AC-16729608 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:242 |  | VALUE_SET | txtProject.Text | sProject | 컨트롤 값 설정 |  |  |  |
| AC-81692f91 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:243 |  | VALUE_SET | clbTeam.ControlValues | DeptID | 컨트롤 값 설정 |  |  |  |
| AC-c91214a0 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:244 |  | VALUE_SET | clbEndCustomer.ControlValues | EndCustomer | 컨트롤 값 설정 |  |  |  |
| AC-e5118aba | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:245 |  | VALUE_SET | clbSalesSite.ControlValues | SCM_SITE_ID | 컨트롤 값 설정 |  |  |  |
| AC-6d262315 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:250 | if (ETC == false) | UI_PROP | layoutControlETC.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ccb48cc3 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:254 | else of (ETC == false) | VALUE_SET | chkETC.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-f1ae017e | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:257 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7bcfb208 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:258 |  | STATE | clbTeam.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6977096c | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:259 |  | STATE | clbEndCustomer.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0702cbf3 | this.Load | SSP0046_ProjectbyDivisionPopupEx.cs:260 |  | STATE | clbSalesSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SSP0046_ProjectbyDivisionPopupEx.InitSpread

진입점: this.txtProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b357c38d | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:284 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## SSP0046_ProjectbyDivisionPopupEx.InitSpread_X

진입점: this.txtProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e379fb0e | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 3 | SSP0046_ProjectbyDivisionPopupEx.cs:308 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0046_ProjectbyDivisionPopupEx.SetProject

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c30063a2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:467 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b78a0fd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:469 |  | FLAG | projectCode | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d2820edb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:486 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | projectCode | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.Project)) | 화면 필드/플래그 변경 |  |  |  |
| AC-742adfae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:487 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | projectName | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.ProjectName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-ce37f191 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:488 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | projectStatus | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.ProjectStatus)) | 화면 필드/플래그 변경 |  |  |  |
| AC-be403070 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:489 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | bizType | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.BizType)) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a8a789a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:490 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | bizTypeName | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.BizTypeName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-e8d74b99 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:491 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | currency | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.Currency)) | 화면 필드/플래그 변경 |  |  |  |
| AC-8240db8f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:492 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | projectVerSeq | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.ProjectVerSeq)) | 화면 필드/플래그 변경 |  |  |  |
| AC-e7bd6416 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:493 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | projectOwner | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.ProjectOwner)) | 화면 필드/플래그 변경 |  |  |  |
| AC-89a54767 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:497 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | projectCode | projectCode + "," + siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.Project)) | 화면 필드/플래그 변경 |  |  |  |
| AC-5de24e8c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:498 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | projectName | projectName + "," + siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.ProjectName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-a6e2897d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:499 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | projectStatus | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.ProjectStatus)) | 화면 필드/플래그 변경 |  |  |  |
| AC-1085d378 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:500 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | bizType | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.BizType)) | 화면 필드/플래그 변경 |  |  |  |
| AC-9466fb59 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:501 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | bizTypeName | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.BizTypeName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-ca171c78 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:502 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | currency | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.Currency)) | 화면 필드/플래그 변경 |  |  |  |
| AC-7411969d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:503 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | projectVerSeq | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.ProjectVerSeq)) | 화면 필드/플래그 변경 |  |  |  |
| AC-0704feb1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:504 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | projectOwner | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.ProjectOwner)) | 화면 필드/플래그 변경 |  |  |  |
| AC-bd0a1067 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:512 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45419e17 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:517 | else of (bMulltiSelect) | FLAG | projectCode | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Project)) | 화면 필드/플래그 변경 |  |  |  |
| AC-a3dc22bc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:518 | else of (bMulltiSelect) | FLAG | projectName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ProjectName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-60a2d1f3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:519 | else of (bMulltiSelect) | FLAG | projectStatus | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ProjectStatus)) | 화면 필드/플래그 변경 |  |  |  |
| AC-e47a6768 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:520 | else of (bMulltiSelect) | FLAG | bizType | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BizType)) | 화면 필드/플래그 변경 |  |  |  |
| AC-688f953f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:521 | else of (bMulltiSelect) | FLAG | currency | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Currency)) | 화면 필드/플래그 변경 |  |  |  |
| AC-91a0a651 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:522 | else of (bMulltiSelect) | FLAG | projectVerSeq | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ProjectVerSeq)) | 화면 필드/플래그 변경 |  |  |  |
| AC-039a56ac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0046_ProjectbyDivisionPopupEx.cs:523 | else of (bMulltiSelect) | FLAG | projectOwner | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ProjectOwner)) | 화면 필드/플래그 변경 |  |  |  |

## SSP0046_ProjectbyDivisionPopupEx.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d23bf9e2 | this.spdMain.CellDoubleClick | SSP0046_ProjectbyDivisionPopupEx.cs:443 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0046_ShipmentRequest.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ea91ddd | this.btnColumn.Click | SSP0046_ShipmentRequest.cs:2147 |  | POPUP | new SSP0046_TitleSetForm_Popup | ("SSP0046", SpdSheet.shtPack, true) | 팝업/폼 생성 |  |  |  |
| AC-5f26893c | this.btnColumn.Click | SSP0046_ShipmentRequest.cs:2150 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-efe588f9 | this.btnColumn.Click | SSP0046_ShipmentRequest.cs:2151 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0046_ShipmentRequest.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ca5e478 | this.btnItemId.Click | SSP0046_ShipmentRequest.cs:2131 |  | POPUP | new SSP0046_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-504717a3 | this.btnItemId.Click | SSP0046_ShipmentRequest.cs:2133 |  | POPUP | popItem.Form_Load | (true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId, sBizType) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f199ce28 | this.btnItemId.Click | SSP0046_ShipmentRequest.cs:2134 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bb6d0fbe | this.btnItemId.Click | SSP0046_ShipmentRequest.cs:2135 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1008806c | this.btnItemId.Click | SSP0046_ShipmentRequest.cs:2141 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0046_ShipmentRequest.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acc3d5c6 | this.btnMeasure.Click | SSP0046_ShipmentRequest.cs:2322 |  | POPUP | new SSP0046_TitleSetForm_Popup | ("SSP0046", strSheetName, false) | 팝업/폼 생성 |  |  |  |
| AC-7d4e2d54 | this.btnMeasure.Click | SSP0046_ShipmentRequest.cs:2324 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8a86f947 | this.btnMeasure.Click | SSP0046_ShipmentRequest.cs:2325 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0046_ShipmentRequest.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20fc9f63 | this.btnProject.Click | SSP0046_ShipmentRequest.cs:2105 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-14cb7e14 | this.btnProject.Click | SSP0046_ShipmentRequest.cs:2107 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-0ff8a1c1 | this.btnProject.Click | SSP0046_ShipmentRequest.cs:2108 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-dfd96863 | this.btnProject.Click | SSP0046_ShipmentRequest.cs:2109 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e717351d | this.btnProject.Click | SSP0046_ShipmentRequest.cs:2115 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SSP0046_ShipmentRequest.cboDivision_SelectedIndexChanged

진입점: this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7fb6362 | this.cboDivision.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1111 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-f9799e74 | this.cboDivision.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1111 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-95b38939 | this.cboDivision.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1112 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c373ea23 | this.cboDivision.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1116 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-73f58a54 | this.cboDivision.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1116 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf00ce1f | this.cboDivision.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1117 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cf34a459 | this.cboDivision.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1121 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-5358b067 | this.cboDivision.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1121 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d411ad95 | this.cboDivision.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1122 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fc6ed012 | this.cboDivision.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1124 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-324c2b8d | this.cboDivision.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1124 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a0828f32 | this.cboDivision.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1125 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0046_ShipmentRequest.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a16f2cf | this.clbCustomer.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1145 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-d7d3f516 | this.clbCustomer.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1145 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6b7dda7e | this.clbCustomer.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1146 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0046_ShipmentRequest.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8a7c3cc | this.clbTeam.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1133 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-38f36b75 | this.clbTeam.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1133 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dbafabd0 | this.clbTeam.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1134 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a6fe482a | this.clbTeam.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1137 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-5237a9f9 | this.clbTeam.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1137 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e2e8e7c4 | this.clbTeam.SelectedIndexChanged | SSP0046_ShipmentRequest.cs:1138 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0046_ShipmentRequest.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bd3960f | this.Load | SSP0046_ShipmentRequest.cs:263 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPack, SpdSheet.shtPack, 3, 1, 40) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b4058db2 | this.Load | SSP0046_ShipmentRequest.cs:264 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPack) | 화면 필드/플래그 변경 |  |  |  |
| AC-84f02c39 | this.Load | SSP0046_ShipmentRequest.cs:265 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPack) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dad51e48 | this.Load | SSP0046_ShipmentRequest.cs:268 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtCell, SpdSheet.shtCell, 3, 1, 40) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c8b4eb3d | this.Load | SSP0046_ShipmentRequest.cs:269 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtCell) | 화면 필드/플래그 변경 |  |  |  |
| AC-5facda26 | this.Load | SSP0046_ShipmentRequest.cs:270 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtCell) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3b9d8c59 | this.Load | SSP0046_ShipmentRequest.cs:273 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPack) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0046_ShipmentRequest.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a98e7bff | this.Load | SSP0046_ShipmentRequest.cs:248 |  | UI_PROP | usrConditionPanel1.Height | 108 | 속성 Height 설정 |  |  |  |
| AC-eeb67c2c | this.Load | SSP0046_ShipmentRequest.cs:249 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-d522d250 | this.Load | SSP0046_ShipmentRequest.cs:251 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-36303782 | this.Load | SSP0046_ShipmentRequest.cs:252 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-0b63a37c | this.Load | SSP0046_ShipmentRequest.cs:253 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-bcd0eb3f | this.Load | SSP0046_ShipmentRequest.cs:254 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-08585d75 | this.Load | SSP0046_ShipmentRequest.cs:257 |  | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SSP0046_ShipmentRequest.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ce7173b | DeleteButton | SSP0046_ShipmentRequest.cs:443 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |

## SSP0046_ShipmentRequest.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbd7bd30 | Dispose | SSP0046_ShipmentRequest.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0046_ShipmentRequest.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3aee7b72 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:455 | if (isOK == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00251", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5f13353e | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:456 | if (isOK == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8702692 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:461 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5ea41fe5 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:462 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-db28badc | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:464 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.Requestor), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6b56f1ba | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:471 | if (this.fps != null) | CALL_EXT | fps.ActiveSheet.Columns.Get | (fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index) | ⚠ 의미 확인 필요 |  |  |  |
| AC-80f48daa | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:471 | if (this.fps != null) | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9265b0e5 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:474 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.Requestor) + 1, siMain.ActiveSheet.RowCount - 1, siMa… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ae2e4a4c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:481 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | CALL_EXT | Convert.ToInt16 | (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ShipFrozen)).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c4738963 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:504 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | GRID_STYLE | siMain.SetBGColor | (iRow, iStartCol, iRow, iStartCol + FrozenCnt, Color.FromArgb(242, 242, 242)) | 그리드 표시 설정 |  |  |  |
| AC-acb6a7c0 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:508 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.Measure), iRow, siMain.GetColumnIndex(DefColumns.M… | 그리드 표시 설정 |  |  |  |
| AC-e4a40e79 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:520 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | GRID_STYLE | siMain.SetBGColor | (iRow, iFrom, iRow, iTo, Color.FromArgb(219, 229, 241)) | 그리드 표시 설정 |  |  |  |
| AC-21366222 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:523 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c40a2a86 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:533 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ToSite)).ToString… | CALL_EXT | Convert.ToInt16 | (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ShipFrozen)).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5a2ba7a7 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:557 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) | GRID_LOCK | siMain.LockRange | (iRow, iStartCol, iRow, iStartCol + FrozenCnt, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4e8d2473 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:558 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) | GRID_STYLE | siMain.SetBGColor | (iRow, iStartCol, iRow, iStartCol + FrozenCnt, Color.FromArgb(242, 242, 242)) | 그리드 표시 설정 |  |  |  |
| AC-3af178fd | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:563 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(DefColu… | GRID_LOCK | siMain.LockRange | (iRow, iStartCol + FrozenCnt + 1, iRow, siMain.GetMaxColumnIndex(), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e01c3029 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:568 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(DefColu… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.FcstType), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cd4611c1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:569 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(DefColu… | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.FcstType), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 표시 설정 |  |  |  |
| AC-13965404 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:574 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) ▸ else of (siMain.GetText(iRow, siMain.GetColumnIndex(De… | GRID_LOCK | siMain.LockRange | (iRow, iStartCol + FrozenCnt + 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a9b1818c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:579 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (FrozenCnt != 0) | GRID_LOCK | siMain.LockRange | (iRow, iStartCol, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0046_ShipmentRequest.FindData

진입점: FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4f41c7e | FindButton 외 1 | SSP0046_ShipmentRequest.cs:597 |  | FLAG | dtMeasure | Data.Common(Data.Type.Measure, false, "SSP0046", siMain.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-e1784d4d | FindButton 외 1 | SSP0046_ShipmentRequest.cs:597 |  | COMBO_DATA | Data.Common | (Data.Type.Measure, false, "SSP0046", siMain.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0b79a2ca | FindButton 외 1 | SSP0046_ShipmentRequest.cs:599 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-cd0f1754 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:607 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eb915537 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:608 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7cb7263a | FindButton 외 1 | SSP0046_ShipmentRequest.cs:612 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-38b5c2ae | FindButton 외 1 | SSP0046_ShipmentRequest.cs:617 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e9aaa4cd | FindButton 외 1 | SSP0046_ShipmentRequest.cs:622 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { FoxDataRequest request = new FoxDataRequest("SSP.SSP0046_GET_SHIPMENT_REQUEST"); … | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5d9e36f4 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:624 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_GET_SHIPMENT_REQUEST") ⇒ SSP.SSP0046_GET_SHIPMENT_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-2065bb05 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:628 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2b72f6f3 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:630 | try ▸ lambda | DATA_OP | request.Parameters["p_sheet_name"] | siMain.SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-098ab3a3 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:631 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-28708164 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:632 | try ▸ lambda | DATA_OP | request.Parameters["p_team_id"] | (sTeam == "ALL") ? "" : sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-2963a9e3 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:633 | try ▸ lambda | DATA_OP | request.Parameters["p_customer"] | (clbCustomer.ControlValues == "ALL") ? "" : clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3c055600 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:634 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | (clbSalesSite.ControlValues == "ALL") ? "" : clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-05ec6344 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:635 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | (clbPlantSite.ControlValues == "ALL") ? "" : clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3c549884 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:636 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-c2e4fb6d | FindButton 외 1 | SSP0046_ShipmentRequest.cs:637 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-c842482e | FindButton 외 1 | SSP0046_ShipmentRequest.cs:638 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-44f6331e | FindButton 외 1 | SSP0046_ShipmentRequest.cs:639 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-621ffc67 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:640 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-034861bf | FindButton 외 1 | SSP0046_ShipmentRequest.cs:641 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-21c89897 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:643 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-03cde5b7 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:645 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2ed660cd | FindButton 외 1 | SSP0046_ShipmentRequest.cs:658 | try ▸ if (ds.Tables[0] != null) | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c96a4255 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:658 | try ▸ if (ds.Tables[0] != null) | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6b8bd646 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:662 | try ▸ if (ds.Tables[0] != null) | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2ffe087d | FindButton 외 1 | SSP0046_ShipmentRequest.cs:663 | try ▸ if (ds.Tables[0] != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a32e7874 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:664 | try ▸ if (ds.Tables[0] != null) | GRID_LOCK | siMain.LockColumn2 | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-69fa0246 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:670 | try ▸ if (siMain.GetMaxRowIndex() >= 0) | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-384ad47e | FindButton 외 1 | SSP0046_ShipmentRequest.cs:681 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns… | CALL_EXT | Convert.ToInt16 | (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ShipFrozen)).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-46cd5093 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:704 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) | GRID_STYLE | siMain.SetBGColor | (iRow, iStartCol, iRow, iStartCol + FrozenCnt, Color.FromArgb(242, 242, 242)) | 그리드 표시 설정 |  |  |  |
| AC-825cb655 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:708 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.Measure), iRow, siMain.GetColumnIndex(DefColumns.M… | 그리드 표시 설정 |  |  |  |
| AC-80132d3e | FindButton 외 1 | SSP0046_ShipmentRequest.cs:721 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns… | GRID_STYLE | siMain.SetBGColor | (iRow, iFrom, iRow, iTo, Color.FromArgb(219, 229, 241)) | 그리드 표시 설정 |  |  |  |
| AC-171c7a7c | FindButton 외 1 | SSP0046_ShipmentRequest.cs:727 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-baa665c4 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:735 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c73746aa | FindButton 외 1 | SSP0046_ShipmentRequest.cs:739 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1b0dcd28 | FindButton 외 1 | SSP0046_ShipmentRequest.cs:741 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0046_ShipmentRequest.fnValidation

진입점: SaveButton [try ▸ if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a614677 | SaveButton [try ▸ if (fps.Name == "spdMain")] | SSP0046_ShipmentRequest.cs:2265 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-d07aa4c3 | SaveButton [try ▸ if (fps.Name == "spdMain")] | SSP0046_ShipmentRequest.cs:2268 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## SSP0046_ShipmentRequest.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ebf2e8c | this.Load | SSP0046_ShipmentRequest.cs:171 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e910ee38 | this.Load | SSP0046_ShipmentRequest.cs:172 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0046_ShipmentRequest.GetBizTypebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2a36256 | (진입점 미연결) | SSP0046_ShipmentRequest.cs:2305 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_GET_BIZ_TYPE_BY_DIVISION") ⇒ SSP.SSP0046_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-46763813 | (진입점 미연결) | SSP0046_ShipmentRequest.cs:2306 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-fe621f33 | (진입점 미연결) | SSP0046_ShipmentRequest.cs:2307 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0dd2d283 | (진입점 미연결) | SSP0046_ShipmentRequest.cs:2310 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0046_ShipmentRequest.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ba3ba98 | this.Load | SSP0046_ShipmentRequest.cs:2293 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_GET_BUCKET_TYPE_CODE") ⇒ SSP.SSP0046_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-7417ccce | this.Load | SSP0046_ShipmentRequest.cs:2294 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-99a7190d | this.Load | SSP0046_ShipmentRequest.cs:2296 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0046_ShipmentRequest.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboDivision.SelectedIndexChanged [if (siMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3458e5d4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:2276 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_GET_SPREAD_TITLE") ⇒ SSP.SSP0046_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-b2a5d1ba | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:2277 |  | DATA_OP | request.Parameters["p_division_id"] | cboDivision.ControlValues==null?"":cboDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-56a1dfcd | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:2278 |  | DATA_OP | request.Parameters["p_sheet_name"] | sSheetName | 행/컬럼 값 대입 |  |  |  |
| AC-12740e0f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:2279 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f8b0e011 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:2280 |  | DATA_OP | request.Parameters["p_start_dt"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-d94c02a4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:2281 |  | DATA_OP | request.Parameters["p_end_dt"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-9a655829 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:2283 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-b66ebd0b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:2283 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b78b626d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:2284 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-4fdce38d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:2284 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0046_ShipmentRequest.GetSSPUserCheck

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3540e21f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:2339 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_USER_INFO_LIST") ⇒ SSP.SSP0002_GET_USER_INFO_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-b5af3e03 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:2343 |  | DATA_OP | request.Parameters["Search"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a30eab02 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:2344 |  | DATA_OP | request.Parameters["Language"] | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ecfa99bd | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:2345 |  | DATA_OP | request.Parameters["SSOUserYN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-422f7bc0 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:2346 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e04a69af | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:2350 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-310de893 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SSP0046_ShipmentRequest.cs:2354 |  | RETURN | return isResult; |  | 처리 중단/반환 |  |  |  |

## SSP0046_ShipmentRequest.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b1b0cfe | this.Load | SSP0046_ShipmentRequest.cs:201 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-880de3b8 | this.Load | SSP0046_ShipmentRequest.cs:201 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-81f2ee76 | this.Load | SSP0046_ShipmentRequest.cs:205 | for (i <= dtDivision.Rows.Count - 1) ▸ if (dtDivision.Rows[i]["CODE"].ToString() == "40") | DATA_OP | dtDivision.Rows.RemoveAt | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-46e6b240 | this.Load | SSP0046_ShipmentRequest.cs:207 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-41323401 | this.Load | SSP0046_ShipmentRequest.cs:210 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-4dea2aa6 | this.Load | SSP0046_ShipmentRequest.cs:210 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5052e07e | this.Load | SSP0046_ShipmentRequest.cs:211 |  | FLAG | dtTeamSpr | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-e88e5dd8 | this.Load | SSP0046_ShipmentRequest.cs:211 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1bb16235 | this.Load | SSP0046_ShipmentRequest.cs:212 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-390e3a07 | this.Load | SSP0046_ShipmentRequest.cs:215 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-a45f43a8 | this.Load | SSP0046_ShipmentRequest.cs:215 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8f0c7617 | this.Load | SSP0046_ShipmentRequest.cs:216 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-77d67371 | this.Load | SSP0046_ShipmentRequest.cs:220 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-9aa9e8d0 | this.Load | SSP0046_ShipmentRequest.cs:220 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5a3978c3 | this.Load | SSP0046_ShipmentRequest.cs:221 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-717afde2 | this.Load | SSP0046_ShipmentRequest.cs:223 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-ace97d7a | this.Load | SSP0046_ShipmentRequest.cs:223 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-29e97c9b | this.Load | SSP0046_ShipmentRequest.cs:224 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-21fb5666 | this.Load | SSP0046_ShipmentRequest.cs:226 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-8aaacb89 | this.Load | SSP0046_ShipmentRequest.cs:227 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7070a484 | this.Load | SSP0046_ShipmentRequest.cs:230 |  | VALUE_SET | drpPeriod.InitValue | DateTime.Now.ToString("yyyyMMdd") + ":" + DateTime.Now.AddDays(55).ToString("yyyyMMdd") | 컨트롤 값 설정 |  |  |  |
| AC-f9a54a29 | this.Load | SSP0046_ShipmentRequest.cs:232 |  | FLAG | dtMeasure | Data.Common(Data.Type.Measure) ⇒ biz:CommonData.CommonDataList [code=Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-631c6a6e | this.Load | SSP0046_ShipmentRequest.cs:232 |  | COMBO_DATA | Data.Common | (Data.Type.Measure) ⇒ biz:CommonData.CommonDataList [code=Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2e341982 | this.Load | SSP0046_ShipmentRequest.cs:235 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c464c24 | this.Load | SSP0046_ShipmentRequest.cs:236 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b884132 | this.Load | SSP0046_ShipmentRequest.cs:241 | if (cboDivision.ControlValues == null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00475") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0046_ShipmentRequest.InitSaveDataTable

진입점: this.cboDivision.SelectedIndexChanged [if (siMain != null)] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ebcc444 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | SSP0046_ShipmentRequest.cs:408 |  | FLAG | dtSave | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-88188e8b | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | SSP0046_ShipmentRequest.cs:409 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc0491e1 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | SSP0046_ShipmentRequest.cs:410 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Project, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae8d8f79 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | SSP0046_ShipmentRequest.cs:411 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FromSite, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0edb351a | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | SSP0046_ShipmentRequest.cs:412 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ItemId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-181ba9f9 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | SSP0046_ShipmentRequest.cs:413 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FcstType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4843bd6 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | SSP0046_ShipmentRequest.cs:414 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-48a6e01c | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | SSP0046_ShipmentRequest.cs:415 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.TrMode, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-02f796bf | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | SSP0046_ShipmentRequest.cs:416 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Measure, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0bdea0ec | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | SSP0046_ShipmentRequest.cs:417 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ToSite, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb82b5df | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | SSP0046_ShipmentRequest.cs:418 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0a03b58 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | SSP0046_ShipmentRequest.cs:421 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.BodId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d767855 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | SSP0046_ShipmentRequest.cs:422 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Qty, typeof(int)) | 데이터 객체 조작/조회 |  |  |  |

## SSP0046_ShipmentRequest.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboDivision.SelectedIndexChanged [if (siMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c636282c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:280 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## SSP0046_ShipmentRequest.InitSpreadFooterSum

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboDivision.SelectedIndexChanged [if (siMain != null) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() =…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0499df40 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:293 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c5050d3b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:294 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-357dd432 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:301 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2356b76a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:302 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8284fde4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:303 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-b1c91cc0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:304 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## SSP0046_ShipmentRequest.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-374286c3 | InsertButton | SSP0046_ShipmentRequest.cs:1004 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6f4e700c | InsertButton | SSP0046_ShipmentRequest.cs:1005 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ef42398d | InsertButton | SSP0046_ShipmentRequest.cs:1009 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)].… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-6cb9bf8e | InsertButton | SSP0046_ShipmentRequest.cs:1010 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Project)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-3905330a | InsertButton | SSP0046_ShipmentRequest.cs:1011 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TrMode)].… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-77749d28 | InsertButton | SSP0046_ShipmentRequest.cs:1017 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-10629d57 | InsertButton | SSP0046_ShipmentRequest.cs:1018 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | COMBO_DATA | Data.Common | (Data.Type.FCST_TYPE) ⇒ biz:CommonData.CommonDataList [code=FCST_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d6ced999 | InsertButton | SSP0046_ShipmentRequest.cs:1020 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FcstType), dtFcstType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e10b0165 | InsertButton | SSP0046_ShipmentRequest.cs:1021 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | FLAG | dtMeasure | Data.Common(Data.Type.Measure, false, "SSP0046", siMain.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-fdecd070 | InsertButton | SSP0046_ShipmentRequest.cs:1021 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | COMBO_DATA | Data.Common | (Data.Type.Measure, false, "SSP0046", siMain.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5f07698e | InsertButton | SSP0046_ShipmentRequest.cs:1022 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e419741d | InsertButton | SSP0046_ShipmentRequest.cs:1026 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (siMain.GetColu… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), cboDivision.ControlVal… | 그리드 값 설정 |  |  |  |
| AC-01cd63ae | InsertButton | SSP0046_ShipmentRequest.cs:1027 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), "SHIP_REQ") | 그리드 값 설정 |  |  |  |
| AC-11622c24 | InsertButton | SSP0046_ShipmentRequest.cs:1032 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (siMain.GetMaxR… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dbc7155b | InsertButton | SSP0046_ShipmentRequest.cs:1033 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (siMain.GetMaxR… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.NickName), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6649efaf | InsertButton | SSP0046_ShipmentRequest.cs:1034 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (siMain.GetMaxR… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Measure), iRow, siMain.GetColumnIndex(DefColumns.R… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ac6b645f | InsertButton | SSP0046_ShipmentRequest.cs:1059 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (iResultCol > i… | GRID_LOCK | siMain.LockRange | (iRow, iStartCol, iRow, iResultCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e68cbb40 | InsertButton | SSP0046_ShipmentRequest.cs:1060 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (iResultCol > i… | GRID_STYLE | siMain.SetBGColor | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.FromArgb(242, 242, 242)) | 그리드 표시 설정 |  |  |  |
| AC-c02ee6ea | InsertButton | SSP0046_ShipmentRequest.cs:1061 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (iResultCol > i… | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-42f891c8 | InsertButton | SSP0046_ShipmentRequest.cs:1074 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ for (iCol <= siMai… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ebff8846 | InsertButton | SSP0046_ShipmentRequest.cs:1081 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ for (iCol <= siMai… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b6949ee0 | InsertButton | SSP0046_ShipmentRequest.cs:1088 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ for (iCol <= siMai… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-94d9b6cc | InsertButton | SSP0046_ShipmentRequest.cs:1093 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0046_ShipmentRequest.OnShown

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07b7c233 | OnShown | SSP0046_ShipmentRequest.cs:188 | if (sDivision == "82") | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-111c05dd | OnShown | SSP0046_ShipmentRequest.cs:192 | else of (sDivision == "82") | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SSP0046_ShipmentRequest.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2faeaa6c | SaveButton | SSP0046_ShipmentRequest.cs:820 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-833b6e15 | SaveButton | SSP0046_ShipmentRequest.cs:824 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3ba12167 | SaveButton | SSP0046_ShipmentRequest.cs:829 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7bb42970 | SaveButton | SSP0046_ShipmentRequest.cs:832 | try ▸ if (fps.Name == "spdMain") | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-aa055e3e | SaveButton | SSP0046_ShipmentRequest.cs:832 | try ▸ if (fps.Name == "spdMain") ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4102c8f1 | SaveButton | SSP0046_ShipmentRequest.cs:837 | try ▸ if (fps.Name == "spdMain") ▸ if (!fnValidation()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1530e724 | SaveButton | SSP0046_ShipmentRequest.cs:838 | try ▸ if (fps.Name == "spdMain") ▸ if (!fnValidation()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66eacb72 | SaveButton | SSP0046_ShipmentRequest.cs:882 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-9f6abf87 | SaveButton | SSP0046_ShipmentRequest.cs:883 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-68f097bc | SaveButton | SSP0046_ShipmentRequest.cs:884 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5bb863fd | SaveButton | SSP0046_ShipmentRequest.cs:910 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-312678b2 | SaveButton | SSP0046_ShipmentRequest.cs:913 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_SAVE_SHIPMENT_REQUEST") ⇒ SSP.SSP0046_SAVE_SHIPMENT_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-4cbc6996 | SaveButton | SSP0046_ShipmentRequest.cs:916 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c3fc15b8 | SaveButton | SSP0046_ShipmentRequest.cs:918 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { re… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6b4bbdca | SaveButton | SSP0046_ShipmentRequest.cs:922 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3534cef1 | SaveButton | SSP0046_ShipmentRequest.cs:924 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-0738c5a2 | SaveButton | SSP0046_ShipmentRequest.cs:925 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-bf3b87d7 | SaveButton | SSP0046_ShipmentRequest.cs:926 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-70be8bc8 | SaveButton | SSP0046_ShipmentRequest.cs:927 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-16408bd1 | SaveButton | SSP0046_ShipmentRequest.cs:928 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | sScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-3f40c005 | SaveButton | SSP0046_ShipmentRequest.cs:929 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-8467f88a | SaveButton | SSP0046_ShipmentRequest.cs:930 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-a56cf74a | SaveButton | SSP0046_ShipmentRequest.cs:931 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_fcst_type"] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-86ab9dbe | SaveButton | SSP0046_ShipmentRequest.cs:932 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_transport_mode"] | sTransportMode | 행/컬럼 값 대입 |  |  |  |
| AC-b4fdf9b6 | SaveButton | SSP0046_ShipmentRequest.cs:933 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_bod_id"] | sBodId | 행/컬럼 값 대입 |  |  |  |
| AC-ba6f844b | SaveButton | SSP0046_ShipmentRequest.cs:934 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_measure"] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-3fcf68e9 | SaveButton | SSP0046_ShipmentRequest.cs:935 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-f28bcf5b | SaveButton | SSP0046_ShipmentRequest.cs:936 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-97cff1c3 | SaveButton | SSP0046_ShipmentRequest.cs:937 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e2cfa3d2 | SaveButton | SSP0046_ShipmentRequest.cs:938 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-164e7860 | SaveButton | SSP0046_ShipmentRequest.cs:940 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b9120310 | SaveButton | SSP0046_ShipmentRequest.cs:940 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-729f66ff | SaveButton | SSP0046_ShipmentRequest.cs:951 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bad3873d | SaveButton | SSP0046_ShipmentRequest.cs:952 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1baf2e21 | SaveButton | SSP0046_ShipmentRequest.cs:954 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | CALL_EXT | siMain.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e38fe485 | SaveButton | SSP0046_ShipmentRequest.cs:956 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-96066a28 | SaveButton | SSP0046_ShipmentRequest.cs:957 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | FLAG | base.IsChange | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ab2f98b0 | SaveButton | SSP0046_ShipmentRequest.cs:967 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (t.Dat… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e2c5f51d | SaveButton | SSP0046_ShipmentRequest.cs:968 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (t.Dat… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-70e0c4a6 | SaveButton | SSP0046_ShipmentRequest.cs:973 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-92c9909b | SaveButton | SSP0046_ShipmentRequest.cs:974 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00042") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5e26f083 | SaveButton | SSP0046_ShipmentRequest.cs:980 | try ▸ if (fps.Name == "spdMain") ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aa61119f | SaveButton | SSP0046_ShipmentRequest.cs:986 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b3a52fa5 | SaveButton | SSP0046_ShipmentRequest.cs:987 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a2a0cce9 | SaveButton | SSP0046_ShipmentRequest.cs:993 | finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0046_ShipmentRequest.Set_SumValues

진입점: FindButton [try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tables[0].Rows.Count > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dee4d85 | FindButton [try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tab… 외 1 | SSP0046_ShipmentRequest.cs:761 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-4898e962 | FindButton [try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tab… 외 1 | SSP0046_ShipmentRequest.cs:765 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea83cfda | FindButton [try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tab… 외 1 | SSP0046_ShipmentRequest.cs:800 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_BOH_PLAN") \|\| measure.Equals("WH_BOH_REQ")) ▸ for (iCol < dsBinding.T… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][iCol] | 그리드 속성/값 설정 |  |  |  |
| AC-6ed65d7d | FindButton [try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tab… 외 1 | SSP0046_ShipmentRequest.cs:805 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_BOH_PLAN") \|\| measure.Equals("WH_BOH_REQ")) ▸ for (iCol < dsBinding.T… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][iCol] | 그리드 속성/값 설정 |  |  |  |

## SSP0046_ShipmentRequest.SetImageCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8822805 | (진입점 미연결) | SSP0046_ShipmentRequest.cs:1474 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.TrMode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0046_ShipmentRequest.SetSaveData

진입점: dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0)] / dsdmCell.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-464289a4 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | SSP0046_ShipmentRequest.cs:2045 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-778a6dfc | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | SSP0046_ShipmentRequest.cs:2049 | if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5a6af98b | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | SSP0046_ShipmentRequest.cs:2050 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-11559eaa | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | SSP0046_ShipmentRequest.cs:2051 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Project] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-dd83fe5d | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | SSP0046_ShipmentRequest.cs:2052 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FromSite] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-8a6a50b9 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | SSP0046_ShipmentRequest.cs:2053 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ItemId] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-1b2ad100 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | SSP0046_ShipmentRequest.cs:2054 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FcstType] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-8a878637 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | SSP0046_ShipmentRequest.cs:2055 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Incoterms] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-2d845606 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | SSP0046_ShipmentRequest.cs:2056 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Measure] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-dc2c07ab | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | SSP0046_ShipmentRequest.cs:2057 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ToSite] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-94067553 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | SSP0046_ShipmentRequest.cs:2058 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-022e188d | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | SSP0046_ShipmentRequest.cs:2059 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-9e57d484 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | SSP0046_ShipmentRequest.cs:2061 | if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-8323d8ea | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | SSP0046_ShipmentRequest.cs:2062 | if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2852d0e4 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | SSP0046_ShipmentRequest.cs:2066 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-e6c6f2b1 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | SSP0046_ShipmentRequest.cs:2067 | else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0046_ShipmentRequest.SetSpreadColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboDivision.SelectedIndexChanged [if (siMain != null) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.chkSum.CheckedChanged [if (siMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (siMain.GetMaxRowIndex() >= 0)] / SaveButton [try ▸ if (fps.N…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef4241a4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SSP0046_ShipmentRequest.cs:2179 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-712c7993 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SSP0046_ShipmentRequest.cs:2184 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-48b9c815 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SSP0046_ShipmentRequest.cs:2191 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f385234c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SSP0046_ShipmentRequest.cs:2195 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f7e8cd61 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SSP0046_ShipmentRequest.cs:2200 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-d6ee9710 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SSP0046_ShipmentRequest.cs:2207 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f6068cfa | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SSP0046_ShipmentRequest.cs:2211 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0046_ShipmentRequest.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboDivision.SelectedIndexChanged [if (siMain != null) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() =…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-170c1298 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:335 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6ae85c34 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:343 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d8652ff4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:354 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-d9424441 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:360 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-788251b0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:361 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c654ca44 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:366 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da1822e9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:367 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71c0ca8f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:374 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-440f6afb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:375 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6570928e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:386 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a5b1d22 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:387 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-271cc6c7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:388 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e1320c15 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:389 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a172dfc0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:391 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Requestor) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d900537e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0046_ShipmentRequest.cs:393 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0046_ShipmentRequest.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9d19fd5 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1228 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumn… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-7c6e302a | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1234 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetC… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-32b6fb9d | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1250 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-4e25c918 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1264 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-38345110 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1285 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | new SSP0046_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-c2eee018 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1286 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-4254f696 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1287 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-be115862 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1288 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2b676bab | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1299 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-4c271703 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1303 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectName), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-e0baa722 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1308 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), sProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-9ddb499c | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1313 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BizType), sBizType) | 그리드 값 설정 |  |  |  |
| AC-41845f9d | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1318 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectOwner), sProjectOwner) | 그리드 값 설정 |  |  |  |
| AC-fc757594 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1323 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Customer), sEndCustomer) | 그리드 값 설정 |  |  |  |
| AC-6f25f270 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1330 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.ItemId)) | 그리드 표시 설정 |  |  |  |
| AC-ea2e1fca | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1339 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Model") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a5e6e80a | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1348 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | new SSP0046_GetBODItemPrjRoutePopup | () | 팝업/폼 생성 |  |  |  |
| AC-ef73b051 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1350 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | bodPopup.p_division_id | p_divisionId | 속성 p_division_id 설정 |  |  |  |
| AC-2643634c | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1351 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | bodPopup.p_item_id | p_item_id | 속성 p_item_id 설정 |  |  |  |
| AC-c4495bec | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1352 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | bodPopup.p_from_site | p_from_site | 속성 p_from_site 설정 |  |  |  |
| AC-569d5c69 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1354 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | bodPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9f239659 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1355 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | bodPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c7f7ad1a | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1377 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.FromSite), sFromSite) | 그리드 값 설정 |  |  |  |
| AC-1adf3049 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1382 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ToSite), sToSite) | 그리드 값 설정 |  |  |  |
| AC-8dfde94f | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1387 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Incoterms), sIncoterms) | 그리드 값 설정 |  |  |  |
| AC-accc2d61 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1392 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TrMode), sTransportMode) | 그리드 값 설정 |  |  |  |
| AC-458abf26 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1396 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BodId), sBodId) | 그리드 값 설정 |  |  |  |
| AC-b84d24e9 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1400 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Customer), sEndCustomer) | 그리드 값 설정 |  |  |  |
| AC-0be0f547 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1404 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Customer), sEndCustomer) | 그리드 값 설정 |  |  |  |
| AC-660ad2c6 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1408 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TeamName), sDeptNameKo) | 그리드 값 설정 |  |  |  |
| AC-131ec850 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1415 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.ItemId)) | 그리드 표시 설정 |  |  |  |
| AC-0d694f81 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1431 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | POPUP | new SSP0046_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-627092c6 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1433 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | POPUP | popItem.Form_Load | (false, p_divisionId, "", "", "", "", "", sBizType) | 팝업 초기화(인자 전달) |  |  |  |
| AC-18fe2b26 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1434 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d70a988e | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1435 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e32dabc4 | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1445 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ItemId), sItemId) | 그리드 값 설정 |  |  |  |
| AC-0e9e0ceb | this.spdMain.CellDoubleClick | SSP0046_ShipmentRequest.cs:1449 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NickName), sNickName) | 그리드 값 설정 |  |  |  |

## SSP0046_ShipmentRequest.spdMain_Changed

진입점: dsdmPack.Changed / dsdmCell.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5977513 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1482 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-448bbda0 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1517 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Division ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5d4dc276 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1519 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-eb92b55f | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1521 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-171b6422 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1525 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Project Code" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-643133e7 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1527 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-5bca35ae | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1529 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af2a81fa | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1533 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Sales Site ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cddc0220 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1535 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-70191f33 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1537 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed2ef3fd | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1541 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Item ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-15711c38 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1543 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-e78b47ed | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1545 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aae3efc2 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1549 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "FCST Type" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3c833cc6 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1551 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-6a826ff5 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1553 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af5ba109 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1557 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Incoterms" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-db1a2b22 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1559 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-639ceccb | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1561 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf8c522a | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1565 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dba14547 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1567 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-1e02af6c | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1569 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c781417a | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1573 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plant Site ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8b50e964 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1575 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-340a0a28 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1577 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5e573cb | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1604 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.Index… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 2, iWeeklySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-c4f94ef2 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1627 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.Index… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iMonthlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-549ad14f | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1641 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.Index… | GRID_SET | siMain.ActiveSheet.SetText | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |
| AC-caacdeaf | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1707 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-be1156c7 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1715 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-3dc3f872 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1730 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-c40e3e6b | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1738 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-2fe2367e | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1760 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-35d4f43a | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1771 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | COMBO_DATA | Data.Common | (Data.Type.DefaultBucketDay, false, sDivision, sBucketType) ⇒ biz:CommonData.CommonDataList [code=DefaultBucketDay] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c666ba8a | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1785 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-44e2e003 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1795 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iSetCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-97b62916 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1823 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iMonthlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-5b8a73ee | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1833 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | COMBO_DATA | Data.Common | (Data.Type.DefaultBucketDay, false, sDivision, sBucketType) ⇒ biz:CommonData.CommonDataList [code=DefaultBucketDay] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-45c5ba2f | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1914 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-b42ac755 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1922 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-f26aafc0 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1936 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-6f2a217c | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1944 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-7613bfc7 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1961 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-d1399f03 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1991 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-de6fc76f | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:1996 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-b99ad954 | dsdmPack.Changed 외 1 | SSP0046_ShipmentRequest.cs:2022 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iWeekCol, iWeeklySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |

## SSP0046_ShipmentRequest.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-137e36d7 | this.spdMain.ComboSelChange | SSP0046_ShipmentRequest.cs:1174 | if (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-a7bea373 | this.spdMain.ComboSelChange | SSP0046_ShipmentRequest.cs:1174 | if (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2445d94e | this.spdMain.ComboSelChange | SSP0046_ShipmentRequest.cs:1175 | if (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.FromSite), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f645ec9f | this.spdMain.ComboSelChange | SSP0046_ShipmentRequest.cs:1179 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Project), "") | 그리드 값 설정 |  |  |  |
| AC-9691e9a0 | this.spdMain.ComboSelChange | SSP0046_ShipmentRequest.cs:1183 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectName), "") | 그리드 값 설정 |  |  |  |
| AC-e79e01a9 | this.spdMain.ComboSelChange | SSP0046_ShipmentRequest.cs:1188 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), "") | 그리드 값 설정 |  |  |  |
| AC-9f96828d | this.spdMain.ComboSelChange | SSP0046_ShipmentRequest.cs:1193 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BizType), "") | 그리드 값 설정 |  |  |  |
| AC-1f3d5961 | this.spdMain.ComboSelChange | SSP0046_ShipmentRequest.cs:1198 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Project), "") | 그리드 값 설정 |  |  |  |
| AC-3e0171d5 | this.spdMain.ComboSelChange | SSP0046_ShipmentRequest.cs:1203 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Project), "") | 그리드 값 설정 |  |  |  |
| AC-6342298f | this.spdMain.ComboSelChange | SSP0046_ShipmentRequest.cs:1211 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-5fed8ebe | this.spdMain.ComboSelChange | SSP0046_ShipmentRequest.cs:1211 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e2a751d1 | this.spdMain.ComboSelChange | SSP0046_ShipmentRequest.cs:1212 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SSP0046_ShipmentRequest.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9da2693b | this.spdMain.KeyUp | SSP0046_ShipmentRequest.cs:2081 | if (siMain.GetColumnIndex(DefColumns.Requestor) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fbc5447a | this.spdMain.KeyUp | SSP0046_ShipmentRequest.cs:2085 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8fdde443 | this.spdMain.KeyUp | SSP0046_ShipmentRequest.cs:2090 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f699ec4 | this.spdMain.KeyUp | SSP0046_ShipmentRequest.cs:2091 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0046_ShipmentRequest.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcb0597c | this.spdMain.TopChange | SSP0046_ShipmentRequest.cs:2075 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0046_TitleSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65c63308 | .ctor | SSP0046_TitleSetForm_Popup.cs:64 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-70f82e89 | .ctor | SSP0046_TitleSetForm_Popup.cs:65 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-de2a94d1 | .ctor | SSP0046_TitleSetForm_Popup.cs:66 |  | FLAG | _sTitleSetType | isColumn ? "C" : "M" | 화면 필드/플래그 변경 |  |  |  |
| AC-919b2e4b | .ctor | SSP0046_TitleSetForm_Popup.cs:76 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-c7867cd5 | .ctor | SSP0046_TitleSetForm_Popup.cs:77 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-d1fdfb8c | .ctor | SSP0046_TitleSetForm_Popup.cs:78 |  | FLAG | _sTitleSetType | isColumn ? "C" : "M" | 화면 필드/플래그 변경 |  |  |  |
| AC-f3bbf64f | .ctor | SSP0046_TitleSetForm_Popup.cs:79 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |
| AC-b3224b45 | .ctor | SSP0046_TitleSetForm_Popup.cs:87 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-72ca7339 | .ctor | SSP0046_TitleSetForm_Popup.cs:88 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-0baf8f3b | .ctor | SSP0046_TitleSetForm_Popup.cs:89 |  | FLAG | _sTitleSetType | isColumn ? "C" : "M" | 화면 필드/플래그 변경 |  |  |  |
| AC-26e631d8 | .ctor | SSP0046_TitleSetForm_Popup.cs:91 |  | FLAG | _dtTitleSet | dt | 화면 필드/플래그 변경 |  |  |  |
| AC-3a0626d8 | .ctor | SSP0046_TitleSetForm_Popup.cs:97 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-03bfc4cf | .ctor | SSP0046_TitleSetForm_Popup.cs:98 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-93d33ab5 | .ctor | SSP0046_TitleSetForm_Popup.cs:99 |  | FLAG | _sTitleSetType | isColumn ? "C" : "M" | 화면 필드/플래그 변경 |  |  |  |
| AC-d31e2521 | .ctor | SSP0046_TitleSetForm_Popup.cs:101 |  | FLAG | _dtTitleSet | dt | 화면 필드/플래그 변경 |  |  |  |
| AC-c192eabd | .ctor | SSP0046_TitleSetForm_Popup.cs:107 | for (k < sBtnList.Length) | DATA_OP | usrButtonList2.UsrButtonItems.Add | (new ButtonItem(ButtonListType.Default, sBtnList[k], false, true, false)) | 데이터 객체 조작/조회 |  |  |  |
| AC-def0885f | .ctor | SSP0046_TitleSetForm_Popup.cs:109 |  | STATE | usrButtonList2.Visible | true | 컨트롤 상태 Visible |  |  |  |

## SSP0046_TitleSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a06e2102 | Dispose | SSP0046_TitleSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0046_TitleSetForm_Popup.GetTitleSet

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f850759 | .ctor | SSP0046_TitleSetForm_Popup.cs:243 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0046_GET_TITLESET_POPUP") ⇒ SSP.SSP0046_GET_TITLESET_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-4643af26 | .ctor | SSP0046_TitleSetForm_Popup.cs:244 |  | DATA_OP | request.Parameters["p_program_id"] | _sProgramID | 행/컬럼 값 대입 |  |  |  |
| AC-b1539f0c | .ctor | SSP0046_TitleSetForm_Popup.cs:245 |  | DATA_OP | request.Parameters["p_sheet_name"] | _sSheetName | 행/컬럼 값 대입 |  |  |  |
| AC-64bdd749 | .ctor | SSP0046_TitleSetForm_Popup.cs:246 |  | DATA_OP | request.Parameters["p_column_type"] | _sTitleSetType | 행/컬럼 값 대입 |  |  |  |
| AC-3d97e5b8 | .ctor | SSP0046_TitleSetForm_Popup.cs:247 |  | DATA_OP | request.Parameters["p_user_id"] | _sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-69ee2e1b | .ctor | SSP0046_TitleSetForm_Popup.cs:248 |  | DATA_OP | request.Parameters["p_division_id"] | _sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-30ec23dc | .ctor | SSP0046_TitleSetForm_Popup.cs:249 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-821f0182 | .ctor | SSP0046_TitleSetForm_Popup.cs:250 |  | FLAG | _dtTitleSet | response.DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SSP0046_TitleSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01ba64e3 | this.Load | SSP0046_TitleSetForm_Popup.cs:129 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## SSP0046_TitleSetForm_Popup.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20921571 | this.Load | SSP0046_TitleSetForm_Popup.cs:133 |  | UI_PROP | pnlBottom.Dock | DockStyle.Bottom | 속성 Dock 설정 |  |  |  |
| AC-e40d51ad | this.Load | SSP0046_TitleSetForm_Popup.cs:135 |  | UI_PROP | pnlCenter.Dock | DockStyle.Left | 속성 Dock 설정 |  |  |  |
| AC-f878e104 | this.Load | SSP0046_TitleSetForm_Popup.cs:137 |  | UI_PROP | spdBase.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-26f59540 | this.Load | SSP0046_TitleSetForm_Popup.cs:138 |  | UI_PROP | spdUser.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-664b1e53 | this.Load | SSP0046_TitleSetForm_Popup.cs:139 |  | UI_PROP | splMain.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-78b8a716 | this.Load | SSP0046_TitleSetForm_Popup.cs:141 |  | VALUE_SET | this.Text | _sTitleSetType == "C" ? "Column Setting" : "Measure Setting" | 컨트롤 값 설정 |  |  |  |
| AC-a83ccd93 | this.Load | SSP0046_TitleSetForm_Popup.cs:142 |  | UI_PROP | this.Size | new Size(440, 400) | 속성 Size 설정 |  |  |  |
| AC-b0a7db37 | this.Load | SSP0046_TitleSetForm_Popup.cs:145 |  | UI_PROP | this.Size | new Size(_sTitleSetType == "C" ? 600 : 600, 400) | 속성 Size 설정 |  |  |  |
| AC-09c7d1b2 | this.Load | SSP0046_TitleSetForm_Popup.cs:148 |  | UI_PROP | splMain.SplitterDistance | this.Width / iSplitter - ((pnlCenter.Width + splMain.SplitterWidth)) | 속성 SplitterDistance 설정 |  |  |  |
| AC-fc18ba86 | this.Load | SSP0046_TitleSetForm_Popup.cs:149 |  | UI_PROP | splMain.SplitterDistance | this.Width / iSplitter - ((pnlCenter.Width + splMain.SplitterWidth) / 2) | 속성 SplitterDistance 설정 |  |  |  |

## SSP0046_TitleSetForm_Popup.InitSheet

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57f33be7 | this.Load | SSP0046_TitleSetForm_Popup.cs:156 |  | DATA_OP | dt.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5455c121 | this.Load | SSP0046_TitleSetForm_Popup.cs:157 |  | DATA_OP | dt.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-2a0da0cc | this.Load | SSP0046_TitleSetForm_Popup.cs:158 |  | DATA_OP | dt.Rows.Add | (new object[] { "ASC", "ASC" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6fbad3c | this.Load | SSP0046_TitleSetForm_Popup.cs:159 |  | DATA_OP | dt.Rows.Add | (new object[] { "DESC", "DESC" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-56f1be0e | this.Load | SSP0046_TitleSetForm_Popup.cs:175 |  | GRID_INIT | this.AddSheet | (spdBase, "Base", "Base", 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-508bcda4 | this.Load | SSP0046_TitleSetForm_Popup.cs:177 |  | GRID_INIT | clsCtrl.InitSheet | (si, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-e3aa21af | this.Load | SSP0046_TitleSetForm_Popup.cs:178 |  | UI_PROP | si.IsRowMove | !_isBaseSort | 속성 IsRowMove 설정 |  |  |  |
| AC-1d0796d4 | this.Load | SSP0046_TitleSetForm_Popup.cs:179 |  | GRID_INIT | si.AddTextColumn | ("ColumnName", "COLUMN_NAME", FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5ca37efc | this.Load | SSP0046_TitleSetForm_Popup.cs:181 |  | GRID_INIT | si.AddTextColumn | ("LargeClass", "LARGE_CLASS_LABEL_NAME", FPMerge.Always, 80, isLarge) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d43883ef | this.Load | SSP0046_TitleSetForm_Popup.cs:182 |  | GRID_INIT | si.AddTextColumn | ("SmallClass", "SMALL_CLASS_LABEL_NAME", FPMerge.Always, 80, isSmall) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0edc9554 | this.Load | SSP0046_TitleSetForm_Popup.cs:183 |  | GRID_INIT | si.AddTextColumn | (columnTitle, "COLUMN_LABEL_NAME", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13006dce | this.Load | SSP0046_TitleSetForm_Popup.cs:184 |  | GRID_INIT | si.AddTextColumn | ("Sort", "SORT_METHOD_CODE", FPMerge.None, 45, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cc0091f0 | this.Load | SSP0046_TitleSetForm_Popup.cs:185 |  | GRID_INIT | si.AddNumColumn | ("Seq", "SORT_ORDER_NO", FPMerge.None, 20, false, FPHAlign.Right, FPVAlign.Center, 2, fals… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f3d9e55 | this.Load | SSP0046_TitleSetForm_Popup.cs:186 |  | GRID_INIT | si.AddTextColumn | ("Sort", "USER_SORT_METHOD_CODE", FPMerge.None, 45, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-acb583a6 | this.Load | SSP0046_TitleSetForm_Popup.cs:187 |  | GRID_INIT | si.AddCheckColumn | ("Sub Total", "SUB_TOTAL_FLAG", FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d44b6da2 | this.Load | SSP0046_TitleSetForm_Popup.cs:188 |  | GRID_INIT | si.AddTextColumn | ("USER_SELECTABLE_FLAG", "USER_SELECTABLE_FLAG", FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-39fa99a2 | this.Load | SSP0046_TitleSetForm_Popup.cs:190 |  | GRID_SET | spdBase.Sheets[0].Columns[0, spdBase.Sheets[0].ColumnCount - 1].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-a0fbf70f | this.Load | SSP0046_TitleSetForm_Popup.cs:193 |  | GRID_INIT | this.AddSheet | (spdUser, "User", "User", 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f93fe5fc | this.Load | SSP0046_TitleSetForm_Popup.cs:195 |  | GRID_INIT | clsCtrl.InitSheet | (si, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-f529e714 | this.Load | SSP0046_TitleSetForm_Popup.cs:196 |  | UI_PROP | si.IsRowMove | !_isBaseSort | 속성 IsRowMove 설정 |  |  |  |
| AC-6639b220 | this.Load | SSP0046_TitleSetForm_Popup.cs:197 |  | GRID_INIT | si.AddTextColumn | ("ColumnName", "COLUMN_NAME", FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d4c40d4c | this.Load | SSP0046_TitleSetForm_Popup.cs:199 |  | GRID_INIT | si.AddTextColumn | ("LargeClass", "LARGE_CLASS_LABEL_NAME", FPMerge.Always, 80, isLarge) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fbe7dcd7 | this.Load | SSP0046_TitleSetForm_Popup.cs:200 |  | GRID_INIT | si.AddTextColumn | ("SmallClass", "SMALL_CLASS_LABEL_NAME", FPMerge.Always, 80, isSmall) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-533d81f0 | this.Load | SSP0046_TitleSetForm_Popup.cs:201 |  | GRID_INIT | si.AddTextColumn | (columnTitle, "COLUMN_LABEL_NAME", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1327dc3f | this.Load | SSP0046_TitleSetForm_Popup.cs:202 |  | GRID_INIT | si.AddTextColumn | ("Sort", "SORT_METHOD_CODE", FPMerge.None, 45, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f68aa97d | this.Load | SSP0046_TitleSetForm_Popup.cs:203 |  | GRID_INIT | si.AddNumColumn | ("Seq", "SORT_ORDER_NO", FPMerge.None, 20, false, FPHAlign.Right, FPVAlign.Center, 2, fals… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dd61a0f0 | this.Load | SSP0046_TitleSetForm_Popup.cs:204 |  | GRID_INIT | si.AddComboColumn | ("Sort", "USER_SORT_METHOD_CODE", FPMerge.None, 45, isColumn, dt) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-827f6cc3 | this.Load | SSP0046_TitleSetForm_Popup.cs:205 |  | GRID_INIT | si.AddCheckColumn | ("Sub Total", "SUB_TOTAL_FLAG", FPMerge.None, 40, _isSubTotal, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4f6d582a | this.Load | SSP0046_TitleSetForm_Popup.cs:206 |  | GRID_INIT | si.AddTextColumn | ("USER_SELECTABLE_FLAG", "USER_SELECTABLE_FLAG", FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a50502f6 | this.Load | SSP0046_TitleSetForm_Popup.cs:208 |  | GRID_SET | spdUser.Sheets[0].Columns[0, spdUser.Sheets[0].Columns["COLUMN_LABEL_NAME"].Index].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-fc5c3fbe | this.Load | SSP0046_TitleSetForm_Popup.cs:209 |  | GRID_SET | spdUser.Sheets[0].Columns[spdUser.Sheets[0].Columns["USER_SORT_METHOD_CODE"].Index, spdUse… | ControlColor.UnLockColor | 그리드 속성/값 설정 |  |  |  |

## SSP0046_TitleSetForm_Popup.ResetWidth

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8420bb99 | this.Load | SSP0046_TitleSetForm_Popup.cs:231 |  | UI_PROP | this.Width | += iWidth | 속성 Width 설정 |  |  |  |
| AC-863dd0ce | this.Load | SSP0046_TitleSetForm_Popup.cs:232 |  | UI_PROP | splMain.SplitterDistance | this.Width / 2 - iWidth2 | 속성 SplitterDistance 설정 |  |  |  |

## SSP0046_TitleSetForm_Popup.SaveTitleSet

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d72b09ee | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:509 | try ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ SSP.SSP0046_SET_TITLESET_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-a604944e | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:510 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_program_id"] | sProgramID | 행/컬럼 값 대입 |  |  |  |
| AC-7038bb95 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:511 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sheet_name"] | sSheetName | 행/컬럼 값 대입 |  |  |  |
| AC-9bb0a7a4 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:512 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_column_type"] | sTitleSetType | 행/컬럼 값 대입 |  |  |  |
| AC-86f990f3 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:513 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sActive_flag | 행/컬럼 값 대입 |  |  |  |
| AC-752c85d1 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:514 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_column_name"] | sColumnName | 행/컬럼 값 대입 |  |  |  |
| AC-daafb7d2 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:515 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sort_order_no"] | sSortOrderNo | 행/컬럼 값 대입 |  |  |  |
| AC-b9690f4f | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:516 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sub_total_flag"] | sSubTotalFlag | 행/컬럼 값 대입 |  |  |  |
| AC-32e1a03f | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:517 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sort_method_code"] | sSortMethod | 행/컬럼 값 대입 |  |  |  |
| AC-4ba7602e | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:518 | try ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-453e34be | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:520 | try ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b4998dd7 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:525 | try ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e909e30d | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:529 | try ▸ if (iCount > 0) ▸ finally | MESSAGE | MessageHelper.GMessageBox | ("MSG00020", new object[] { _sTitleSetType == "C" ? "Column" : "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b2f7708b | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:530 | try ▸ if (iCount > 0) ▸ finally | CALL_BASE | FindButton | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-88791f7a | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:543 | try ▸ if (iCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { _sTitleSetType == "C" ? "Column" : "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bfc206fb | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:544 | try ▸ if (iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1e72187 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SSP0046_TitleSetForm_Popup.cs:564 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006", new object[] { _sTitleSetType == "C" ? "Column" : "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0046_TitleSetForm_Popup.setBaseSort

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-747135a1 | (진입점 미연결) | SSP0046_TitleSetForm_Popup.cs:54 |  | FLAG | _isBaseSort | isBool | 화면 필드/플래그 변경 |  |  |  |

## SSP0046_TitleSetForm_Popup.SetTitleSet

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Default:] / this.spdBase.CellDoubleClick / this.spdUser.CellDoubleClick / this.btnRight.Click / this.btnLeft.Click / this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ff4eb25 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:269 |  | DATA_OP | _dtTitleSet.Select | (sFilterColumn + " = 'N'", "SORT_ORDER_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-8309b704 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:269 |  | DATA_OP | _dtTitleSet.Select(sFilterColumn + " = 'N'", "SORT_ORDER_NO").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5a1421df | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:269 |  | DATA_OP | _dtTitleSet.Select | (sFilterColumn + " = 'N'", "SORT_ORDER_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-a7394bd7 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:270 |  | DATA_OP | _dtTitleSet.Select | (sFilterColumn + " = 'Y'", sSortColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-8dd777f6 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:270 |  | DATA_OP | _dtTitleSet.Select(sFilterColumn + " = 'Y'", sSortColumn).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2960c831 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:270 |  | DATA_OP | _dtTitleSet.Select | (sFilterColumn + " = 'Y'", sSortColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1bafc81 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:274 | if (dtBase == null) | GRID_SET | spdBase.Sheets[0].RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-8b7da240 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:276 | else of (dtBase == null) | GRID_BIND | si.Query | (dtBase) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4f835ec4 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:280 | if (dtUser == null) | GRID_SET | spdUser.Sheets[0].RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-41ec2b65 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:282 | else of (dtUser == null) | GRID_BIND | si.Query | (dtUser) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7cb6be40 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:291 | for (r < svSource.Rows.Count) ▸ if (svSource.Cells[r, svSource.Columns["SUB_TOTAL_FLAG"].Index].Text == "Y") | GRID_SET | svSource.Cells[r, svSource.Columns["SUB_TOTAL_FLAG"].Index].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-2ac2d62b | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:295 | if (spdUser.Sheets[0].RowCount > 0) | GRID_SET | spdUser.Sheets[0].ActiveRowIndex | spdUser.Sheets[0].RowCount - 1 | 그리드 속성/값 설정 |  |  |  |
| AC-794720ac | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:301 |  | CALL_EXT | svSource.GetSelections().GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d165309a | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:302 | if (svSource.GetSelections().GetLength(0) == 0) | CALL_EXT | svSource.AddSelection | (svSource.ActiveRowIndex, svSource.ActiveColumnIndex, 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fb9d7677 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:325 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7c448e9 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:328 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex[i] | svSource.Cells[i, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-daeef57d | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:330 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex.ContainsKey | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-489042df | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:331 | if (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!selectI… | DATA_OP | selectIndex[j] | svSource.Cells[j, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-97b45931 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:342 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-74562899 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:343 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex[i] | svSource.Cells[i, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-de7b6dd4 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:345 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex.ContainsKey | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4a7c5ae | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:346 | else of (svSource == spdUser.Sheets[0]) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in crs) ▸ for (i < cr.Row + cr.RowCount) ▸ if (!se… | DATA_OP | selectIndex[j] | svSource.Cells[j, svSource.Columns["SORT_ORDER_NO"].Index].Text | 행/컬럼 값 대입 |  |  |  |
| AC-f6d8fc6e | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:379 | foreach (int i in selectIndex.Keys) ▸ else of (activeRow + 1 >= svTarget.RowCount) | DATA_OP | svTarget.Rows.Add | (activeRow + 1, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3352f3a | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:382 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["COLUMN_NAME"].Index].Text | sColumnName | 그리드 속성/값 설정 |  |  |  |
| AC-38300f1f | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:383 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["COLUMN_LABEL_NAME"].Index].Text | sLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-743017fb | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:384 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["SMALL_CLASS_LABEL_NAME"].Index].Text | sSLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-a95e0aca | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:385 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["LARGE_CLASS_LABEL_NAME"].Index].Text | sLLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-55ac8cf8 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:386 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["SORT_METHOD_CODE"].Index].Text | sSortMethod | 그리드 속성/값 설정 |  |  |  |
| AC-746feb74 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:387 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["SORT_ORDER_NO"].Index].Text | sSortOrderNo | 그리드 속성/값 설정 |  |  |  |
| AC-4e32ec7d | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:388 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["USER_SORT_METHOD_CODE"].Index].Text | sUSortMethod | 그리드 속성/값 설정 |  |  |  |
| AC-181b1c99 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:389 | foreach (int i in selectIndex.Keys) | GRID_SET | svTarget.Cells[iRow, svTarget.Columns["USER_SELECTABLE_FLAG"].Index].Text | sUserSelectedFlag | 그리드 속성/값 설정 |  |  |  |
| AC-d7899d72 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:395 |  | GRID_STYLE | svTarget.SetActiveCell | (activeRow, -1) | 그리드 표시 설정 |  |  |  |
| AC-b5dfd63f | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:400 | for (i >= 0) | DATA_OP | selectIndex.ContainsKey | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-25ef17c6 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:402 | for (i >= 0) ▸ if (selectIndex.ContainsKey(i)) | CALL_EXT | svSource.RemoveRows | (i, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4236469e | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:407 | if (_isBaseSort == true) | CALL_EXT | svTarget.SortRows | (svTarget.Columns["SORT_ORDER_NO"].Index, true, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-65a9420c | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SSP0046_TitleSetForm_Popup.cs:411 | else of (_isBaseSort == true) ▸ if (svTarget == spdBase.Sheets[0]) | CALL_EXT | svTarget.SortRows | (svTarget.Columns["SORT_ORDER_NO"].Index, true, false) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0046_TitleSetForm_Popup.spdUser_ButtonClicked

진입점: this.spdUser.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b998210 | this.spdUser.ButtonClicked | SSP0046_TitleSetForm_Popup.cs:592 | if (e.Column != sv.Columns["SUB_TOTAL_FLAG"].Index) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e5256ac | this.spdUser.ButtonClicked | SSP0046_TitleSetForm_Popup.cs:596 | for (i < sv.RowCount) | GRID_SET | sv.Cells[i, e.Column].Value | "false" | 그리드 속성/값 설정 |  |  |  |

## SSP0046_TitleSetForm_Popup.spdUser_RowDragMove

진입점: this.spdUser.RowDragMove

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5b2a427 | this.spdUser.RowDragMove | SSP0046_TitleSetForm_Popup.cs:632 | if (sUserSelect != "Y") | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |

## SSP0046_TitleSetForm_Popup.TitleSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc5c84c0 | this.Load | SSP0046_TitleSetForm_Popup.cs:116 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f2440f3f | this.Load | SSP0046_TitleSetForm_Popup.cs:124 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SSP0046_TitleSetForm_Popup.TitleSetForm_SizeChanged

진입점: this.SizeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35875807 | this.SizeChanged | SSP0046_TitleSetForm_Popup.cs:602 |  | UI_PROP | pnlCenterButton.Top | (pnlCenter.Height - pnlCenterButton.Height) / 2 | 속성 Top 설정 |  |  |  |

## SSP0046_TitleSetForm_Popup.usrButtonList1_UsrButtonList_Click_Detected

진입점: this.usrButtonList1.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad25010d | this.usrButtonList1.UsrButtonList_Click_Detected | SSP0046_TitleSetForm_Popup.cs:617 | switch (buttonItem.UserType) case ButtonListType.Cancel: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

