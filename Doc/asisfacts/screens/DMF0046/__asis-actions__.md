# AS-IS 액션 대조표 — DMF0046

> 원천: `Doc/asisfacts/screens/DMF0046/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 79행 · 메서드 10 · 종류 GRID_INIT 52 · FLAG 9 · UI_MISC 5 · ENDPOINT 3 · DATA_OP 3 · UI_PROP 2 · RETURN 2 · GRID_LOCK 2 · GRID_BIND 1 · ⚠ 의미 확인 필요 0


## DMF0046_GetBODItemPrjRoutePopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9afa3be | .ctor | DMF0046_GetBODItemPrjRoutePopup.cs:161 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0046_GetBODItemPrjRoutePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58364444 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0046_GetBODItemPrjRoutePopup.cs:324 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0046_GetBODItemPrjRoutePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-118793f8 | this.Load | DMF0046_GetBODItemPrjRoutePopup.cs:195 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-244eb700 | this.Load | DMF0046_GetBODItemPrjRoutePopup.cs:196 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d278fa33 | this.Load | DMF0046_GetBODItemPrjRoutePopup.cs:197 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0046_GetBODItemPrjRoutePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2e33a6c | Dispose | DMF0046_GetBODItemPrjRoutePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0046_GetBODItemPrjRoutePopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b425d4b6 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:291 |  | ENDPOINT | proxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SCM.Maste… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-05b3bd52 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:294 | lambda | ENDPOINT | new FoxDataRequest | (procdName) ⇒ {?string.Empty} \| DM.DMF0046_GET_BODITEM_FOR_PRJROUTE_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-052891fc | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:296 | lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-cd09ad05 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:297 | lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-564dc1c7 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:298 | lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-2b52c6b4 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:300 | lambda | UI_PROP | req.CommandTimeout | 60 * 3 | 속성 CommandTimeout 설정 |  |  |  |
| AC-fb6df39e | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:302 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b0c14064 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:303 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4487da4a | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:307 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-58844a35 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:308 |  | GRID_LOCK | siMain.LockColumn | (1, siMain.GetColumnIndex(DefColumns.LEAD_TIME), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-599ce938 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:310 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0046_GetBODItemPrjRoutePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce2fa344 | this.Load | DMF0046_GetBODItemPrjRoutePopup.cs:171 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0046_GetBODItemPrjRoutePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c763e41 | this.Load | DMF0046_GetBODItemPrjRoutePopup.cs:190 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## DMF0046_GetBODItemPrjRoutePopup.InitSpread

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cd65b82 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:202 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b33a555b | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:205 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.LOCK, DefColumns.LOCK, FPMerge.None, 90, false, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-81460095 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:206 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.FROM_SITE, DefColumns.FROM_SITE, FPMerge.None, 110, false , FPHAlign.Left,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e36e292 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:207 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.FROM_DIVISION_ID, DefColumns.FROM_DIVISION_ID, FPMerge.None, 110, false, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6f678430 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:208 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.FROM_SITE_NAME, DefColumns.FROM_SITE_NAME, FPMerge.None, 140, true, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e05502d2 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:209 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.TO_SITE, DefColumns.TO_SITE, FPMerge.None, 110, false, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-87295a64 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:210 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.TO_DIVISION_ID, DefColumns.TO_DIVISION_ID, FPMerge.None, 110, false, FPHAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b0e07ed | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:211 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.TO_SITE_NAME, DefColumns.TO_SITE_NAME, FPMerge.None, 140, true, FPHAlign.L… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9423223a | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:212 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.ITEM_ID, DefColumns.ITEM_ID, FPMerge.None, 150, true, FPHAlign.Left, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-970ab6a3 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:213 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.PRIORITY, DefColumns.PRIORITY, FPMerge.None, 70, true, FPHAlign.Center, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-63bd019b | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:214 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.BOD_ID, DefColumns.BOD_ID, FPMerge.None, 110, false, FPHAlign.Left, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9517be34 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:215 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.FROZEN_YYYYMMDD, DefColumns.FROZEN_YYYYMMDD, FPMerge.None, 110, false, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc4b9614 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:216 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.INCOTERMS, DefColumns.INCOTERMS , FPMerge.None, 70, true, FPHAlign.Left , … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e4339bc5 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:217 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.TRANSPORT_MODE, DefColumns.TRANSPORT_MODE, FPMerge.None, 70, true, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae67cff3 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:218 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.BOD_ITEM_VALID, DefColumns.BOD_ITEM_VALID, FPMerge.None, 60, true, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-427eaf17 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:219 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.VOYAGE_MON, DefColumns.VOYAGE_MON , FPMerge.None, 45, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7fd5dff3 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:220 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.VOYAGE_TUE, DefColumns.VOYAGE_TUE , FPMerge.None, 45, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b1ebeea0 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:221 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.VOYAGE_WED, DefColumns.VOYAGE_WED , FPMerge.None, 45, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5ec6d753 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:222 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.VOYAGE_THU, DefColumns.VOYAGE_THU , FPMerge.None, 45, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4829698a | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:223 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.VOYAGE_FRI, DefColumns.VOYAGE_FRI , FPMerge.None, 45, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0068aa1f | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:224 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.VOYAGE_SAT, DefColumns.VOYAGE_SAT , FPMerge.None, 45, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-43be89e7 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:225 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.VOYAGE_SUN, DefColumns.VOYAGE_SUN , FPMerge.None, 45, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a96ee88 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:226 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.LEAD_TIME, DefColumns.LEAD_TIME, FPMerge.None, 90, true, FPHAlign.Right, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ade127be | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:227 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.END_CUSTOMER, DefColumns.END_CUSTOMER, FPMerge.None, 90, false, FPHAlign.R… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-563045fc | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:228 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnLabel.DEPT_NAME_KO, DefColumns.DEPT_NAME_KO, FPMerge.None, 90, false, FPHAlign.R… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-38613a1a | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:231 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.LOCK), 2, 1, 30, DefColumnLabel.LOCK, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4b96032 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:232 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.FROM_SITE), 2, 1, 30, DefColumnLabel.FROM_SITE, FPHAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a196dd0d | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:233 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.FROM_DIVISION_ID), 2, 1, 30, DefColumnLabel.FROM_DIVI… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3b5a61fb | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:234 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.FROM_SITE_NAME), 2, 1, 30, DefColumnLabel.FROM_SITE_N… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5050555e | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:235 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.TO_SITE), 2, 1, 30, DefColumnLabel.TO_SITE, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb2e6605 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:236 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.TO_DIVISION_ID), 2, 1, 30, DefColumnLabel.TO_DIVISION… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-38d27232 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:237 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.TO_SITE_NAME), 2, 1, 30, DefColumnLabel.TO_SITE_NAME,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d154de10 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:238 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.ITEM_ID), 2, 1, 30, DefColumnLabel.ITEM_ID, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-11a3e3d7 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:239 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.PRIORITY), 2, 1, 30, DefColumnLabel.PRIORITY, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ec8dad3 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:240 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.BOD_ID), 2, 1, 30, DefColumnLabel.BOD_ID, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ea267eb | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:241 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.FROZEN_YYYYMMDD), 2, 1, 30, DefColumnLabel.FROZEN_YYY… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c90af97 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:242 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.INCOTERMS), 2, 1, 30, DefColumnLabel.INCOTERMS, FPHAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-870ce595 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:243 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), 2, 1, 30, DefColumnLabel.TRANSPORT_M… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b4f64562 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:244 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.BOD_ITEM_VALID), 2, 1, 30, DefColumnLabel.BOD_ITEM_VA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f651f244 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:245 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.LEAD_TIME), 2, 1, 30, DefColumnLabel.LEAD_TIME, FPHAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e14f6ffc | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:246 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.VOYAGE_MON), 1, 7, 30, "Voyage", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-469e1211 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:247 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.VOYAGE_MON), 1, 1, 30, DefColumnLabel.VOYAGE_MON, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0f3618ca | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:248 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.VOYAGE_TUE), 1, 1, 30, DefColumnLabel.VOYAGE_TUE, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e2aa2f6e | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:249 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.VOYAGE_WED), 1, 1, 30, DefColumnLabel.VOYAGE_WED, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c390e54e | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:250 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.VOYAGE_THU), 1, 1, 30, DefColumnLabel.VOYAGE_THU, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ef9382e | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:251 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.VOYAGE_FRI), 1, 1, 30, DefColumnLabel.VOYAGE_FRI, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33657d2d | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:252 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.VOYAGE_SAT), 1, 1, 30, DefColumnLabel.VOYAGE_SAT, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6915be8d | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:253 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.VOYAGE_SUN), 1, 1, 30, DefColumnLabel.VOYAGE_SUN, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f3b23a8 | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:254 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), 2, 1, 30, DefColumnLabel.END_CUSTOMER,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9023435b | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:255 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.DEPT_NAME_KO), 2, 1, 30, DefColumnLabel.DEPT_NAME_KO,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-08c9ce1a | this.Load 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:257 |  | GRID_LOCK | siMain.LockColumn | (4 , siMain.GetColumnIndex(DefColumns.LEAD_TIME), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0046_GetBODItemPrjRoutePopup.SetProject

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb55cd8c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:337 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aef91c66 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:339 |  | FLAG | FromSite | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FROM_SITE)) | 화면 필드/플래그 변경 |  |  |  |
| AC-9da26fe1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:340 |  | FLAG | ToSite | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TO_SITE)) | 화면 필드/플래그 변경 |  |  |  |
| AC-19bbf559 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:341 |  | FLAG | Incoterms | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INCOTERMS)) | 화면 필드/플래그 변경 |  |  |  |
| AC-93355e5d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:342 |  | FLAG | TransportMode | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | 화면 필드/플래그 변경 |  |  |  |
| AC-542f54fe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:343 |  | FLAG | BodId | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BOD_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-4071bbea | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:344 |  | FLAG | EndCustomer | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) | 화면 필드/플래그 변경 |  |  |  |
| AC-e8f63565 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0046_GetBODItemPrjRoutePopup.cs:345 |  | FLAG | DeptNameKo | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_NAME_KO)) | 화면 필드/플래그 변경 |  |  |  |

## DMF0046_GetBODItemPrjRoutePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-644ecab4 | this.spdMain.CellDoubleClick | DMF0046_GetBODItemPrjRoutePopup.cs:332 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

