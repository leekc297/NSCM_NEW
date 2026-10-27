# AS-IS 액션 대조표 — SCP0114

> 원천: `Doc/asisfacts/screens/SCP0114/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 681행 · 메서드 44 · 종류 DATA_OP 182 · GRID_INIT 146 · FLAG 115 · RETURN 72 · GRID_LOCK 65 · CALL_EXT 39 · LIST_REBIND 22 · ENDPOINT 10 · UI_MISC 6 · UI_PROP 6 · STATE 5 · MESSAGE 5 · GRID_BIND 2 · POPUP 2 · GRID_SET 2 · COMBO_DATA 2 · ⚠ 의미 확인 필요 39


## SCP0114_CAPA_LineMaster._defaultDataModel_Changed

진입점: _defaultDataModel.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c416b06 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1313 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-756a61d3 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1316 | if (e.Column < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-93427ec8 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1347 | if (stActiveCol == DefColumns.SITE_ID) | DATA_OP | DBUtils.Filter | (dtSiteSpread, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-51b67bac | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1351 | if (stActiveCol == DefColumns.SITE_ID) ▸ if (dtFilterSpread.Rows.Count > 0) | DATA_OP | dr[DefColumns.SITE_NAME] | dtFilterSpread.Rows[0]["NAME"].ToString().Replace(SITE_ID + " ", "") | 행/컬럼 값 대입 |  |  |  |
| AC-a8b12696 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1355 | if (stActiveCol == DefColumns.SITE_ID) ▸ else of (dtFilterSpread.Rows.Count > 0) | DATA_OP | dr[DefColumns.SITE_NAME] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-9f8b654d | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1362 | else of (stActiveCol == DefColumns.SITE_ID) ▸ if (stActiveCol == DefColumns.SITE_NAME) | DATA_OP | dtSiteAll.Select | (" NAME LIKE '%"+ SITE_NAME+"' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-3cffd706 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1366 | else of (stActiveCol == DefColumns.SITE_ID) ▸ if (stActiveCol == DefColumns.SITE_NAME) ▸ if (rows != null && rows.Length > 0) | DATA_OP | dr[DefColumns.SITE_ID] | rows[0]["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ba71efb3 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1370 | else of (stActiveCol == DefColumns.SITE_ID) ▸ if (stActiveCol == DefColumns.SITE_NAME) ▸ else of (rows != null && rows.Length > 0) | DATA_OP | dr[DefColumns.SITE_ID] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-c134915e | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1379 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ if (stActiveCol == DefColumns.COMPANY_ID) | DATA_OP | DBUtils.Filter | (dtCompanySpread, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-721382a5 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1383 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ if (stActiveCol == DefColumns.COMPANY_ID) ▸ if… | DATA_OP | dr[DefColumns.COMPANY_NAME] | dtFilterSpread.Rows[0]["NAME"].ToString().Replace(COMPANY_ID + " ", "") | 행/컬럼 값 대입 |  |  |  |
| AC-079852a6 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1387 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ if (stActiveCol == DefColumns.COMPANY_ID) ▸ el… | DATA_OP | dr[DefColumns.COMPANY_NAME] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-ce422b64 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1394 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dtCompanyAll.Select | (" NAME LIKE '%" + COMPANY_NAME + "' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-b45959ce | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1398 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dr[DefColumns.COMPANY_ID] | rows[0]["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-85a916cf | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1402 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dr[DefColumns.COMPANY_ID] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-499c6d8f | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1411 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | DBUtils.Filter | (dtPlantSpread, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0db5d4b2 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1415 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dr[DefColumns.PLANT_NAME] | dtFilterSpread.Rows[0]["NAME"].ToString().Replace(PLANT_ID + " ", "") | 행/컬럼 값 대입 |  |  |  |
| AC-69766847 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1419 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dr[DefColumns.PLANT_NAME] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-7e1063c2 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1426 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dtPlantAll.Select | (" NAME LIKE '%" + PLANT_NAME + "' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-17e6b3f4 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1430 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dr[DefColumns.PLANT_ID] | rows[0]["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-818dc26b | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1434 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dr[DefColumns.PLANT_ID] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-450f5328 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1443 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | DBUtils.Filter | (dtFactorySpread, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f56dde3f | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1447 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dr[DefColumns.FACTORY_NAME] | dtFilterSpread.Rows[0]["NAME"].ToString().Replace(FACTORY_ID + " ", "") | 행/컬럼 값 대입 |  |  |  |
| AC-67d3883e | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1451 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dr[DefColumns.FACTORY_NAME] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-eec041f4 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1458 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dtFactoryAll.Select | (" NAME LIKE '%" + FACTORY_NAME + "' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ad24839 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1462 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dr[DefColumns.FACTORY_ID] | rows[0]["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e34b4554 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1466 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dr[DefColumns.FACTORY_ID] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-69942d6b | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1475 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | DBUtils.Filter | (dtLineSpread, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8fe975f7 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1479 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dr[DefColumns.LINE_NAME] | dtFilterSpread.Rows[0]["NAME"].ToString().Replace(LINE_ID + " ", "") | 행/컬럼 값 대입 |  |  |  |
| AC-708a4c0c | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1483 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dr[DefColumns.LINE_NAME] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-709655b2 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1490 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dtLineAll.Select | (" NAME LIKE '%" + LINE_NAME + "' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-dcad3050 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1494 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dr[DefColumns.LINE_ID] | rows[0]["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fae7cd76 | _defaultDataModel.Changed | SCP0114_CAPA_LineMaster.cs:1498 | else of (stActiveCol == DefColumns.SITE_ID) ▸ else of (stActiveCol == DefColumns.SITE_NAME) ▸ else of (stActiveCol == DefColumns.COMPANY_ID)… | DATA_OP | dr[DefColumns.LINE_ID] | string.Empty | 행/컬럼 값 대입 |  |  |  |

## SCP0114_CAPA_LineMaster.cboDivision_SelectedIndexChanged

진입점: this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2892e430 | this.cboDivision.SelectedIndexChanged | SCP0114_CAPA_LineMaster.cs:1839 | if (siLevel1 != null) | FLAG | divisionID | CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-04925a60 | this.cboDivision.SelectedIndexChanged | SCP0114_CAPA_LineMaster.cs:1507 | if (siLevel1 != null) | FLAG | divisionID | CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |

## SCP0114_CAPA_LineMaster.CheckDummyDuplication

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9da65eed | SaveButton | SCP0114_CAPA_LineMaster.cs:1343 | if (spreadLevel.SheetName == "Level1") ▸ if (cnt > 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-bd3eb6ff | SaveButton | SCP0114_CAPA_LineMaster.cs:1347 | if (spreadLevel.SheetName == "Level1") ▸ else of (cnt > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-52ee6019 | SaveButton | SCP0114_CAPA_LineMaster.cs:1385 | else of (spreadLevel.SheetName == "Level1") ▸ if (spreadLevel.SheetName == "Level2") ▸ if (cnt > 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-61534c8f | SaveButton | SCP0114_CAPA_LineMaster.cs:1389 | else of (spreadLevel.SheetName == "Level1") ▸ if (spreadLevel.SheetName == "Level2") ▸ else of (cnt > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5f47e4fc | SaveButton | SCP0114_CAPA_LineMaster.cs:1427 | else of (spreadLevel.SheetName == "Level1") ▸ else of (spreadLevel.SheetName == "Level2") ▸ if (spreadLevel.SheetName == "Level3") ▸ if (cnt… | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-270d7675 | SaveButton | SCP0114_CAPA_LineMaster.cs:1431 | else of (spreadLevel.SheetName == "Level1") ▸ else of (spreadLevel.SheetName == "Level2") ▸ if (spreadLevel.SheetName == "Level3") ▸ else of… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-465314c7 | SaveButton | SCP0114_CAPA_LineMaster.cs:1469 | else of (spreadLevel.SheetName == "Level1") ▸ else of (spreadLevel.SheetName == "Level2") ▸ else of (spreadLevel.SheetName == "Level3") ▸ if… | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-626c2e37 | SaveButton | SCP0114_CAPA_LineMaster.cs:1473 | else of (spreadLevel.SheetName == "Level1") ▸ else of (spreadLevel.SheetName == "Level2") ▸ else of (spreadLevel.SheetName == "Level3") ▸ if… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-847e9c30 | SaveButton | SCP0114_CAPA_LineMaster.cs:1511 | else of (spreadLevel.SheetName == "Level1") ▸ else of (spreadLevel.SheetName == "Level2") ▸ else of (spreadLevel.SheetName == "Level3") ▸ el… | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-4e77036f | SaveButton | SCP0114_CAPA_LineMaster.cs:1515 | else of (spreadLevel.SheetName == "Level1") ▸ else of (spreadLevel.SheetName == "Level2") ▸ else of (spreadLevel.SheetName == "Level3") ▸ el… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-64713fce | SaveButton | SCP0114_CAPA_LineMaster.cs:1520 | else of (spreadLevel.SheetName == "Level1") ▸ else of (spreadLevel.SheetName == "Level2") ▸ else of (spreadLevel.SheetName == "Level3") ▸ el… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## SCP0114_CAPA_LineMaster.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de0cd49b | this.Load | SCP0114_CAPA_LineMaster.cs:206 |  | GRID_INIT | AddSheet | (spdLevel1, SpdSheet.shtLevel1, SpdSheet.shtLevel1, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d75c1c6e | this.Load | SCP0114_CAPA_LineMaster.cs:207 |  | FLAG | siLevel1 | GetSheetInfo(spdLevel1.Name, spdLevel1.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-fe7cecb0 | this.Load | SCP0114_CAPA_LineMaster.cs:209 |  | GRID_INIT | AddSheet | (spdLevel2, SpdSheet.shtLevel2, SpdSheet.shtLevel2, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ab3bd2ca | this.Load | SCP0114_CAPA_LineMaster.cs:210 |  | FLAG | siLevel2 | GetSheetInfo(spdLevel2.Name, spdLevel2.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-89102f5d | this.Load | SCP0114_CAPA_LineMaster.cs:212 |  | GRID_INIT | AddSheet | (spdLevel3, SpdSheet.shtLevel3, SpdSheet.shtLevel3, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fb6011ca | this.Load | SCP0114_CAPA_LineMaster.cs:213 |  | FLAG | siLevel3 | GetSheetInfo(spdLevel3.Name, spdLevel3.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b3288948 | this.Load | SCP0114_CAPA_LineMaster.cs:215 |  | GRID_INIT | AddSheet | (spdLevel4, SpdSheet.shtLevel4, SpdSheet.shtLevel4, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e970aeea | this.Load | SCP0114_CAPA_LineMaster.cs:216 |  | FLAG | siLevel4 | GetSheetInfo(spdLevel4.Name, spdLevel4.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-40c515ca | this.Load | SCP0114_CAPA_LineMaster.cs:218 |  | GRID_INIT | AddSheet | (spdLevel5, SpdSheet.shtLevel5, SpdSheet.shtLevel5, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2da54ea9 | this.Load | SCP0114_CAPA_LineMaster.cs:219 |  | FLAG | siLevel5 | GetSheetInfo(spdLevel5.Name, spdLevel5.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0d061370 | this.Load | SCP0114_CAPA_LineMaster.cs:221 |  | GRID_INIT | siLevel1.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f310e461 | this.Load | SCP0114_CAPA_LineMaster.cs:194 |  | GRID_INIT | AddSheet | (spdLevel1, SpdSheet.shtLevel1, SpdSheet.shtLevel1, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-534fc86f | this.Load | SCP0114_CAPA_LineMaster.cs:195 |  | FLAG | siLevel1 | GetSheetInfo(spdLevel1.Name, spdLevel1.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cbce5d52 | this.Load | SCP0114_CAPA_LineMaster.cs:197 |  | GRID_INIT | AddSheet | (spdLevel2, SpdSheet.shtLevel2, SpdSheet.shtLevel2, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7faf3d8a | this.Load | SCP0114_CAPA_LineMaster.cs:198 |  | FLAG | siLevel2 | GetSheetInfo(spdLevel2.Name, spdLevel2.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-fee5c6f0 | this.Load | SCP0114_CAPA_LineMaster.cs:200 |  | GRID_INIT | AddSheet | (spdLevel3, SpdSheet.shtLevel3, SpdSheet.shtLevel3, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9ba250b9 | this.Load | SCP0114_CAPA_LineMaster.cs:201 |  | FLAG | siLevel3 | GetSheetInfo(spdLevel3.Name, spdLevel3.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a5af396b | this.Load | SCP0114_CAPA_LineMaster.cs:203 |  | GRID_INIT | AddSheet | (spdLevel4, SpdSheet.shtLevel4, SpdSheet.shtLevel4, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9a644932 | this.Load | SCP0114_CAPA_LineMaster.cs:204 |  | FLAG | siLevel4 | GetSheetInfo(spdLevel4.Name, spdLevel4.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-feb92ea6 | this.Load | SCP0114_CAPA_LineMaster.cs:206 |  | GRID_INIT | AddSheet | (spdLevel5, SpdSheet.shtLevel5, SpdSheet.shtLevel5, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5585b32d | this.Load | SCP0114_CAPA_LineMaster.cs:207 |  | FLAG | siLevel5 | GetSheetInfo(spdLevel5.Name, spdLevel5.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a81daf8 | this.Load | SCP0114_CAPA_LineMaster.cs:209 |  | GRID_INIT | siLevel1.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0114_CAPA_LineMaster.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76fb4268 | DeleteButton | SCP0114_CAPA_LineMaster.cs:365 | if (spreadLevel == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2efcf40a | DeleteButton | SCP0114_CAPA_LineMaster.cs:368 | if (spreadLevel.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cbadddc8 | DeleteButton | SCP0114_CAPA_LineMaster.cs:371 | if (spreadLevel.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-68a8bc72 | DeleteButton | SCP0114_CAPA_LineMaster.cs:378 | if (action == CAppSetting.FlagI) | DATA_OP | spreadLevel.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1ceb543c | DeleteButton | SCP0114_CAPA_LineMaster.cs:383 | else of (action == CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1efee1df | DeleteButton | SCP0114_CAPA_LineMaster.cs:347 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": | DATA_OP | siLevel1.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-42b02458 | DeleteButton | SCP0114_CAPA_LineMaster.cs:348 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": | DATA_OP | siLevel2.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-84c266ee | DeleteButton | SCP0114_CAPA_LineMaster.cs:349 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": | DATA_OP | siLevel3.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cadc485c | DeleteButton | SCP0114_CAPA_LineMaster.cs:350 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel4": | DATA_OP | siLevel4.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4bdb47ed | DeleteButton | SCP0114_CAPA_LineMaster.cs:351 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": | DATA_OP | siLevel5.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0114_CAPA_LineMaster.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f0956a5 | Dispose | SCP0114_CAPA_LineMaster.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-95f16da8 | Dispose | SCP0114_CAPA_LineMaster.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0114_CAPA_LineMaster.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65ec3f98 | EditButton | SCP0114_CAPA_LineMaster.cs:484 | for (u < spreadLevel.Sheet().Rows.Count) ▸ if (EditCnt == CAppSetting.FlagI \|\| EditCnt == CAppSetting.FlagM) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b5a230bd | EditButton | SCP0114_CAPA_LineMaster.cs:501 | if (editCnt > 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-255360d8 | EditButton | SCP0114_CAPA_LineMaster.cs:512 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": | GRID_LOCK | siLevel1.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-cc8ee4f8 | EditButton | SCP0114_CAPA_LineMaster.cs:519 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": ▸ for (i < siLevel1.Sheet().Rows.Count) | GRID_LOCK | siLevel1.LockRange | (i, siLevel1.GetColumnIndex(DefColumns.DIVISION_ID), i, siLevel1.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8f4b699d | EditButton | SCP0114_CAPA_LineMaster.cs:522 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": ▸ for (i < siLevel1.Sheet().Rows.Count) ▸ if (ChkYn.Equals("N")) | GRID_LOCK | siLevel1.LockRange | (i, siLevel1.GetColumnIndex(DefColumns.SITE_ID), i, siLevel1.GetColumnIndex(DefColumns.SIT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d05e284f | EditButton | SCP0114_CAPA_LineMaster.cs:523 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": ▸ for (i < siLevel1.Sheet().Rows.Count) ▸ if (ChkYn.Equals("N")) | GRID_LOCK | siLevel1.LockRange | (i, siLevel1.GetColumnIndex(DefColumns.SITE_NAME), i, siLevel1.GetColumnIndex(DefColumns.S… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2688bde5 | EditButton | SCP0114_CAPA_LineMaster.cs:524 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": ▸ for (i < siLevel1.Sheet().Rows.Count) ▸ if (ChkYn.Equals("N")) | GRID_LOCK | siLevel1.LockRange | (i, siLevel1.GetColumnIndex(DefColumns.DUMMY_YN), i, siLevel1.GetColumnIndex(DefColumns.DU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-252502bd | EditButton | SCP0114_CAPA_LineMaster.cs:530 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": ▸ for (i < siLevel1.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel1.LockRange | (i, siLevel1.GetColumnIndex(DefColumns.SITE_ID), i, siLevel1.GetColumnIndex(DefColumns.SIT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6480eadb | EditButton | SCP0114_CAPA_LineMaster.cs:531 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": ▸ for (i < siLevel1.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel1.LockRange | (i, siLevel1.GetColumnIndex(DefColumns.SITE_NAME), i, siLevel1.GetColumnIndex(DefColumns.S… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5a350766 | EditButton | SCP0114_CAPA_LineMaster.cs:532 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": ▸ for (i < siLevel1.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel1.LockRange | (i, siLevel1.GetColumnIndex(DefColumns.DUMMY_YN), i, siLevel1.GetColumnIndex(DefColumns.DU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5ad2610e | EditButton | SCP0114_CAPA_LineMaster.cs:536 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": ▸ for (i < siLevel1.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel1.LockRange | (i, siLevel1.GetColumnIndex(DefColumns.SITE_ID), i, siLevel1.GetColumnIndex(DefColumns.SIT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2ee65826 | EditButton | SCP0114_CAPA_LineMaster.cs:537 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": ▸ for (i < siLevel1.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel1.LockRange | (i, siLevel1.GetColumnIndex(DefColumns.SITE_NAME), i, siLevel1.GetColumnIndex(DefColumns.S… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eb686617 | EditButton | SCP0114_CAPA_LineMaster.cs:538 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": ▸ for (i < siLevel1.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel1.LockRange | (i, siLevel1.GetColumnIndex(DefColumns.DUMMY_YN), i, siLevel1.GetColumnIndex(DefColumns.DU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c7b37cae | EditButton | SCP0114_CAPA_LineMaster.cs:544 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": | GRID_LOCK | siLevel2.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-b0f5be8e | EditButton | SCP0114_CAPA_LineMaster.cs:553 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": ▸ for (i < siLevel2.Sheet().Rows.Count) ▸ if (ChkYn.Equals("N")) | GRID_LOCK | siLevel2.LockRange | (i, siLevel2.GetColumnIndex(DefColumns.COMPANY_ID), i, siLevel2.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3708a45f | EditButton | SCP0114_CAPA_LineMaster.cs:559 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": ▸ for (i < siLevel2.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel2.LockRange | (i, siLevel2.GetColumnIndex(DefColumns.COMPANY_ID), i, siLevel2.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-94a9f0fe | EditButton | SCP0114_CAPA_LineMaster.cs:560 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": ▸ for (i < siLevel2.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel2.LockRange | (i, siLevel2.GetColumnIndex(DefColumns.COMPANY_NAME), i, siLevel2.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c291dc33 | EditButton | SCP0114_CAPA_LineMaster.cs:561 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": ▸ for (i < siLevel2.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel2.LockRange | (i, siLevel2.GetColumnIndex(DefColumns.DUMMY_YN), i, siLevel2.GetColumnIndex(DefColumns.DU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-390d1e71 | EditButton | SCP0114_CAPA_LineMaster.cs:565 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": ▸ for (i < siLevel2.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel2.LockRange | (i, siLevel2.GetColumnIndex(DefColumns.COMPANY_ID), i, siLevel2.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-192e666b | EditButton | SCP0114_CAPA_LineMaster.cs:566 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": ▸ for (i < siLevel2.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel2.LockRange | (i, siLevel2.GetColumnIndex(DefColumns.COMPANY_NAME), i, siLevel2.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d7d635ec | EditButton | SCP0114_CAPA_LineMaster.cs:567 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": ▸ for (i < siLevel2.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel2.LockRange | (i, siLevel2.GetColumnIndex(DefColumns.DUMMY_YN), i, siLevel2.GetColumnIndex(DefColumns.DU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9232b9d3 | EditButton | SCP0114_CAPA_LineMaster.cs:573 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": | GRID_LOCK | siLevel3.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-36cacdda | EditButton | SCP0114_CAPA_LineMaster.cs:582 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": ▸ for (i < siLevel3.Sheet().Rows.Count) ▸ if (ChkYn.Equals("N")) | GRID_LOCK | siLevel3.LockRange | (i, siLevel3.GetColumnIndex(DefColumns.PLANT_ID), i, siLevel3.GetColumnIndex(DefColumns.DU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3762c8d1 | EditButton | SCP0114_CAPA_LineMaster.cs:588 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": ▸ for (i < siLevel3.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel3.LockRange | (i, siLevel3.GetColumnIndex(DefColumns.PLANT_ID), i, siLevel3.GetColumnIndex(DefColumns.PL… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fc95e30b | EditButton | SCP0114_CAPA_LineMaster.cs:589 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": ▸ for (i < siLevel3.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel3.LockRange | (i, siLevel3.GetColumnIndex(DefColumns.PLANT_NAME), i, siLevel3.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0d466619 | EditButton | SCP0114_CAPA_LineMaster.cs:590 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": ▸ for (i < siLevel3.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel3.LockRange | (i, siLevel3.GetColumnIndex(DefColumns.DUMMY_YN), i, siLevel3.GetColumnIndex(DefColumns.DU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-85200de1 | EditButton | SCP0114_CAPA_LineMaster.cs:594 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": ▸ for (i < siLevel3.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel3.LockRange | (i, siLevel3.GetColumnIndex(DefColumns.PLANT_ID), i, siLevel3.GetColumnIndex(DefColumns.PL… | 그리드 편집 잠금/해제 |  |  |  |
| AC-11d0cea3 | EditButton | SCP0114_CAPA_LineMaster.cs:595 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": ▸ for (i < siLevel3.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel3.LockRange | (i, siLevel3.GetColumnIndex(DefColumns.PLANT_NAME), i, siLevel3.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-708ef205 | EditButton | SCP0114_CAPA_LineMaster.cs:596 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": ▸ for (i < siLevel3.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel3.LockRange | (i, siLevel3.GetColumnIndex(DefColumns.DUMMY_YN), i, siLevel3.GetColumnIndex(DefColumns.DU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eaa42e26 | EditButton | SCP0114_CAPA_LineMaster.cs:602 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel4": | GRID_LOCK | siLevel4.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-14c6dad0 | EditButton | SCP0114_CAPA_LineMaster.cs:611 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel4": ▸ for (i < siLevel4.Sheet().Rows.Count) ▸ if (ChkYn.Equals("N")) | GRID_LOCK | siLevel4.LockRange | (i, siLevel4.GetColumnIndex(DefColumns.FACTORY_ID), i, siLevel4.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-51d0503f | EditButton | SCP0114_CAPA_LineMaster.cs:617 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel4": ▸ for (i < siLevel4.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel4.LockRange | (i, siLevel4.GetColumnIndex(DefColumns.FACTORY_ID), i, siLevel4.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9d283894 | EditButton | SCP0114_CAPA_LineMaster.cs:618 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel4": ▸ for (i < siLevel4.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel4.LockRange | (i, siLevel4.GetColumnIndex(DefColumns.FACTORY_NAME), i, siLevel4.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5d213734 | EditButton | SCP0114_CAPA_LineMaster.cs:619 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel4": ▸ for (i < siLevel4.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel4.LockRange | (i, siLevel4.GetColumnIndex(DefColumns.DUMMY_YN), i, siLevel4.GetColumnIndex(DefColumns.DU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-50aa64a5 | EditButton | SCP0114_CAPA_LineMaster.cs:623 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel4": ▸ for (i < siLevel4.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel4.LockRange | (i, siLevel4.GetColumnIndex(DefColumns.LINE_ID), i, siLevel4.GetColumnIndex(DefColumns.FAC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b44b1ccf | EditButton | SCP0114_CAPA_LineMaster.cs:624 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel4": ▸ for (i < siLevel4.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel4.LockRange | (i, siLevel4.GetColumnIndex(DefColumns.LINE_NAME), i, siLevel4.GetColumnIndex(DefColumns.F… | 그리드 편집 잠금/해제 |  |  |  |
| AC-01e5745f | EditButton | SCP0114_CAPA_LineMaster.cs:625 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel4": ▸ for (i < siLevel4.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel4.LockRange | (i, siLevel4.GetColumnIndex(DefColumns.DUMMY_YN), i, siLevel4.GetColumnIndex(DefColumns.DU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8f95f0fa | EditButton | SCP0114_CAPA_LineMaster.cs:631 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": | GRID_LOCK | siLevel5.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-b30af65d | EditButton | SCP0114_CAPA_LineMaster.cs:642 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": ▸ for (i < siLevel5.Sheet().Rows.Count) ▸ if (ChkYn.Equals("N")) | GRID_LOCK | siLevel5.LockRange | (i, siLevel5.GetColumnIndex(DefColumns.LINE_ID), i, siLevel5.GetColumnIndex(DefColumns.VAL… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1e07c9ab | EditButton | SCP0114_CAPA_LineMaster.cs:648 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": ▸ for (i < siLevel5.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel5.LockRange | (i, siLevel5.GetColumnIndex(DefColumns.LINE_ID), i, siLevel5.GetColumnIndex(DefColumns.LIN… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fdf3ee95 | EditButton | SCP0114_CAPA_LineMaster.cs:649 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": ▸ for (i < siLevel5.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel5.LockRange | (i, siLevel5.GetColumnIndex(DefColumns.LINE_NAME), i, siLevel5.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e7adbfc7 | EditButton | SCP0114_CAPA_LineMaster.cs:650 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": ▸ for (i < siLevel5.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel5.LockRange | (i, siLevel5.GetColumnIndex(DefColumns.SHOP_GROUP_ID), i, siLevel5.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ac09d86a | EditButton | SCP0114_CAPA_LineMaster.cs:651 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": ▸ for (i < siLevel5.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel5.LockRange | (i, siLevel5.GetColumnIndex(DefColumns.DUMMY_YN), i, siLevel5.GetColumnIndex(DefColumns.DU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3133dc67 | EditButton | SCP0114_CAPA_LineMaster.cs:652 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": ▸ for (i < siLevel5.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ if (this… | GRID_LOCK | siLevel5.LockRange | (i, siLevel5.GetColumnIndex(DefColumns.VALID_YN), i, siLevel5.GetColumnIndex(DefColumns.VA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-588381c9 | EditButton | SCP0114_CAPA_LineMaster.cs:656 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": ▸ for (i < siLevel5.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel5.LockRange | (i, siLevel5.GetColumnIndex(DefColumns.LINE_ID), i, siLevel5.GetColumnIndex(DefColumns.LIN… | 그리드 편집 잠금/해제 |  |  |  |
| AC-94f703f9 | EditButton | SCP0114_CAPA_LineMaster.cs:657 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": ▸ for (i < siLevel5.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel5.LockRange | (i, siLevel5.GetColumnIndex(DefColumns.LINE_NAME), i, siLevel5.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2efda421 | EditButton | SCP0114_CAPA_LineMaster.cs:658 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": ▸ for (i < siLevel5.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel5.LockRange | (i, siLevel5.GetColumnIndex(DefColumns.SHOP_GROUP_ID), i, siLevel5.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8da9bccb | EditButton | SCP0114_CAPA_LineMaster.cs:659 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": ▸ for (i < siLevel5.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel5.LockRange | (i, siLevel5.GetColumnIndex(DefColumns.DUMMY_YN), i, siLevel5.GetColumnIndex(DefColumns.DU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-deb3f931 | EditButton | SCP0114_CAPA_LineMaster.cs:660 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": ▸ for (i < siLevel5.Sheet().Rows.Count) ▸ else of (ChkYn.Equals("N")) ▸ else of … | GRID_LOCK | siLevel5.LockRange | (i, siLevel5.GetColumnIndex(DefColumns.VALID_YN), i, siLevel5.GetColumnIndex(DefColumns.VA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ebe11134 | EditButton | SCP0114_CAPA_LineMaster.cs:363 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": | GRID_LOCK | siLevel1.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-f1062182 | EditButton | SCP0114_CAPA_LineMaster.cs:364 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": | GRID_LOCK | siLevel1.LockColumn | (0, siLevel1.GetColumnIndex(DefColumns.DIVISION_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8a060ff1 | EditButton | SCP0114_CAPA_LineMaster.cs:367 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": | GRID_LOCK | siLevel2.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-94cbf2c8 | EditButton | SCP0114_CAPA_LineMaster.cs:368 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": | GRID_LOCK | siLevel2.LockColumn | (0, siLevel2.GetColumnIndex(DefColumns.SITE_NAME), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d10cef3b | EditButton | SCP0114_CAPA_LineMaster.cs:371 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": | GRID_LOCK | siLevel3.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-d8eb380d | EditButton | SCP0114_CAPA_LineMaster.cs:372 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": | GRID_LOCK | siLevel3.LockColumn | (0, siLevel3.GetColumnIndex(DefColumns.COMPANY_NAME), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c4e5c697 | EditButton | SCP0114_CAPA_LineMaster.cs:375 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel4": | GRID_LOCK | siLevel4.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-48748f4f | EditButton | SCP0114_CAPA_LineMaster.cs:376 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel4": | GRID_LOCK | siLevel4.LockColumn | (0, siLevel4.GetColumnIndex(DefColumns.PLANT_NAME), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d78e148d | EditButton | SCP0114_CAPA_LineMaster.cs:379 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": | GRID_LOCK | siLevel5.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-4d664890 | EditButton | SCP0114_CAPA_LineMaster.cs:380 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": | GRID_LOCK | siLevel5.LockColumn | (0, siLevel5.GetColumnIndex(DefColumns.FACTORY_NAME), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0114_CAPA_LineMaster.EditModesCheck

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6bff5c1 | EditButton | SCP0114_CAPA_LineMaster.cs:411 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": ▸ if (this.IsEditModes[DIC_CAPA_LINE_SITE] == true) | DATA_OP | this.IsEditModes[DIC_CAPA_LINE_SITE] | false | 행/컬럼 값 대입 |  |  |  |
| AC-bed7ed18 | EditButton | SCP0114_CAPA_LineMaster.cs:415 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel1": ▸ else of (this.IsEditModes[DIC_CAPA_LINE_SITE] == true) | DATA_OP | this.IsEditModes[DIC_CAPA_LINE_SITE] | true | 행/컬럼 값 대입 |  |  |  |
| AC-a38aa0cb | EditButton | SCP0114_CAPA_LineMaster.cs:421 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": ▸ if (this.IsEditModes[DIC_CAPA_LINE_COMPANY] == true) | DATA_OP | this.IsEditModes[DIC_CAPA_LINE_COMPANY] | false | 행/컬럼 값 대입 |  |  |  |
| AC-828ad971 | EditButton | SCP0114_CAPA_LineMaster.cs:425 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": ▸ else of (this.IsEditModes[DIC_CAPA_LINE_COMPANY] == true) | DATA_OP | this.IsEditModes[DIC_CAPA_LINE_COMPANY] | true | 행/컬럼 값 대입 |  |  |  |
| AC-ba9d0890 | EditButton | SCP0114_CAPA_LineMaster.cs:431 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": ▸ if (this.IsEditModes[DIC_CAPA_LINE_PLANT] == true) | DATA_OP | this.IsEditModes[DIC_CAPA_LINE_PLANT] | false | 행/컬럼 값 대입 |  |  |  |
| AC-ffedd28b | EditButton | SCP0114_CAPA_LineMaster.cs:435 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": ▸ else of (this.IsEditModes[DIC_CAPA_LINE_PLANT] == true) | DATA_OP | this.IsEditModes[DIC_CAPA_LINE_PLANT] | true | 행/컬럼 값 대입 |  |  |  |
| AC-74ea57fc | EditButton | SCP0114_CAPA_LineMaster.cs:441 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel4": ▸ if (this.IsEditModes[DIC_CAPA_LINE_FACTORY] == true) | DATA_OP | this.IsEditModes[DIC_CAPA_LINE_FACTORY] | false | 행/컬럼 값 대입 |  |  |  |
| AC-1610a1ad | EditButton | SCP0114_CAPA_LineMaster.cs:445 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel4": ▸ else of (this.IsEditModes[DIC_CAPA_LINE_FACTORY] == true) | DATA_OP | this.IsEditModes[DIC_CAPA_LINE_FACTORY] | true | 행/컬럼 값 대입 |  |  |  |
| AC-f8d8d1a4 | EditButton | SCP0114_CAPA_LineMaster.cs:451 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": ▸ if (this.IsEditModes[DIC_CAPA_LINE] == true) | DATA_OP | this.IsEditModes[DIC_CAPA_LINE] | false | 행/컬럼 값 대입 |  |  |  |
| AC-8d65138a | EditButton | SCP0114_CAPA_LineMaster.cs:455 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": ▸ else of (this.IsEditModes[DIC_CAPA_LINE] == true) | DATA_OP | this.IsEditModes[DIC_CAPA_LINE] | true | 행/컬럼 값 대입 |  |  |  |

## SCP0114_CAPA_LineMaster.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de85b0d2 | FindButton | SCP0114_CAPA_LineMaster.cs:348 |  | FLAG | divisionID | CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-2e85243a | FindButton | SCP0114_CAPA_LineMaster.cs:331 |  | FLAG | divisionID | CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |

## SCP0114_CAPA_LineMaster.FindData

진입점: this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / this.spdLevel2.CellDoubleClick [if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / this.spdLevel3.CellDoubleClick [if (!siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / this.spdLevel4.CellDoubleClick [if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / this.cboDivision.SelectedIndexChanged [if (siLevel1 != null)] / this.rgrpSearchLevel.SelectedIndexChanged / FindButton / SaveButton [if (_si != null && _si.IsLock(_si.SheetName) ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b489d786 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:725 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-385eb0f5 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:729 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0114_GET_CAPA_LINE_MASTER") ⇒ SCP.SCP0114_GET_CAPA_LINE_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-24f7113a | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:730 | lambda | DATA_OP | request.Parameters["p_menu_level"] | level | 행/컬럼 값 대입 |  |  |  |
| AC-721c378d | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:731 | lambda | DATA_OP | request.Parameters["p_division_id"] | divisionID | 행/컬럼 값 대입 |  |  |  |
| AC-c09eda61 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:732 | lambda | DATA_OP | request.Parameters["p_site_id"] | level1ID | 행/컬럼 값 대입 |  |  |  |
| AC-0be4115d | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:733 | lambda | DATA_OP | request.Parameters["p_company_id"] | level2ID == null ? "" : level2ID | 행/컬럼 값 대입 |  |  |  |
| AC-7b94718d | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:734 | lambda | DATA_OP | request.Parameters["p_plant_id"] | level3ID == null ? "" : level3ID | 행/컬럼 값 대입 |  |  |  |
| AC-0bc4440c | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:735 | lambda | DATA_OP | request.Parameters["p_factory_id"] | level4ID == null ? "" : level4ID | 행/컬럼 값 대입 |  |  |  |
| AC-e369df90 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:736 | lambda | DATA_OP | request.Parameters["p_line_id"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-3a50d0fe | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:737 | lambda | DATA_OP | request.Parameters["p_shop_group_id"] | _shopgroupId | 행/컬럼 값 대입 |  |  |  |
| AC-ac61301b | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:741 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bfa97157 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:743 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6143af1a | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:747 |  | GRID_BIND | spreadLevel.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c4cc76a2 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:748 |  | GRID_LOCK | spreadLevel.LockColumn | (0, spreadLevel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cd42c93e | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:751 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6240b9ad | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:754 |  | GRID_INIT | spreadLevel.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-42aff289 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:759 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-3ce0158f | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:759 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-213c4885 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:760 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fcbf884 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:438 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d12a2bde | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:442 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0114_GET_CAPA_LINE_MASTER") ⇒ SCP.SCP0114_GET_CAPA_LINE_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-66d5fadf | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:443 | lambda | DATA_OP | request.Parameters["MenuLevel"] | level | 행/컬럼 값 대입 |  |  |  |
| AC-c47dcfda | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:444 | lambda | DATA_OP | request.Parameters["DivisionID"] | divisionID | 행/컬럼 값 대입 |  |  |  |
| AC-7c93db94 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:445 | lambda | DATA_OP | request.Parameters["SiteID"] | level1ID | 행/컬럼 값 대입 |  |  |  |
| AC-56b18432 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:446 | lambda | DATA_OP | request.Parameters["CompanyID"] | level2ID == null ? "" : level2ID | 행/컬럼 값 대입 |  |  |  |
| AC-788f4aed | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:447 | lambda | DATA_OP | request.Parameters["PlantID"] | level3ID == null ? "" : level3ID | 행/컬럼 값 대입 |  |  |  |
| AC-35f456cf | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:448 | lambda | DATA_OP | request.Parameters["FactoryID"] | level4ID == null ? "" : level4ID | 행/컬럼 값 대입 |  |  |  |
| AC-2ab451ed | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:449 | lambda | DATA_OP | request.Parameters["LineID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-931bc76d | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:453 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4ee65915 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:455 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0b0d7f2d | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:467 |  | GRID_BIND | spreadLevel.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5c7aee58 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:468 |  | GRID_LOCK | spreadLevel.LockColumn | (0, spreadLevel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-25c60d33 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:471 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d317f2c5 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:474 |  | GRID_INIT | spreadLevel.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2df51596 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:479 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-5e5dc087 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:479 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-abaa4545 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:480 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## SCP0114_CAPA_LineMaster.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff212dcf | this.Load | SCP0114_CAPA_LineMaster.cs:174 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3f080a11 | this.Load | SCP0114_CAPA_LineMaster.cs:179 |  | FLAG | _shopgroupId | "E" | 화면 필드/플래그 변경 |  |  |  |
| AC-b31114e5 | this.Load | SCP0114_CAPA_LineMaster.cs:164 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0114_CAPA_LineMaster.getCurrDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7af27e94 | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:1547 | try | CALL_EXT | curr_row.Columns | (DefColumns.DIVISION_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c16773bf | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:1553 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0114_CAPA_LineMaster.IconFileDialog

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7970cb3a | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:800 |  | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-97f427a4 | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:801 |  | UI_PROP | openDialog.AutoUpgradeEnabled | false | 속성 AutoUpgradeEnabled 설정 |  |  |  |
| AC-5729105b | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:803 |  | UI_PROP | openDialog.Filter | "Icon File\|*.ico" | 속성 Filter 설정 |  |  |  |
| AC-c3fbee26 | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:805 |  | POPUP | openDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-82d970c8 | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:810 |  | RETURN | return filePath; |  | 처리 중단/반환 |  |  |  |

## SCP0114_CAPA_LineMaster.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50c76dd0 | this.Load | SCP0114_CAPA_LineMaster.cs:190 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6c48242d | this.Load | SCP0114_CAPA_LineMaster.cs:191 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-df6db829 | this.Load | SCP0114_CAPA_LineMaster.cs:178 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d00444d1 | this.Load | SCP0114_CAPA_LineMaster.cs:179 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0114_CAPA_LineMaster.InitEditModes

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7dcbdf49 | this.Load | SCP0114_CAPA_LineMaster.cs:1716 |  | DATA_OP | this.IsEditModes.Add | (DIC_CAPA_LINE_SITE, false) | 데이터 객체 조작/조회 |  |  |  |
| AC-32e05d1b | this.Load | SCP0114_CAPA_LineMaster.cs:1717 |  | DATA_OP | this.IsEditModes.Add | (DIC_CAPA_LINE_COMPANY, false) | 데이터 객체 조작/조회 |  |  |  |
| AC-6496f804 | this.Load | SCP0114_CAPA_LineMaster.cs:1718 |  | DATA_OP | this.IsEditModes.Add | (DIC_CAPA_LINE_PLANT, false) | 데이터 객체 조작/조회 |  |  |  |
| AC-e97e1ee8 | this.Load | SCP0114_CAPA_LineMaster.cs:1719 |  | DATA_OP | this.IsEditModes.Add | (DIC_CAPA_LINE_FACTORY, false) | 데이터 객체 조작/조회 |  |  |  |
| AC-77d644c6 | this.Load | SCP0114_CAPA_LineMaster.cs:1720 |  | DATA_OP | this.IsEditModes.Add | (DIC_CAPA_LINE, false) | 데이터 객체 조작/조회 |  |  |  |

## SCP0114_CAPA_LineMaster.InitSpread

진입점: this.Load / this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (level) case 1:] / this.spdLevel2.CellDoubleClick [if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (level) case 1:] / this.spdLevel3.CellDoubleClick [if (!siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (level) case 1:] / this.spdLevel4.CellDoubleClick [if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (level) case 1:] / this.cboDivision.SelectedIndexChanged [if (siLevel1 != null) ▸ switc…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40413c29 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:240 | if (level == 1) | GRID_INIT | siLevel1.InitSheet | (siLevel1.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-427da879 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:242 | if (level == 1) | GRID_INIT | siLevel1.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b63e89d0 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:244 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("Div*", DefColumns.DIVISION_ID, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66350379 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:245 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("Site*", DefColumns.SITE_ID, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dbe94d53 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:246 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("Site Name", DefColumns.SITE_NAME, FPMerge.None, 110, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8e0d4638 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:247 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("Dummy", DefColumns.DUMMY_YN, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c700820 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:248 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("SortOrder", DefColumns.SORT_ORDER, FPMerge.None, 10, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-010ed96a | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:249 | if (level == 1) | GRID_INIT | siLevel1.Freeze | (0, siLevel1.GetColumnIndex(DefColumns.DIVISION_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0cbef8ee | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:251 | if (level == 1) | GRID_INIT | siLevel1.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3167e87b | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:257 | if (level == 2) | GRID_INIT | siLevel2.InitSheet | (siLevel2.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b049844b | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:259 | if (level == 2) | GRID_INIT | siLevel2.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-53b47e71 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:261 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Div*", DefColumns.DIVISION_ID, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-87d18027 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:262 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Site*", DefColumns.SITE_ID, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9cb40170 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:263 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Site Name", DefColumns.SITE_NAME, FPMerge.None, 110, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6636e94c | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:264 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Company*", DefColumns.COMPANY_ID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f6f8e658 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:265 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Company Name", DefColumns.COMPANY_NAME, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-07eb7bb8 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:266 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Dummy", DefColumns.DUMMY_YN, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c8bd5f3d | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:267 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("SortOrder", DefColumns.SORT_ORDER, FPMerge.None, 10, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9dc576f3 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:268 | if (level == 2) | GRID_INIT | siLevel2.Freeze | (0, siLevel2.GetColumnIndex(DefColumns.SITE_NAME) ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-348cf892 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:270 | if (level == 2) | GRID_INIT | siLevel2.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d51e6e4a | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:276 | if (level == 3) | GRID_INIT | siLevel3.InitSheet | (siLevel3.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-582977dd | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:278 | if (level == 3) | GRID_INIT | siLevel3.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d10b1d93 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:279 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Div*", DefColumns.DIVISION_ID, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d9735a4e | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:280 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Site*", DefColumns.SITE_ID, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9808ea2 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:281 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Site Name", DefColumns.SITE_NAME, FPMerge.None, 110, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d882573 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:282 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Company*", DefColumns.COMPANY_ID, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-589693e1 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:283 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Company Name", DefColumns.COMPANY_NAME, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb2cc401 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:284 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Plant*", DefColumns.PLANT_ID, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-57bef30b | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:285 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Plant Name", DefColumns.PLANT_NAME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2aea7cbd | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:286 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Dummy", DefColumns.DUMMY_YN, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d2a1cc20 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:287 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("SortOrder", DefColumns.SORT_ORDER, FPMerge.None, 10, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da49355d | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:288 | if (level == 3) | GRID_INIT | siLevel3.Freeze | (0, siLevel3.GetColumnIndex(DefColumns.COMPANY_NAME)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9ea718b1 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:290 | if (level == 3) | GRID_INIT | siLevel3.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-34044a1c | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:296 | if (level == 4) | GRID_INIT | siLevel4.InitSheet | (siLevel4.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-9f7a1c2c | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:298 | if (level == 4) | GRID_INIT | siLevel4.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-eb0a1bc3 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:299 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Div*", DefColumns.DIVISION_ID, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a21aa031 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:300 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Site*", DefColumns.SITE_ID, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8bebb4fb | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:301 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Site Name", DefColumns.SITE_NAME, FPMerge.None, 110, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2b64ad8c | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:302 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Company*", DefColumns.COMPANY_ID, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3c0830d2 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:303 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Company Name", DefColumns.COMPANY_NAME, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-09055604 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:304 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Plant*", DefColumns.PLANT_ID, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-819dd14a | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:305 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Plant Name", DefColumns.PLANT_NAME, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d8d58ff | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:306 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Building*", DefColumns.FACTORY_ID, FPMerge.None, 130, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-446fed80 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:307 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Building Name", DefColumns.FACTORY_NAME, FPMerge.None, 170, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3a315b67 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:308 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Dummy", DefColumns.DUMMY_YN, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a29f738f | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:309 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("SortOrder", DefColumns.SORT_ORDER, FPMerge.None, 10, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0a6bd33f | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:310 | if (level == 4) | GRID_INIT | siLevel4.Freeze | (0, siLevel4.GetColumnIndex(DefColumns.PLANT_NAME)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e5fba59a | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:312 | if (level == 4) | GRID_INIT | siLevel4.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8224d58f | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:318 | if (level == 5) | GRID_INIT | siLevel5.InitSheet | (siLevel5.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-ee492b5a | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:320 | if (level == 5) | GRID_INIT | siLevel5.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f9d7b330 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:321 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Div*", DefColumns.DIVISION_ID, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f57e96b | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:322 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Site*", DefColumns.SITE_ID, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5c0de0ad | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:323 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Site Name", DefColumns.SITE_NAME, FPMerge.None, 110, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2563eed7 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:324 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Company*", DefColumns.COMPANY_ID, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e10f41b2 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:325 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Company Name", DefColumns.COMPANY_NAME, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71e5823d | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:326 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Plant*", DefColumns.PLANT_ID, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e06f6981 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:327 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Plant Name", DefColumns.PLANT_NAME, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9878211 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:328 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Building*", DefColumns.FACTORY_ID, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4cf47247 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:329 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Building Name", DefColumns.FACTORY_NAME, FPMerge.None, 150, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a5756fd | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:330 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Line*", DefColumns.LINE_ID, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0bbefde2 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:331 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Line Name", DefColumns.LINE_NAME, FPMerge.None, 180, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-efb515f9 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:332 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Operation Group", DefColumns.SHOP_GROUP_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a8b36c07 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:333 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Dummy", DefColumns.DUMMY_YN, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-40d88940 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:334 | if (level == 5) | GRID_INIT | siLevel5.AddComboColumn | ("Valid Y/N*", DefColumns.VALID_YN, FPMerge.None, 100, true, dtYesOrNo, FPHAlign.Center, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d44cf856 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:335 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("SortOrder", DefColumns.SORT_ORDER, FPMerge.None, 10, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9082c8e5 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:336 | if (level == 5) | GRID_INIT | siLevel5.Freeze | (0, siLevel5.GetColumnIndex(DefColumns.FACTORY_NAME)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2f33e7ad | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:338 | if (level == 5) | GRID_INIT | siLevel5.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b078c0bf | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:225 | if (level == 1) | GRID_INIT | siLevel1.InitSheet | (siLevel1.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-a219428c | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:227 | if (level == 1) | GRID_INIT | siLevel1.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3c3eae51 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:229 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("Div*", DefColumns.DIVISION_ID, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7aae4259 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:230 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("Site*", DefColumns.SITE_ID, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fb4861d6 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:231 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("Site Name", DefColumns.SITE_NAME, FPMerge.None, 110, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-83a569d6 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:232 | if (level == 1) | GRID_INIT | siLevel1.AddComboColumn | ("UseYN*", DefColumns.VALID_YN, FPMerge.None, 60, true, dtYesOrNo, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-effb853d | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:233 | if (level == 1) | GRID_INIT | siLevel1.AddTextColumn | ("SortOrder", DefColumns.SORT_ORDER, FPMerge.None, 10, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5b869f4e | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:234 | if (level == 1) | GRID_INIT | siLevel1.Freeze | (0, siLevel1.GetColumnIndex(DefColumns.DIVISION_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0f8108ba | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:236 | if (level == 1) | GRID_INIT | siLevel1.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a1917248 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:242 | if (level == 2) | GRID_INIT | siLevel2.InitSheet | (siLevel2.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-3890f0a9 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:244 | if (level == 2) | GRID_INIT | siLevel2.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3550f460 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:246 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Div*", DefColumns.DIVISION_ID, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bea55eae | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:247 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Site*", DefColumns.SITE_ID, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-23b075c3 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:248 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Site Name", DefColumns.SITE_NAME, FPMerge.None, 110, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4acf183e | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:249 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Company*", DefColumns.COMPANY_ID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-81721fed | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:250 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("Company Name", DefColumns.COMPANY_NAME, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e935570d | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:251 | if (level == 2) | GRID_INIT | siLevel2.AddComboColumn | ("UseYN*", DefColumns.VALID_YN, FPMerge.None, 60, true, dtYesOrNo, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-176eeff9 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:252 | if (level == 2) | GRID_INIT | siLevel2.AddTextColumn | ("SortOrder", DefColumns.SORT_ORDER, FPMerge.None, 10, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4214ccd7 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:253 | if (level == 2) | GRID_INIT | siLevel2.Freeze | (0, siLevel2.GetColumnIndex(DefColumns.SITE_NAME) ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5853d7d9 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:255 | if (level == 2) | GRID_INIT | siLevel2.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c33e56de | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:261 | if (level == 3) | GRID_INIT | siLevel3.InitSheet | (siLevel3.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-741f61a9 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:263 | if (level == 3) | GRID_INIT | siLevel3.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c0f67799 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:264 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Div*", DefColumns.DIVISION_ID, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1387f192 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:265 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Site*", DefColumns.SITE_ID, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8dbac1c1 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:266 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Site Name", DefColumns.SITE_NAME, FPMerge.None, 110, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4c9780f0 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:267 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Company*", DefColumns.COMPANY_ID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-773605c6 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:268 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Company Name", DefColumns.COMPANY_NAME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9bba2eb1 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:269 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Plant*", DefColumns.PLANT_ID, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-628478e6 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:270 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("Plant Name", DefColumns.PLANT_NAME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6f9c1649 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:271 | if (level == 3) | GRID_INIT | siLevel3.AddComboColumn | ("UseYN*", DefColumns.VALID_YN, FPMerge.None, 60, true, dtYesOrNo, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-39fc67dc | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:272 | if (level == 3) | GRID_INIT | siLevel3.AddTextColumn | ("SortOrder", DefColumns.SORT_ORDER, FPMerge.None, 10, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c11c861 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:273 | if (level == 3) | GRID_INIT | siLevel3.Freeze | (0, siLevel3.GetColumnIndex(DefColumns.COMPANY_NAME)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a63c5555 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:275 | if (level == 3) | GRID_INIT | siLevel3.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cab07a56 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:281 | if (level == 4) | GRID_INIT | siLevel4.InitSheet | (siLevel4.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-73da0e62 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:283 | if (level == 4) | GRID_INIT | siLevel4.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e8574742 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:284 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Div*", DefColumns.DIVISION_ID, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-45c921a4 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:285 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Site*", DefColumns.SITE_ID, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3933b94e | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:286 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Site Name", DefColumns.SITE_NAME, FPMerge.None, 110, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-015a27e4 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:287 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Company*", DefColumns.COMPANY_ID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d2e89ba | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:288 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Company Name", DefColumns.COMPANY_NAME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c892bd73 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:289 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Plant*", DefColumns.PLANT_ID, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5f98eabd | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:290 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Plant Name", DefColumns.PLANT_NAME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9cb525e1 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:291 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Building*", DefColumns.FACTORY_ID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-db52c232 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:292 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("Building Name", DefColumns.FACTORY_NAME, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a63dc8e | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:293 | if (level == 4) | GRID_INIT | siLevel4.AddComboColumn | ("UseYN*", DefColumns.VALID_YN, FPMerge.None, 60, true, dtYesOrNo, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d90e7245 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:294 | if (level == 4) | GRID_INIT | siLevel4.AddTextColumn | ("SortOrder", DefColumns.SORT_ORDER, FPMerge.None, 10, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-78757f0a | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:295 | if (level == 4) | GRID_INIT | siLevel4.Freeze | (0, siLevel4.GetColumnIndex(DefColumns.PLANT_NAME)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-604458b0 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:297 | if (level == 4) | GRID_INIT | siLevel4.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-51f9f2ff | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:303 | if (level == 5) | GRID_INIT | siLevel5.InitSheet | (siLevel5.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8e85b868 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:305 | if (level == 5) | GRID_INIT | siLevel5.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5f7919de | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:306 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Div*", DefColumns.DIVISION_ID, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-efc84d3d | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:307 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Site*", DefColumns.SITE_ID, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-138b3f34 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:308 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Site Name", DefColumns.SITE_NAME, FPMerge.None, 110, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b78b36e9 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:309 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Company*", DefColumns.COMPANY_ID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b0d55b1 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:310 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Company Name", DefColumns.COMPANY_NAME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-293ffd9c | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:311 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Plant*", DefColumns.PLANT_ID, FPMerge.None, 60, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a2bcb303 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:312 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Plant Name", DefColumns.PLANT_NAME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-396d5ff4 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:313 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Building*", DefColumns.FACTORY_ID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb772447 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:314 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Building Name", DefColumns.FACTORY_NAME, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b89dd2d7 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:315 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Line*", DefColumns.LINE_ID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bbdea1aa | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:316 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("Line Name", DefColumns.LINE_NAME, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b2df639 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:317 | if (level == 5) | GRID_INIT | siLevel5.AddComboColumn | ("UseYN*", DefColumns.VALID_YN, FPMerge.None, 60, true, dtYesOrNo, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ee2e1ffd | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:318 | if (level == 5) | GRID_INIT | siLevel5.AddTextColumn | ("SortOrder", DefColumns.SORT_ORDER, FPMerge.None, 10, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5f6b6483 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:319 | if (level == 5) | GRID_INIT | siLevel5.Freeze | (0, siLevel5.GetColumnIndex(DefColumns.FACTORY_NAME)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-87651ba3 | this.Load 외 8 | SCP0114_CAPA_LineMaster.cs:321 | if (level == 5) | GRID_INIT | siLevel5.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0114_CAPA_LineMaster.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc63b15d | InsertButton | SCP0114_CAPA_LineMaster.cs:1214 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | spreadLevel.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b34ce957 | InsertButton | SCP0114_CAPA_LineMaster.cs:1219 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ if (fps.Name == "spdLevel1") | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, divisionID) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfbe9fd6 | InsertButton | SCP0114_CAPA_LineMaster.cs:1223 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ if (fps.Name == "spdLev… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, divisionID) | 데이터 객체 조작/조회 |  |  |  |
| AC-3302e237 | InsertButton | SCP0114_CAPA_LineMaster.cs:1224 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ if (fps.Name == "spdLev… | DATA_OP | defaultData.Add | (DefColumns.SITE_ID, _siteId) | 데이터 객체 조작/조회 |  |  |  |
| AC-adda0157 | InsertButton | SCP0114_CAPA_LineMaster.cs:1225 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ if (fps.Name == "spdLev… | DATA_OP | defaultData.Add | (DefColumns.SITE_NAME, _siteName) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a5df3cd | InsertButton | SCP0114_CAPA_LineMaster.cs:1229 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, divisionID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a80bd352 | InsertButton | SCP0114_CAPA_LineMaster.cs:1230 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.SITE_ID, _siteId) | 데이터 객체 조작/조회 |  |  |  |
| AC-3752b228 | InsertButton | SCP0114_CAPA_LineMaster.cs:1231 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.SITE_NAME, _siteName) | 데이터 객체 조작/조회 |  |  |  |
| AC-48a25f2b | InsertButton | SCP0114_CAPA_LineMaster.cs:1232 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.COMPANY_ID, _companyId) | 데이터 객체 조작/조회 |  |  |  |
| AC-00ae333b | InsertButton | SCP0114_CAPA_LineMaster.cs:1233 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.COMPANY_NAME, _companyName) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a11a7a5 | InsertButton | SCP0114_CAPA_LineMaster.cs:1237 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, divisionID) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a1d544a | InsertButton | SCP0114_CAPA_LineMaster.cs:1238 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.SITE_ID, _siteId) | 데이터 객체 조작/조회 |  |  |  |
| AC-8329eb2e | InsertButton | SCP0114_CAPA_LineMaster.cs:1239 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.SITE_NAME, _siteName) | 데이터 객체 조작/조회 |  |  |  |
| AC-44fa15de | InsertButton | SCP0114_CAPA_LineMaster.cs:1240 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.COMPANY_ID, _companyId) | 데이터 객체 조작/조회 |  |  |  |
| AC-dde6d12f | InsertButton | SCP0114_CAPA_LineMaster.cs:1241 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.COMPANY_NAME, _companyName) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1e54b2f | InsertButton | SCP0114_CAPA_LineMaster.cs:1242 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.PLANT_ID, _plantId) | 데이터 객체 조작/조회 |  |  |  |
| AC-84ab5aca | InsertButton | SCP0114_CAPA_LineMaster.cs:1243 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.PLANT_NAME, _plantName) | 데이터 객체 조작/조회 |  |  |  |
| AC-e10d3387 | InsertButton | SCP0114_CAPA_LineMaster.cs:1247 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, divisionID) | 데이터 객체 조작/조회 |  |  |  |
| AC-3eb8dc1f | InsertButton | SCP0114_CAPA_LineMaster.cs:1248 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.SITE_ID, _siteId) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8bc0f7c | InsertButton | SCP0114_CAPA_LineMaster.cs:1249 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.SITE_NAME, _siteName) | 데이터 객체 조작/조회 |  |  |  |
| AC-005d4c70 | InsertButton | SCP0114_CAPA_LineMaster.cs:1250 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.COMPANY_ID, _companyId) | 데이터 객체 조작/조회 |  |  |  |
| AC-61c6a891 | InsertButton | SCP0114_CAPA_LineMaster.cs:1251 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.COMPANY_NAME, _companyName) | 데이터 객체 조작/조회 |  |  |  |
| AC-58d5f4ea | InsertButton | SCP0114_CAPA_LineMaster.cs:1252 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.PLANT_ID, _plantId) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4927785 | InsertButton | SCP0114_CAPA_LineMaster.cs:1253 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.PLANT_NAME, _plantName) | 데이터 객체 조작/조회 |  |  |  |
| AC-b43a1752 | InsertButton | SCP0114_CAPA_LineMaster.cs:1254 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.FACTORY_ID, _factoryId) | 데이터 객체 조작/조회 |  |  |  |
| AC-733db83f | InsertButton | SCP0114_CAPA_LineMaster.cs:1255 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.FACTORY_NAME, _factoryName) | 데이터 객체 조작/조회 |  |  |  |
| AC-7fef103c | InsertButton | SCP0114_CAPA_LineMaster.cs:1256 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.SHOP_GROUP_ID, _shopgroupId) | 데이터 객체 조작/조회 |  |  |  |
| AC-a60eae33 | InsertButton | SCP0114_CAPA_LineMaster.cs:1259 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.SORT_ORDER, sortOrder) | 데이터 객체 조작/조회 |  |  |  |
| AC-32d615ce | InsertButton | SCP0114_CAPA_LineMaster.cs:1260 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-0590fb18 | InsertButton | SCP0114_CAPA_LineMaster.cs:1261 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.DUMMY_YN, 'Y') | 데이터 객체 조작/조회 |  |  |  |
| AC-254e1944 | InsertButton | SCP0114_CAPA_LineMaster.cs:1262 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | GRID_SET | spreadLevel.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-22fc41b7 | InsertButton | SCP0114_CAPA_LineMaster.cs:1267 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ if (fps.Name == "spdLevel1") | GRID_LOCK | spreadLevel.LockRange | (insCell, spreadLevel.GetColumnIndex(DefColumns.DIVISION_ID), spreadLevel.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c20bb988 | InsertButton | SCP0114_CAPA_LineMaster.cs:1268 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ if (fps.Name == "spdLevel1") | GRID_LOCK | spreadLevel.LockRange | (insCell, spreadLevel.GetColumnIndex(DefColumns.DUMMY_YN), spreadLevel.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c9e7e571 | InsertButton | SCP0114_CAPA_LineMaster.cs:1269 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ if (fps.Name == "spdLevel1") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6b5d45d | InsertButton | SCP0114_CAPA_LineMaster.cs:1273 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ if (fps.Name == "spdLev… | GRID_LOCK | spreadLevel.LockRange | (insCell, spreadLevel.GetColumnIndex(DefColumns.DUMMY_YN), spreadLevel.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1750f7f7 | InsertButton | SCP0114_CAPA_LineMaster.cs:1274 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ if (fps.Name == "spdLev… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-03defff7 | InsertButton | SCP0114_CAPA_LineMaster.cs:1278 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | GRID_LOCK | spreadLevel.LockRange | (insCell, spreadLevel.GetColumnIndex(DefColumns.DUMMY_YN), spreadLevel.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d274527b | InsertButton | SCP0114_CAPA_LineMaster.cs:1279 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-19bcdf06 | InsertButton | SCP0114_CAPA_LineMaster.cs:1283 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | GRID_LOCK | spreadLevel.LockRange | (insCell, spreadLevel.GetColumnIndex(DefColumns.DUMMY_YN), spreadLevel.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f88236a5 | InsertButton | SCP0114_CAPA_LineMaster.cs:1284 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05c0065b | InsertButton | SCP0114_CAPA_LineMaster.cs:1288 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | GRID_LOCK | spreadLevel.LockRange | (insCell, spreadLevel.GetColumnIndex(DefColumns.SHOP_GROUP_ID), spreadLevel.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b16fddbf | InsertButton | SCP0114_CAPA_LineMaster.cs:1289 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-68e6c6c9 | InsertButton | SCP0114_CAPA_LineMaster.cs:684 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel2": ▸ if (string.IsNullOrEmpty(level1MenuID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4e5b287 | InsertButton | SCP0114_CAPA_LineMaster.cs:692 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel3": ▸ if (string.IsNullOrEmpty(level2MenuID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2a5ab447 | InsertButton | SCP0114_CAPA_LineMaster.cs:699 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel4": ▸ if (string.IsNullOrEmpty(level3MenuID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8967dac | InsertButton | SCP0114_CAPA_LineMaster.cs:707 | if (this.fps != null) ▸ switch (fps.Name) case "spdLevel5": ▸ if (string.IsNullOrEmpty(level4MenuID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-be36278c | InsertButton | SCP0114_CAPA_LineMaster.cs:726 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | spreadLevel.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-04df599a | InsertButton | SCP0114_CAPA_LineMaster.cs:739 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ if (fps.Name == "spdLevel1") | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, divisionID) | 데이터 객체 조작/조회 |  |  |  |
| AC-3484fec7 | InsertButton | SCP0114_CAPA_LineMaster.cs:743 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ if (fps.Name == "spdLev… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, divisionID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a92ada5c | InsertButton | SCP0114_CAPA_LineMaster.cs:744 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ if (fps.Name == "spdLev… | DATA_OP | defaultData.Add | (DefColumns.SITE_ID, _siteId) | 데이터 객체 조작/조회 |  |  |  |
| AC-47a5485b | InsertButton | SCP0114_CAPA_LineMaster.cs:745 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ if (fps.Name == "spdLev… | DATA_OP | defaultData.Add | (DefColumns.SITE_NAME, _siteName) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d6792de | InsertButton | SCP0114_CAPA_LineMaster.cs:749 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, divisionID) | 데이터 객체 조작/조회 |  |  |  |
| AC-310e6523 | InsertButton | SCP0114_CAPA_LineMaster.cs:750 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.SITE_ID, _siteId) | 데이터 객체 조작/조회 |  |  |  |
| AC-af612c39 | InsertButton | SCP0114_CAPA_LineMaster.cs:751 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.SITE_NAME, _siteName) | 데이터 객체 조작/조회 |  |  |  |
| AC-10117ddb | InsertButton | SCP0114_CAPA_LineMaster.cs:752 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.COMPANY_ID, _companyId) | 데이터 객체 조작/조회 |  |  |  |
| AC-28f4b9ea | InsertButton | SCP0114_CAPA_LineMaster.cs:753 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.COMPANY_NAME, _companyName) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0f79e84 | InsertButton | SCP0114_CAPA_LineMaster.cs:758 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, divisionID) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a83d9b8 | InsertButton | SCP0114_CAPA_LineMaster.cs:759 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.SITE_ID, _siteId) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c55eb60 | InsertButton | SCP0114_CAPA_LineMaster.cs:760 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.SITE_NAME, _siteName) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a2cd9ff | InsertButton | SCP0114_CAPA_LineMaster.cs:761 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.COMPANY_ID, _companyId) | 데이터 객체 조작/조회 |  |  |  |
| AC-52712c1a | InsertButton | SCP0114_CAPA_LineMaster.cs:762 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.COMPANY_NAME, _companyName) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3349090 | InsertButton | SCP0114_CAPA_LineMaster.cs:763 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.PLANT_ID, _plantId) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4901387 | InsertButton | SCP0114_CAPA_LineMaster.cs:764 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.PLANT_NAME, _plantName) | 데이터 객체 조작/조회 |  |  |  |
| AC-59816eda | InsertButton | SCP0114_CAPA_LineMaster.cs:769 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, divisionID) | 데이터 객체 조작/조회 |  |  |  |
| AC-33513ae8 | InsertButton | SCP0114_CAPA_LineMaster.cs:770 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.SITE_ID, _siteId) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3c351bd | InsertButton | SCP0114_CAPA_LineMaster.cs:771 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.SITE_NAME, _siteName) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f6e6d62 | InsertButton | SCP0114_CAPA_LineMaster.cs:772 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.COMPANY_ID, _companyId) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ded9a70 | InsertButton | SCP0114_CAPA_LineMaster.cs:773 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.COMPANY_NAME, _companyName) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa1cf615 | InsertButton | SCP0114_CAPA_LineMaster.cs:774 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.PLANT_ID, _plantId) | 데이터 객체 조작/조회 |  |  |  |
| AC-452f0e70 | InsertButton | SCP0114_CAPA_LineMaster.cs:775 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.PLANT_NAME, _plantName) | 데이터 객체 조작/조회 |  |  |  |
| AC-176381d7 | InsertButton | SCP0114_CAPA_LineMaster.cs:776 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.FACTORY_ID, _factoryId) | 데이터 객체 조작/조회 |  |  |  |
| AC-a02f4709 | InsertButton | SCP0114_CAPA_LineMaster.cs:777 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) ▸ else of (fps.Name == "spdLevel1") ▸ else of (fps.Name == "s… | DATA_OP | defaultData.Add | (DefColumns.FACTORY_NAME, _factoryName) | 데이터 객체 조작/조회 |  |  |  |
| AC-58fe64e8 | InsertButton | SCP0114_CAPA_LineMaster.cs:780 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.SORT_ORDER, sortOrder) | 데이터 객체 조작/조회 |  |  |  |
| AC-14b5b8c7 | InsertButton | SCP0114_CAPA_LineMaster.cs:781 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-4f8e3b47 | InsertButton | SCP0114_CAPA_LineMaster.cs:782 | if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false) | GRID_SET | spreadLevel.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## SCP0114_CAPA_LineMaster.RefreshCompanySpread

진입점: this.spdLevel2.CellClick [if (e.Column == siLevel2.GetColumnIndex(DefColumns.COMPANY_ID))] / InsertButton [if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5935b2a | this.spdLevel2.CellClick [if (e.Column == siLevel2.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1663 |  | CALL_EXT | ScpCapaBL.GetFilterSite | ("81") | ⚠ 의미 확인 필요 |  |  |  |
| AC-df7ec19d | this.spdLevel2.CellClick [if (e.Column == siLevel2.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1666 |  | FLAG | dtCompanySpread | DBUtils.GetDistinctedCode(dtCompanyAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-e75035b5 | this.spdLevel2.CellClick [if (e.Column == siLevel2.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1666 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtCompanyAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5809fa3 | this.spdLevel2.CellClick [if (e.Column == siLevel2.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1667 |  | FLAG | dtCompanySpread | ScpCapaBL.GetSortedCode(dtCompanySpread) | 화면 필드/플래그 변경 |  |  |  |
| AC-7df2af04 | this.spdLevel2.CellClick [if (e.Column == siLevel2.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1667 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtCompanySpread) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd30ca84 | this.spdLevel2.CellClick [if (e.Column == siLevel2.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:911 |  | CALL_EXT | ScpCapaBL.GetFilterSite | ("81") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d72797d | this.spdLevel2.CellClick [if (e.Column == siLevel2.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:914 |  | FLAG | dtCompanySpread | DBUtils.GetDistinctedCode(dtCompanyAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-29341cb0 | this.spdLevel2.CellClick [if (e.Column == siLevel2.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:914 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtCompanyAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-121051b7 | this.spdLevel2.CellClick [if (e.Column == siLevel2.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:915 |  | FLAG | dtCompanySpread | ScpCapaBL.GetSortedCode(dtCompanySpread) | 화면 필드/플래그 변경 |  |  |  |
| AC-9b7d28b3 | this.spdLevel2.CellClick [if (e.Column == siLevel2.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:915 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtCompanySpread) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0114_CAPA_LineMaster.RefreshEditMode

진입점: this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / this.spdLevel2.CellDoubleClick [if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / this.spdLevel3.CellDoubleClick [if (!siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / this.spdLevel4.CellDoubleClick [if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / this.cboDivision.SelectedIndexChanged [if (siLevel1 != null)] / this.rgrpSearchLevel.SelectedIndexChanged / FindButton / SaveButton [if (_si != null && _si.IsLock(_si.SheetName) ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9fea934 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:1631 |  | DATA_OP | IsEditModes[DIC_CAPA_LINE_SITE] | false | 행/컬럼 값 대입 |  |  |  |
| AC-13f942da | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:1632 |  | DATA_OP | IsEditModes[DIC_CAPA_LINE_COMPANY] | false | 행/컬럼 값 대입 |  |  |  |
| AC-c51d262f | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:1633 |  | DATA_OP | IsEditModes[DIC_CAPA_LINE_PLANT] | false | 행/컬럼 값 대입 |  |  |  |
| AC-bd5a54aa | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:1634 |  | DATA_OP | IsEditModes[DIC_CAPA_LINE_FACTORY] | false | 행/컬럼 값 대입 |  |  |  |
| AC-8f1e3f71 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:1635 |  | DATA_OP | IsEditModes[DIC_CAPA_LINE] | false | 행/컬럼 값 대입 |  |  |  |

## SCP0114_CAPA_LineMaster.RefreshEnabled

진입점: this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / this.spdLevel2.CellDoubleClick [if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / this.spdLevel3.CellDoubleClick [if (!siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / this.spdLevel4.CellDoubleClick [if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / this.cboDivision.SelectedIndexChanged [if (siLevel1 != null)] / this.rgrpSearchLevel.SelectedIndexChanged / FindButton / SaveButton [if (_si != null && _si.IsLock(_si.SheetName) ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b1486a0 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:1707 |  | STATE | spdLevel1.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4829bf32 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:1708 |  | STATE | spdLevel2.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c338819d | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:1709 |  | STATE | spdLevel3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ac788081 | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:1710 |  | STATE | spdLevel4.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9556af1e | this.spdLevel1.CellDoubleClick [else of (siLevel1.ActiveShee… 외 7 | SCP0114_CAPA_LineMaster.cs:1711 |  | STATE | spdLevel5.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0114_CAPA_LineMaster.RefreshFactorySpread

진입점: this.spdLevel4.CellClick [if (e.Column == siLevel4.GetColumnIndex(DefColumns.FACTORY_ID))] / InsertButton [if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cedee2d2 | this.spdLevel4.CellClick [if (e.Column == siLevel4.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1685 |  | CALL_EXT | ScpCapaBL.GetFilterSite | ("81") | ⚠ 의미 확인 필요 |  |  |  |
| AC-81ece606 | this.spdLevel4.CellClick [if (e.Column == siLevel4.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1688 |  | FLAG | dtFactorySpread | DBUtils.GetDistinctedCode(dtFactoryAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-2055b1d7 | this.spdLevel4.CellClick [if (e.Column == siLevel4.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1688 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtFactoryAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8edbda5a | this.spdLevel4.CellClick [if (e.Column == siLevel4.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1689 |  | FLAG | dtFactorySpread | ScpCapaBL.GetSortedCode(dtFactorySpread) | 화면 필드/플래그 변경 |  |  |  |
| AC-65bf67a0 | this.spdLevel4.CellClick [if (e.Column == siLevel4.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1689 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtFactorySpread) | ⚠ 의미 확인 필요 |  |  |  |
| AC-25fd1d89 | this.spdLevel4.CellClick [if (e.Column == siLevel4.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:933 |  | CALL_EXT | ScpCapaBL.GetFilterSite | ("81") | ⚠ 의미 확인 필요 |  |  |  |
| AC-402d1e6a | this.spdLevel4.CellClick [if (e.Column == siLevel4.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:936 |  | FLAG | dtFactorySpread | DBUtils.GetDistinctedCode(dtFactoryAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c298e26 | this.spdLevel4.CellClick [if (e.Column == siLevel4.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:936 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtFactoryAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1fdc411d | this.spdLevel4.CellClick [if (e.Column == siLevel4.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:937 |  | FLAG | dtFactorySpread | ScpCapaBL.GetSortedCode(dtFactorySpread) | 화면 필드/플래그 변경 |  |  |  |
| AC-81ef6a2d | this.spdLevel4.CellClick [if (e.Column == siLevel4.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:937 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtFactorySpread) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0114_CAPA_LineMaster.RefreshLineSpread

진입점: this.spdLevel5.CellClick [if (e.Column == siLevel5.GetColumnIndex(DefColumns.LINE_ID))] / InsertButton [if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8665222 | this.spdLevel5.CellClick [if (e.Column == siLevel5.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1696 |  | CALL_EXT | ScpCapaBL.GetFilterSite | ("81") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d187b17c | this.spdLevel5.CellClick [if (e.Column == siLevel5.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1699 |  | FLAG | dtLineSpread | DBUtils.GetDistinctedCode(dtLineAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-16ac30b6 | this.spdLevel5.CellClick [if (e.Column == siLevel5.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1699 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtLineAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-daf85415 | this.spdLevel5.CellClick [if (e.Column == siLevel5.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1700 |  | FLAG | dtLineSpread | ScpCapaBL.GetSortedCode(dtLineSpread) | 화면 필드/플래그 변경 |  |  |  |
| AC-34a2e602 | this.spdLevel5.CellClick [if (e.Column == siLevel5.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1700 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtLineSpread) | ⚠ 의미 확인 필요 |  |  |  |
| AC-75a3149e | this.spdLevel5.CellClick [if (e.Column == siLevel5.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:944 |  | CALL_EXT | ScpCapaBL.GetFilterSite | ("81") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fb32d550 | this.spdLevel5.CellClick [if (e.Column == siLevel5.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:947 |  | FLAG | dtLineSpread | DBUtils.GetDistinctedCode(dtLineAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-d59e0c87 | this.spdLevel5.CellClick [if (e.Column == siLevel5.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:947 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtLineAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ba77e24 | this.spdLevel5.CellClick [if (e.Column == siLevel5.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:948 |  | FLAG | dtLineSpread | ScpCapaBL.GetSortedCode(dtLineSpread) | 화면 필드/플래그 변경 |  |  |  |
| AC-14c07ce0 | this.spdLevel5.CellClick [if (e.Column == siLevel5.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:948 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtLineSpread) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0114_CAPA_LineMaster.RefreshPlantSpread

진입점: this.spdLevel3.CellClick [if (e.Column == siLevel3.GetColumnIndex(DefColumns.PLANT_ID))] / InsertButton [if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a500145 | this.spdLevel3.CellClick [if (e.Column == siLevel3.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1674 |  | CALL_EXT | ScpCapaBL.GetFilterSite | ("81") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7adde797 | this.spdLevel3.CellClick [if (e.Column == siLevel3.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1677 |  | FLAG | dtPlantSpread | DBUtils.GetDistinctedCode(dtPlantAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-32e998d3 | this.spdLevel3.CellClick [if (e.Column == siLevel3.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1677 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtPlantAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-543bd219 | this.spdLevel3.CellClick [if (e.Column == siLevel3.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1678 |  | FLAG | dtPlantSpread | ScpCapaBL.GetSortedCode(dtPlantSpread) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a26bb72 | this.spdLevel3.CellClick [if (e.Column == siLevel3.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:1678 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtPlantSpread) | ⚠ 의미 확인 필요 |  |  |  |
| AC-86cd01be | this.spdLevel3.CellClick [if (e.Column == siLevel3.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:922 |  | CALL_EXT | ScpCapaBL.GetFilterSite | ("81") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9bf971b | this.spdLevel3.CellClick [if (e.Column == siLevel3.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:925 |  | FLAG | dtPlantSpread | DBUtils.GetDistinctedCode(dtPlantAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-75a48c60 | this.spdLevel3.CellClick [if (e.Column == siLevel3.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:925 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtPlantAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c11d6b1 | this.spdLevel3.CellClick [if (e.Column == siLevel3.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:926 |  | FLAG | dtPlantSpread | ScpCapaBL.GetSortedCode(dtPlantSpread) | 화면 필드/플래그 변경 |  |  |  |
| AC-846403d4 | this.spdLevel3.CellClick [if (e.Column == siLevel3.GetColumn… 외 2 | SCP0114_CAPA_LineMaster.cs:926 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtPlantSpread) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0114_CAPA_LineMaster.RefreshSiteAll

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-218e40a6 | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:1615 |  | FLAG | dtSiteAll | Data_SCP.CommonAll(Data_SCP.Type.CapaSite, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-1effcc0d | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:1615 |  | COMBO_DATA | Data_SCP.CommonAll | (Data_SCP.Type.CapaSite, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-39d536e9 | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:870 |  | FLAG | dtSiteAll | Data_SCP.CommonAll(Data_SCP.Type.CapaSite, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-62acf36d | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:870 |  | COMBO_DATA | Data_SCP.CommonAll | (Data_SCP.Type.CapaSite, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0114_CAPA_LineMaster.RefreshSiteSpread

진입점: this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumnIndex(DefColumns.SITE_ID))] / this.spdLevel1.ComboSelChange [if (e.Column == siLevel1.GetColumnIndex(DefColumns.DIVISION_ID))] / this.spdLevel2.ComboSelChange [if (e.Column == siLevel2.GetColumnIndex(DefColumns.DIVISION_ID))] / InsertButton [if (spreadLevel != null && spreadLevel.IsLock(spreadLevel.SheetName) == false)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b56672b5 | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 4 | SCP0114_CAPA_LineMaster.cs:1652 |  | CALL_EXT | ScpCapaBL.GetFilterSite | ("81") | ⚠ 의미 확인 필요 |  |  |  |
| AC-38a15683 | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 4 | SCP0114_CAPA_LineMaster.cs:1655 |  | FLAG | dtSiteSpread | DBUtils.GetDistinctedCode(dtSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-dc9a7a86 | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 4 | SCP0114_CAPA_LineMaster.cs:1655 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtSiteAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bde6da17 | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 4 | SCP0114_CAPA_LineMaster.cs:1656 |  | FLAG | dtSiteSpread | ScpCapaBL.GetSortedCode(dtSiteSpread) | 화면 필드/플래그 변경 |  |  |  |
| AC-78746b3d | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 4 | SCP0114_CAPA_LineMaster.cs:1656 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtSiteSpread) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9bcf856d | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 4 | SCP0114_CAPA_LineMaster.cs:900 |  | CALL_EXT | ScpCapaBL.GetFilterSite | ("81") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4f7a70d | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 4 | SCP0114_CAPA_LineMaster.cs:903 |  | FLAG | dtSiteSpread | DBUtils.GetDistinctedCode(dtSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-cccd2f4c | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 4 | SCP0114_CAPA_LineMaster.cs:903 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtSiteAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9382a5c3 | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 4 | SCP0114_CAPA_LineMaster.cs:904 |  | FLAG | dtSiteSpread | ScpCapaBL.GetSortedCode(dtSiteSpread) | 화면 필드/플래그 변경 |  |  |  |
| AC-e405ab70 | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 4 | SCP0114_CAPA_LineMaster.cs:904 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtSiteSpread) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0114_CAPA_LineMaster.RefreshSpreadComboAll

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8ea7ffc | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:955 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel1, rowIdx, DefColumns.SITE_ID, dtSiteSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8835d708 | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:956 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel1, rowIdx, DefColumns.SITE_NAME, dtSiteSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-dcf45790 | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:957 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel2, rowIdx, DefColumns.COMPANY_ID, dtCompanySpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5fe5feae | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:958 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel2, rowIdx, DefColumns.COMPANY_NAME, dtCompanySpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d5d63803 | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:959 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel3, rowIdx, DefColumns.PLANT_ID, dtPlantSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7e1cb650 | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:960 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel3, rowIdx, DefColumns.PLANT_NAME, dtPlantSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fe9083c3 | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:961 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel4, rowIdx, DefColumns.FACTORY_ID, dtFactorySpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9fa7ade9 | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:962 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel4, rowIdx, DefColumns.FACTORY_NAME, dtFactorySpreadName, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6c2d48e6 | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:963 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel5, rowIdx, DefColumns.LINE_ID, dtLineSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8cb621d8 | (진입점 미연결) | SCP0114_CAPA_LineMaster.cs:964 |  | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel5, rowIdx, DefColumns.LINE_NAME, dtLineSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0114_CAPA_LineMaster.rgrpSearchLevel_SelectedIndexChanged

진입점: this.rgrpSearchLevel.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6497d140 | this.rgrpSearchLevel.SelectedIndexChanged | SCP0114_CAPA_LineMaster.cs:1849 |  | FLAG | divisionID | CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-ba93044c | this.rgrpSearchLevel.SelectedIndexChanged | SCP0114_CAPA_LineMaster.cs:1855 | if (rgrpSearchLevel.SelectedIndex == 0) | FLAG | _shopgroupId | "E" | 화면 필드/플래그 변경 |  |  |  |
| AC-8753aa08 | this.rgrpSearchLevel.SelectedIndexChanged | SCP0114_CAPA_LineMaster.cs:1859 | else of (rgrpSearchLevel.SelectedIndex == 0) ▸ if (rgrpSearchLevel.SelectedIndex == 1) | FLAG | _shopgroupId | "A" | 화면 필드/플래그 변경 |  |  |  |
| AC-73af520f | this.rgrpSearchLevel.SelectedIndexChanged | SCP0114_CAPA_LineMaster.cs:1863 | else of (rgrpSearchLevel.SelectedIndex == 0) ▸ else of (rgrpSearchLevel.SelectedIndex == 1) | FLAG | _shopgroupId | "P" | 화면 필드/플래그 변경 |  |  |  |

## SCP0114_CAPA_LineMaster.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f510fe5 | SaveButton | SCP0114_CAPA_LineMaster.cs:771 | if (CheckDummyDuplication()) | MESSAGE | MessageHelper.GMessageBox | ("Id 또는 Name 값이 없습니다.", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5eb61220 | SaveButton | SCP0114_CAPA_LineMaster.cs:772 | if (CheckDummyDuplication()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f7af8e07 | SaveButton | SCP0114_CAPA_LineMaster.cs:782 | if (_si.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f66f01ab | SaveButton | SCP0114_CAPA_LineMaster.cs:908 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0114_SAVE_CAPA_LINE_MASTER") ⇒ SCP.SCP0114_SAVE_CAPA_LINE_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-931b02a5 | SaveButton | SCP0114_CAPA_LineMaster.cs:910 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-fdca1a1e | SaveButton | SCP0114_CAPA_LineMaster.cs:911 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_spreadSeq"] | p_spreadSeq | 행/컬럼 값 대입 |  |  |  |
| AC-9311d6e7 | SaveButton | SCP0114_CAPA_LineMaster.cs:912 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9da6b238 | SaveButton | SCP0114_CAPA_LineMaster.cs:913 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-5b0235cc | SaveButton | SCP0114_CAPA_LineMaster.cs:914 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_site_name"] | p_site_name | 행/컬럼 값 대입 |  |  |  |
| AC-e8ce124e | SaveButton | SCP0114_CAPA_LineMaster.cs:915 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-9677e647 | SaveButton | SCP0114_CAPA_LineMaster.cs:916 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_company_name"] | p_company_name | 행/컬럼 값 대입 |  |  |  |
| AC-54c1a9ca | SaveButton | SCP0114_CAPA_LineMaster.cs:917 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-2a240df8 | SaveButton | SCP0114_CAPA_LineMaster.cs:918 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_name"] | p_plant_name | 행/컬럼 값 대입 |  |  |  |
| AC-5e6e090b | SaveButton | SCP0114_CAPA_LineMaster.cs:919 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-d4d9784e | SaveButton | SCP0114_CAPA_LineMaster.cs:920 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_factory_name"] | p_factory_name | 행/컬럼 값 대입 |  |  |  |
| AC-f671325a | SaveButton | SCP0114_CAPA_LineMaster.cs:921 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-4d2d2a1c | SaveButton | SCP0114_CAPA_LineMaster.cs:922 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-b78d2a69 | SaveButton | SCP0114_CAPA_LineMaster.cs:923 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_shop_group_id"] | p_shop_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-63a2cf10 | SaveButton | SCP0114_CAPA_LineMaster.cs:924 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-75b31ef4 | SaveButton | SCP0114_CAPA_LineMaster.cs:925 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-372c4900 | SaveButton | SCP0114_CAPA_LineMaster.cs:926 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-b66d151c | SaveButton | SCP0114_CAPA_LineMaster.cs:928 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5f04ad5b | SaveButton | SCP0114_CAPA_LineMaster.cs:933 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S"… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bfc1e1af | SaveButton | SCP0114_CAPA_LineMaster.cs:961 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables[0].Rows[0][0].ToString() =… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e48c18da | SaveButton | SCP0114_CAPA_LineMaster.cs:968 | if (_si != null && _si.IsLock(_si.SheetName) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cf6f58b4 | SaveButton | SCP0114_CAPA_LineMaster.cs:529 |  | DATA_OP | saveSpread.Add | (1, siLevel1) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6200cc8 | SaveButton | SCP0114_CAPA_LineMaster.cs:530 |  | DATA_OP | saveSpread.Add | (2, siLevel2) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab95c4c5 | SaveButton | SCP0114_CAPA_LineMaster.cs:531 |  | DATA_OP | saveSpread.Add | (3, siLevel3) | 데이터 객체 조작/조회 |  |  |  |
| AC-df6723cf | SaveButton | SCP0114_CAPA_LineMaster.cs:532 |  | DATA_OP | saveSpread.Add | (4, siLevel4) | 데이터 객체 조작/조회 |  |  |  |
| AC-969dc240 | SaveButton | SCP0114_CAPA_LineMaster.cs:533 |  | DATA_OP | saveSpread.Add | (5, siLevel5) | 데이터 객체 조작/조회 |  |  |  |
| AC-128f08dd | SaveButton | SCP0114_CAPA_LineMaster.cs:549 | for (i < saveSpread.Count) ▸ for (h <= _spreadLevel.GetMaxRowIndex()) ▸ if (action != "") | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2a743930 | SaveButton | SCP0114_CAPA_LineMaster.cs:550 | for (i < saveSpread.Count) ▸ for (h <= _spreadLevel.GetMaxRowIndex()) ▸ if (action != "") | DATA_OP | saveDS.Tables[0].Columns.Add | ("spreadSeq", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc21e716 | SaveButton | SCP0114_CAPA_LineMaster.cs:551 | for (i < saveSpread.Count) ▸ for (h <= _spreadLevel.GetMaxRowIndex()) ▸ if (action != "") | DATA_OP | saveDS.Tables[0].Columns.Add | ("RegtUserID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fbb52ed0 | SaveButton | SCP0114_CAPA_LineMaster.cs:553 | for (i < saveSpread.Count) ▸ for (h <= _spreadLevel.GetMaxRowIndex()) ▸ if (action != "") | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-7a8b3e5e | SaveButton | SCP0114_CAPA_LineMaster.cs:554 | for (i < saveSpread.Count) ▸ for (h <= _spreadLevel.GetMaxRowIndex()) ▸ if (action != "") | DATA_OP | dr[DefColumns.DIVISION_ID] | _spreadLevel.GetValue(i, _spreadLevel.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e8952a9d | SaveButton | SCP0114_CAPA_LineMaster.cs:555 | for (i < saveSpread.Count) ▸ for (h <= _spreadLevel.GetMaxRowIndex()) ▸ if (action != "") | DATA_OP | dr[DefColumns.SITE_ID] | _spreadLevel.GetValue(i, _spreadLevel.GetColumnIndex(DefColumns.SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7618f945 | SaveButton | SCP0114_CAPA_LineMaster.cs:556 | for (i < saveSpread.Count) ▸ for (h <= _spreadLevel.GetMaxRowIndex()) ▸ if (action != "") | DATA_OP | dr[DefColumns.SITE_NAME] | _spreadLevel.GetValue(i, _spreadLevel.GetColumnIndex(DefColumns.SITE_NAME)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-394eceee | SaveButton | SCP0114_CAPA_LineMaster.cs:557 | for (i < saveSpread.Count) ▸ for (h <= _spreadLevel.GetMaxRowIndex()) ▸ if (action != "") | DATA_OP | dr[DefColumns.VALID_YN] | _spreadLevel.GetValue(i, _spreadLevel.GetColumnIndex(DefColumns.VALID_YN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3a0c8194 | SaveButton | SCP0114_CAPA_LineMaster.cs:558 | for (i < saveSpread.Count) ▸ for (h <= _spreadLevel.GetMaxRowIndex()) ▸ if (action != "") | DATA_OP | dr["spreadSeq"] | "S" | 행/컬럼 값 대입 |  |  |  |
| AC-05ff437a | SaveButton | SCP0114_CAPA_LineMaster.cs:559 | for (i < saveSpread.Count) ▸ for (h <= _spreadLevel.GetMaxRowIndex()) ▸ if (action != "") | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d0d8389d | SaveButton | SCP0114_CAPA_LineMaster.cs:560 | for (i < saveSpread.Count) ▸ for (h <= _spreadLevel.GetMaxRowIndex()) ▸ if (action != "") | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba5b8e8c | SaveButton | SCP0114_CAPA_LineMaster.cs:563 | for (i < saveSpread.Count) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4ec7ae49 | SaveButton | SCP0114_CAPA_LineMaster.cs:572 | foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row["A"].ToString()) case CAppSetting.FlagI: | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd474e4e | SaveButton | SCP0114_CAPA_LineMaster.cs:573 | foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row["A"].ToString()) case CAppSetting.FlagM: | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4acf6d7d | SaveButton | SCP0114_CAPA_LineMaster.cs:574 | foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row["A"].ToString()) case CAppSetting.FlagD: | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2cb97810 | SaveButton | SCP0114_CAPA_LineMaster.cs:578 |  | UI_PROP | request.InsertQueryId | "SystemManager.UP_FX_SaveMenuItemInfo" | 속성 InsertQueryId 설정 |  |  |  |
| AC-0bb05053 | SaveButton | SCP0114_CAPA_LineMaster.cs:579 |  | UI_PROP | request.DeleteQueryId | "SystemManager.UP_FX_DeleteMenuItemInfo" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-918293e8 | SaveButton | SCP0114_CAPA_LineMaster.cs:580 |  | UI_PROP | request.UpdateQueryId | "SystemManager.UP_FX_SaveMenuItemInfo" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-e51bb4a9 | SaveButton | SCP0114_CAPA_LineMaster.cs:581 |  | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-a06d8bf8 | SaveButton | SCP0114_CAPA_LineMaster.cs:581 |  | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-32181e4e | SaveButton | SCP0114_CAPA_LineMaster.cs:585 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2d54e98b | SaveButton | SCP0114_CAPA_LineMaster.cs:589 | lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-740d63d3 | SaveButton | SCP0114_CAPA_LineMaster.cs:589 | lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-4f3caa09 | SaveButton | SCP0114_CAPA_LineMaster.cs:594 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0114_CAPA_LineMaster.SetSpreadNameToCode

진입점: this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumnIndex(DefColumns.SITE_ID))] / this.spdLevel2.CellClick [if (e.Column == siLevel2.GetColumnIndex(DefColumns.COMPANY_ID))] / this.spdLevel3.CellClick [if (e.Column == siLevel3.GetColumnIndex(DefColumns.PLANT_ID))] / this.spdLevel4.CellClick [if (e.Column == siLevel4.GetColumnIndex(DefColumns.FACTORY_ID))] / this.spdLevel5.CellClick [if (e.Column == siLevel5.GetColumnIndex(DefColumns.LINE_ID))] / this.spdLevel1.ComboSelChange [if (e.Column == siLevel1.GetColumnIndex(DefColumns.DIVISION_ID))] / this.spdLevel2.ComboSelChange [if (e.Column …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1ad3af0 | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 8 | SCP0114_CAPA_LineMaster.cs:1527 |  | DATA_OP | tblSource.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-daabacf2 | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 8 | SCP0114_CAPA_LineMaster.cs:1538 | foreach (DataRow r in tbl.Rows) ▸ try | DATA_OP | r["NAME"] | newName | 행/컬럼 값 대입 |  |  |  |
| AC-c03866a4 | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 8 | SCP0114_CAPA_LineMaster.cs:1548 |  | DATA_OP | tblSource.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-17e058e1 | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 8 | SCP0114_CAPA_LineMaster.cs:1549 |  | DATA_OP | tblSource.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-434ed2ed | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 8 | SCP0114_CAPA_LineMaster.cs:1555 | foreach (DataRow r in tblCode.Rows) ▸ try | DATA_OP | r["NAME"] | r["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-fae4a089 | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 8 | SCP0114_CAPA_LineMaster.cs:1571 | foreach (DataRow r in tblName.Rows) ▸ try | DATA_OP | r["CODE"] | newName | 행/컬럼 값 대입 |  |  |  |
| AC-9a360f79 | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 8 | SCP0114_CAPA_LineMaster.cs:1572 | foreach (DataRow r in tblName.Rows) ▸ try | DATA_OP | r["NAME"] | newName | 행/컬럼 값 대입 |  |  |  |
| AC-b7bf313f | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 8 | SCP0114_CAPA_LineMaster.cs:815 |  | DATA_OP | tblSource.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5be22317 | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 8 | SCP0114_CAPA_LineMaster.cs:826 | foreach (DataRow r in tbl.Rows) ▸ try | DATA_OP | r["NAME"] | newName | 행/컬럼 값 대입 |  |  |  |
| AC-81dc208e | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 8 | SCP0114_CAPA_LineMaster.cs:836 |  | DATA_OP | tblSource.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-41237a95 | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 8 | SCP0114_CAPA_LineMaster.cs:837 |  | DATA_OP | tblSource.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ff981879 | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 8 | SCP0114_CAPA_LineMaster.cs:843 | foreach (DataRow r in tblCode.Rows) ▸ try | DATA_OP | r["NAME"] | r["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-cf35d105 | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 8 | SCP0114_CAPA_LineMaster.cs:859 | foreach (DataRow r in tblName.Rows) ▸ try | DATA_OP | r["CODE"] | newName | 행/컬럼 값 대입 |  |  |  |
| AC-f13411bb | this.spdLevel1.CellClick [if (e.Column == siLevel1.GetColumn… 외 8 | SCP0114_CAPA_LineMaster.cs:860 | foreach (DataRow r in tblName.Rows) ▸ try | DATA_OP | r["NAME"] | newName | 행/컬럼 값 대입 |  |  |  |

## SCP0114_CAPA_LineMaster.spdAssign_Change

진입점: this.spdLevel1.Change / this.spdLevel2.Change / this.spdLevel3.Change / this.spdLevel4.Change / this.spdLevel5.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d7d57b6 | this.spdLevel1.Change 외 4 | SCP0114_CAPA_LineMaster.cs:1734 | if (spreadLevel == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-619f3d44 | this.spdLevel1.Change 외 4 | SCP0114_CAPA_LineMaster.cs:1737 | if (spreadLevel.IsLock(spreadLevel.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0114_CAPA_LineMaster.spdAssign_ComboSelChange

진입점: this.spdLevel1.ComboSelChange / this.spdLevel2.ComboSelChange / this.spdLevel3.ComboSelChange / this.spdLevel4.ComboSelChange / this.spdLevel5.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1dcf4517 | this.spdLevel1.ComboSelChange 외 4 | SCP0114_CAPA_LineMaster.cs:1293 | if (spreadLevel.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d14eea88 | this.spdLevel1.ComboSelChange 외 4 | SCP0114_CAPA_LineMaster.cs:1296 | if (spreadLevel.ActiveRowIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c0b6858d | this.spdLevel1.ComboSelChange 외 4 | SCP0114_CAPA_LineMaster.cs:1299 | if (_curr_assign_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0114_CAPA_LineMaster.spdLevel1_CellClick

진입점: this.spdLevel1.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f375d18 | this.spdLevel1.CellClick | SCP0114_CAPA_LineMaster.cs:1077 |  | FLAG | this._currAssignRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-ca66f33d | this.spdLevel1.CellClick | SCP0114_CAPA_LineMaster.cs:1078 |  | FLAG | this._currAssignColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-f961a8d1 | this.spdLevel1.CellClick | SCP0114_CAPA_LineMaster.cs:1082 | if (siLevel1 == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-97a1a2e5 | this.spdLevel1.CellClick | SCP0114_CAPA_LineMaster.cs:1085 | if (siLevel1.IsLock(siLevel1.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-435b695e | this.spdLevel1.CellClick | SCP0114_CAPA_LineMaster.cs:1087 |  | CALL_EXT | siLevel1.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-021438f3 | this.spdLevel1.CellClick | SCP0114_CAPA_LineMaster.cs:1088 | if (siLevel1.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-190670d0 | this.spdLevel1.CellClick | SCP0114_CAPA_LineMaster.cs:1095 | if (e.Column == siLevel1.GetColumnIndex(DefColumns.SITE_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel1, e.Row, DefColumns.SITE_ID, dtSiteSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9e9e7f70 | this.spdLevel1.CellClick | SCP0114_CAPA_LineMaster.cs:1096 | if (e.Column == siLevel1.GetColumnIndex(DefColumns.SITE_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel1, e.Row, DefColumns.SITE_NAME, dtSiteSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0114_CAPA_LineMaster.SpdLevel1_CellDoubleClick

진입점: this.spdLevel1.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cd6c554 | this.spdLevel1.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1746 | if (siLevel1.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b628de2c | this.spdLevel1.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1753 | else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | divisionID | siLevel1.GetText(e.Row, siLevel1.GetColumnIndex(DefColumns.DIVISION_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-efce728b | this.spdLevel1.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1754 | else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level1MenuID | siLevel1.GetText(e.Row, siLevel1.GetColumnIndex(DefColumns.SITE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-79cdede2 | this.spdLevel1.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1757 | else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _siteId | siLevel1.GetText(e.Row, siLevel1.GetColumnIndex(DefColumns.SITE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-53e1ec2b | this.spdLevel1.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1758 | else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _siteName | siLevel1.GetText(e.Row, siLevel1.GetColumnIndex(DefColumns.SITE_NAME)) | 화면 필드/플래그 변경 |  |  |  |
| AC-a6fd9915 | this.spdLevel1.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:974 | if (siLevel1.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05f61e2c | this.spdLevel1.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:981 | else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | divisionID | siLevel1.GetText(e.Row, siLevel1.GetColumnIndex(DefColumns.DIVISION_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-4efcf73c | this.spdLevel1.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:982 | else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level1MenuID | siLevel1.GetText(e.Row, siLevel1.GetColumnIndex(DefColumns.SITE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-2005e2ba | this.spdLevel1.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:985 | else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _siteId | siLevel1.GetText(e.Row, siLevel1.GetColumnIndex(DefColumns.SITE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-aec6b26a | this.spdLevel1.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:986 | else of (siLevel1.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _siteName | siLevel1.GetText(e.Row, siLevel1.GetColumnIndex(DefColumns.SITE_NAME)) | 화면 필드/플래그 변경 |  |  |  |

## SCP0114_CAPA_LineMaster.spdLevel1_ComboSelChange

진입점: this.spdLevel1.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bde25ecb | this.spdLevel1.ComboSelChange | SCP0114_CAPA_LineMaster.cs:1199 | if (siLevel1.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8bee8581 | this.spdLevel1.ComboSelChange | SCP0114_CAPA_LineMaster.cs:1202 | if (siLevel1.ActiveRowIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-54b12609 | this.spdLevel1.ComboSelChange | SCP0114_CAPA_LineMaster.cs:1205 | if (_curr_assign_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0114_CAPA_LineMaster.spdLevel2_CellClick

진입점: this.spdLevel2.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dff9c41 | this.spdLevel2.CellClick | SCP0114_CAPA_LineMaster.cs:1101 |  | FLAG | this._currAssignRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-d6a7e2b3 | this.spdLevel2.CellClick | SCP0114_CAPA_LineMaster.cs:1102 |  | FLAG | this._currAssignColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-874a4643 | this.spdLevel2.CellClick | SCP0114_CAPA_LineMaster.cs:1106 | if (siLevel2 == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed96b827 | this.spdLevel2.CellClick | SCP0114_CAPA_LineMaster.cs:1109 | if (siLevel2.IsLock(siLevel2.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2849f22e | this.spdLevel2.CellClick | SCP0114_CAPA_LineMaster.cs:1111 |  | CALL_EXT | siLevel2.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4602e75 | this.spdLevel2.CellClick | SCP0114_CAPA_LineMaster.cs:1112 | if (siLevel2.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-27ca68f9 | this.spdLevel2.CellClick | SCP0114_CAPA_LineMaster.cs:1119 | if (e.Column == siLevel2.GetColumnIndex(DefColumns.COMPANY_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel2, e.Row, DefColumns.COMPANY_ID, dtCompanySpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6f273123 | this.spdLevel2.CellClick | SCP0114_CAPA_LineMaster.cs:1120 | if (e.Column == siLevel2.GetColumnIndex(DefColumns.COMPANY_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel2, e.Row, DefColumns.COMPANY_NAME, dtCompanySpreadName, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0114_CAPA_LineMaster.SpdLevel2_CellDoubleClick

진입점: this.spdLevel2.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9c2ac0d | this.spdLevel2.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1765 | if (siLevel2.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2a8008a6 | this.spdLevel2.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1769 | if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | divisionID | siLevel2.GetText(e.Row, siLevel2.GetColumnIndex(DefColumns.DIVISION_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-e6f8c8fb | this.spdLevel2.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1770 | if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level1MenuID | siLevel2.GetText(e.Row, siLevel2.GetColumnIndex(DefColumns.SITE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-7ee758e1 | this.spdLevel2.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1771 | if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level2MenuID | siLevel2.GetText(e.Row, siLevel2.GetColumnIndex(DefColumns.COMPANY_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-d3da622f | this.spdLevel2.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1774 | if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _companyId | siLevel2.GetText(e.Row, siLevel2.GetColumnIndex(DefColumns.COMPANY_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-202ea008 | this.spdLevel2.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1775 | if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _companyName | siLevel2.GetText(e.Row, siLevel2.GetColumnIndex(DefColumns.COMPANY_NAME)) | 화면 필드/플래그 변경 |  |  |  |
| AC-66ec11e8 | this.spdLevel2.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:994 | if (siLevel2.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-763e367e | this.spdLevel2.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:998 | if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | divisionID | siLevel2.GetText(e.Row, siLevel2.GetColumnIndex(DefColumns.DIVISION_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-5d61b57e | this.spdLevel2.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:999 | if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level1MenuID | siLevel2.GetText(e.Row, siLevel2.GetColumnIndex(DefColumns.SITE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-68233b89 | this.spdLevel2.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1000 | if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level2MenuID | siLevel2.GetText(e.Row, siLevel2.GetColumnIndex(DefColumns.COMPANY_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-c47bdc7a | this.spdLevel2.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1003 | if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _companyId | siLevel2.GetText(e.Row, siLevel2.GetColumnIndex(DefColumns.COMPANY_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-35098a29 | this.spdLevel2.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1004 | if (!siLevel2.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _companyName | siLevel2.GetText(e.Row, siLevel2.GetColumnIndex(DefColumns.COMPANY_NAME)) | 화면 필드/플래그 변경 |  |  |  |

## SCP0114_CAPA_LineMaster.spdLevel2_ComboSelChange

진입점: this.spdLevel2.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c25a413e | this.spdLevel2.ComboSelChange | SCP0114_CAPA_LineMaster.cs:1240 | if (siLevel2.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b42fffb1 | this.spdLevel2.ComboSelChange | SCP0114_CAPA_LineMaster.cs:1243 | if (siLevel2.ActiveRowIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7f520517 | this.spdLevel2.ComboSelChange | SCP0114_CAPA_LineMaster.cs:1246 | if (_curr_assign_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0114_CAPA_LineMaster.spdLevel3_CellClick

진입점: this.spdLevel3.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c361438a | this.spdLevel3.CellClick | SCP0114_CAPA_LineMaster.cs:1125 |  | FLAG | this._currAssignRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-dafeeafd | this.spdLevel3.CellClick | SCP0114_CAPA_LineMaster.cs:1126 |  | FLAG | this._currAssignColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-fea4aaac | this.spdLevel3.CellClick | SCP0114_CAPA_LineMaster.cs:1130 | if (siLevel3 == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4085a321 | this.spdLevel3.CellClick | SCP0114_CAPA_LineMaster.cs:1133 | if (siLevel3.IsLock(siLevel3.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-549eb64a | this.spdLevel3.CellClick | SCP0114_CAPA_LineMaster.cs:1135 |  | CALL_EXT | siLevel3.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a2d6c665 | this.spdLevel3.CellClick | SCP0114_CAPA_LineMaster.cs:1136 | if (siLevel3.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87def967 | this.spdLevel3.CellClick | SCP0114_CAPA_LineMaster.cs:1143 | if (e.Column == siLevel3.GetColumnIndex(DefColumns.PLANT_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel3, e.Row, DefColumns.PLANT_ID, dtPlantSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5250fe65 | this.spdLevel3.CellClick | SCP0114_CAPA_LineMaster.cs:1144 | if (e.Column == siLevel3.GetColumnIndex(DefColumns.PLANT_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel3, e.Row, DefColumns.PLANT_NAME, dtPlantSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0114_CAPA_LineMaster.SpdLevel3_CellDoubleClick

진입점: this.spdLevel3.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dad065b0 | this.spdLevel3.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1782 | if (siLevel3.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-adc34344 | this.spdLevel3.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1786 | if (!siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | divisionID | siLevel3.GetText(e.Row, siLevel3.GetColumnIndex(DefColumns.DIVISION_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-832ac2fb | this.spdLevel3.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1787 | if (!siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level1MenuID | siLevel3.GetText(e.Row, siLevel3.GetColumnIndex(DefColumns.SITE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-fae83c3c | this.spdLevel3.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1788 | if (!siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level2MenuID | siLevel3.GetText(e.Row, siLevel3.GetColumnIndex(DefColumns.COMPANY_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-74383173 | this.spdLevel3.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1789 | if (!siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level3MenuID | siLevel3.GetText(e.Row, siLevel3.GetColumnIndex(DefColumns.PLANT_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-94717fd0 | this.spdLevel3.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1792 | if (!siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _plantId | siLevel3.GetText(e.Row, siLevel3.GetColumnIndex(DefColumns.PLANT_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-b678d158 | this.spdLevel3.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1793 | if (!siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _plantName | siLevel3.GetText(e.Row, siLevel3.GetColumnIndex(DefColumns.PLANT_NAME)) | 화면 필드/플래그 변경 |  |  |  |
| AC-331ae3c4 | this.spdLevel3.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1012 | if (siLevel3.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-44d9ec83 | this.spdLevel3.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1016 | if (!siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | divisionID | siLevel3.GetText(e.Row, siLevel3.GetColumnIndex(DefColumns.DIVISION_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-5fe85c0c | this.spdLevel3.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1017 | if (!siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level1MenuID | siLevel3.GetText(e.Row, siLevel3.GetColumnIndex(DefColumns.SITE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-44cba48f | this.spdLevel3.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1018 | if (!siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level2MenuID | siLevel3.GetText(e.Row, siLevel3.GetColumnIndex(DefColumns.COMPANY_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-2c9283a1 | this.spdLevel3.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1019 | if (!siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level3MenuID | siLevel3.GetText(e.Row, siLevel3.GetColumnIndex(DefColumns.PLANT_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-5ab1caa4 | this.spdLevel3.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1022 | if (!siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _plantId | siLevel3.GetText(e.Row, siLevel3.GetColumnIndex(DefColumns.PLANT_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-d0ceda8b | this.spdLevel3.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1023 | if (!siLevel3.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _plantName | siLevel3.GetText(e.Row, siLevel3.GetColumnIndex(DefColumns.PLANT_NAME)) | 화면 필드/플래그 변경 |  |  |  |

## SCP0114_CAPA_LineMaster.spdLevel4_CellClick

진입점: this.spdLevel4.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58018598 | this.spdLevel4.CellClick | SCP0114_CAPA_LineMaster.cs:1149 |  | FLAG | this._currAssignRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-340b9ba3 | this.spdLevel4.CellClick | SCP0114_CAPA_LineMaster.cs:1150 |  | FLAG | this._currAssignColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-17ce893c | this.spdLevel4.CellClick | SCP0114_CAPA_LineMaster.cs:1154 | if (siLevel4 == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-587ba655 | this.spdLevel4.CellClick | SCP0114_CAPA_LineMaster.cs:1157 | if (siLevel4.IsLock(siLevel4.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b10803e5 | this.spdLevel4.CellClick | SCP0114_CAPA_LineMaster.cs:1159 |  | CALL_EXT | siLevel4.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b36480de | this.spdLevel4.CellClick | SCP0114_CAPA_LineMaster.cs:1160 | if (siLevel4.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4000d731 | this.spdLevel4.CellClick | SCP0114_CAPA_LineMaster.cs:1167 | if (e.Column == siLevel4.GetColumnIndex(DefColumns.FACTORY_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel4, e.Row, DefColumns.FACTORY_ID, dtFactorySpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cad798c2 | this.spdLevel4.CellClick | SCP0114_CAPA_LineMaster.cs:1168 | if (e.Column == siLevel4.GetColumnIndex(DefColumns.FACTORY_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel4, e.Row, DefColumns.FACTORY_NAME, dtFactorySpreadName, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0114_CAPA_LineMaster.SpdLevel4_CellDoubleClick

진입점: this.spdLevel4.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8993e3a | this.spdLevel4.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1800 | if (siLevel4.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1dc288fa | this.spdLevel4.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1804 | if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | divisionID | siLevel4.GetText(e.Row, siLevel4.GetColumnIndex(DefColumns.DIVISION_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-21934890 | this.spdLevel4.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1805 | if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level1MenuID | siLevel4.GetText(e.Row, siLevel4.GetColumnIndex(DefColumns.SITE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-2916edfb | this.spdLevel4.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1806 | if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level2MenuID | siLevel4.GetText(e.Row, siLevel4.GetColumnIndex(DefColumns.COMPANY_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-c94232e3 | this.spdLevel4.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1807 | if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level3MenuID | siLevel4.GetText(e.Row, siLevel4.GetColumnIndex(DefColumns.PLANT_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-fc1bfb37 | this.spdLevel4.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1808 | if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level4MenuID | siLevel4.GetText(e.Row, siLevel4.GetColumnIndex(DefColumns.FACTORY_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-13858b5d | this.spdLevel4.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1811 | if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _factoryId | siLevel4.GetText(e.Row, siLevel4.GetColumnIndex(DefColumns.FACTORY_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-ad6d692d | this.spdLevel4.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1812 | if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _factoryName | siLevel4.GetText(e.Row, siLevel4.GetColumnIndex(DefColumns.FACTORY_NAME)) | 화면 필드/플래그 변경 |  |  |  |
| AC-f5422089 | this.spdLevel4.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1031 | if (siLevel4.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-44085a79 | this.spdLevel4.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1035 | if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | divisionID | siLevel4.GetText(e.Row, siLevel4.GetColumnIndex(DefColumns.DIVISION_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-751cd5d3 | this.spdLevel4.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1036 | if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level1MenuID | siLevel4.GetText(e.Row, siLevel4.GetColumnIndex(DefColumns.SITE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-6e88476f | this.spdLevel4.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1037 | if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level2MenuID | siLevel4.GetText(e.Row, siLevel4.GetColumnIndex(DefColumns.COMPANY_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-bf2118be | this.spdLevel4.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1038 | if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level3MenuID | siLevel4.GetText(e.Row, siLevel4.GetColumnIndex(DefColumns.PLANT_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-79a1734c | this.spdLevel4.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1039 | if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level4MenuID | siLevel4.GetText(e.Row, siLevel4.GetColumnIndex(DefColumns.FACTORY_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-b448d0a3 | this.spdLevel4.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1042 | if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _factoryId | siLevel4.GetText(e.Row, siLevel4.GetColumnIndex(DefColumns.FACTORY_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-b90bbc76 | this.spdLevel4.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1043 | if (!siLevel4.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _factoryName | siLevel4.GetText(e.Row, siLevel4.GetColumnIndex(DefColumns.FACTORY_NAME)) | 화면 필드/플래그 변경 |  |  |  |

## SCP0114_CAPA_LineMaster.spdLevel5_CellClick

진입점: this.spdLevel5.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81164cec | this.spdLevel5.CellClick | SCP0114_CAPA_LineMaster.cs:1173 |  | FLAG | this._currAssignRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-b172b4fb | this.spdLevel5.CellClick | SCP0114_CAPA_LineMaster.cs:1174 |  | FLAG | this._currAssignColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-f6d834e6 | this.spdLevel5.CellClick | SCP0114_CAPA_LineMaster.cs:1178 | if (siLevel5 == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-86be2540 | this.spdLevel5.CellClick | SCP0114_CAPA_LineMaster.cs:1181 | if (siLevel5.IsLock(siLevel5.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a1f7d0d8 | this.spdLevel5.CellClick | SCP0114_CAPA_LineMaster.cs:1183 |  | CALL_EXT | siLevel5.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c882d030 | this.spdLevel5.CellClick | SCP0114_CAPA_LineMaster.cs:1184 | if (siLevel5.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e2ef1ea | this.spdLevel5.CellClick | SCP0114_CAPA_LineMaster.cs:1191 | if (e.Column == siLevel5.GetColumnIndex(DefColumns.LINE_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel5, e.Row, DefColumns.LINE_ID, dtLineSpreadCode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-410ba7ac | this.spdLevel5.CellClick | SCP0114_CAPA_LineMaster.cs:1192 | if (e.Column == siLevel5.GetColumnIndex(DefColumns.LINE_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siLevel5, e.Row, DefColumns.LINE_NAME, dtLineSpreadName, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0114_CAPA_LineMaster.SpdLevel5_CellDoubleClick

진입점: this.spdLevel5.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4baa3d1 | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1819 | if (siLevel5.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2a14c52d | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1823 | if (!siLevel5.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | divisionID | siLevel5.GetText(e.Row, siLevel5.GetColumnIndex(DefColumns.DIVISION_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-1c5b9755 | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1824 | if (!siLevel5.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level1MenuID | siLevel5.GetText(e.Row, siLevel5.GetColumnIndex(DefColumns.SITE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-c54cd2ff | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1825 | if (!siLevel5.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level2MenuID | siLevel5.GetText(e.Row, siLevel5.GetColumnIndex(DefColumns.COMPANY_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e087354 | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1826 | if (!siLevel5.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level3MenuID | siLevel5.GetText(e.Row, siLevel5.GetColumnIndex(DefColumns.PLANT_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-37a3736f | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1827 | if (!siLevel5.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level4MenuID | siLevel5.GetText(e.Row, siLevel5.GetColumnIndex(DefColumns.FACTORY_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd4efcad | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1828 | if (!siLevel5.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level5MenuID | siLevel5.GetText(e.Row, siLevel5.GetColumnIndex(DefColumns.LINE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-795ddc34 | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1830 | if (!siLevel5.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _lineId | siLevel5.GetText(e.Row, siLevel5.GetColumnIndex(DefColumns.LINE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-470a1609 | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1831 | if (!siLevel5.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _lineName | siLevel5.GetText(e.Row, siLevel5.GetColumnIndex(DefColumns.LINE_NAME)) | 화면 필드/플래그 변경 |  |  |  |
| AC-ec8a3518 | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1051 | if (siLevel5.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb0c9840 | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1055 | if (!siLevel5.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | divisionID | siLevel5.GetText(e.Row, siLevel5.GetColumnIndex(DefColumns.DIVISION_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-c165ff09 | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1056 | if (!siLevel5.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level1MenuID | siLevel5.GetText(e.Row, siLevel5.GetColumnIndex(DefColumns.SITE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-ad6b34ae | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1057 | if (!siLevel5.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level2MenuID | siLevel5.GetText(e.Row, siLevel5.GetColumnIndex(DefColumns.COMPANY_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-8643db30 | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1058 | if (!siLevel5.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level3MenuID | siLevel5.GetText(e.Row, siLevel5.GetColumnIndex(DefColumns.PLANT_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-108666f0 | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1059 | if (!siLevel5.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level4MenuID | siLevel5.GetText(e.Row, siLevel5.GetColumnIndex(DefColumns.FACTORY_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-241cc2ae | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1060 | if (!siLevel5.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | level5MenuID | siLevel5.GetText(e.Row, siLevel5.GetColumnIndex(DefColumns.LINE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-0b7430dc | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1062 | if (!siLevel5.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _lineId | siLevel5.GetText(e.Row, siLevel5.GetColumnIndex(DefColumns.LINE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-f7d0fa2b | this.spdLevel5.CellDoubleClick | SCP0114_CAPA_LineMaster.cs:1063 | if (!siLevel5.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | _lineName | siLevel5.GetText(e.Row, siLevel5.GetColumnIndex(DefColumns.LINE_NAME)) | 화면 필드/플래그 변경 |  |  |  |

## SCP0114_CAPA_LineMaster.spreadNow

진입점: this.spdLevel1.Change / this.spdLevel2.Change / this.spdLevel3.Change / this.spdLevel4.Change / this.spdLevel5.Change / InsertButton / DeleteButton / EditButton / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1167cc77 | this.spdLevel1.Change 외 8 | SCP0114_CAPA_LineMaster.cs:1610 |  | RETURN | return spreadLevel; |  | 처리 중단/반환 |  |  |  |

