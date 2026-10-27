# AS-IS 액션 대조표 — SCP0001

> 원천: `Doc/asisfacts/screens/SCP0001/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 481행 · 메서드 36 · 종류 DATA_OP 116 · GRID_SET 77 · GRID_LOCK 48 · FLAG 37 · GRID_INIT 34 · RETURN 32 · MESSAGE 22 · ENDPOINT 20 · UI_PROP 17 · POPUP 15 · CALL_EXT 13 · UI_MISC 10 · LIST_REBIND 10 · COMBO_DATA 9 · GRID_COMBO 8 · VALIDATE 6 · GRID_BIND 4 · GRID_STYLE 2 · VALUE_SET 1 · ⚠ 의미 확인 필요 13


## SCP0001_PlantSite.CheckValidation

진입점: SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eff8dca7 | SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetNam… | SCP0001_PlantSite.cs:1980 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (!string.IsNullOrWhiteSpace(sStorage)) ▸ if (sStorage == schkStorage) | CALL_EXT | spd.GetColumnText | (0, spd.GetColumnIndex(DefColumns.STORAGE_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-11abfe2d | SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetNam… | SCP0001_PlantSite.cs:1984 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (!string.IsNullOrWhiteSpace(sStorage)) ▸ if (sStorage == schkStorage) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e717212e | SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetNam… | SCP0001_PlantSite.cs:1985 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (!string.IsNullOrWhiteSpace(sStorage)) ▸ if (sStorage == schkStorage) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-36f4502a | SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetNam… | SCP0001_PlantSite.cs:2000 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ else of (!string.IsNullOrWhiteSpace(sStorage)) ▸ if (sFactoryID == schkFactoryID &… | CALL_EXT | spd.GetColumnText | (0, spd.GetColumnIndex(DefColumns.FACTORY_ID2)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b002a5fc | SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetNam… | SCP0001_PlantSite.cs:2000 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ else of (!string.IsNullOrWhiteSpace(sStorage)) ▸ if (sFactoryID == schkFactoryID &… | CALL_EXT | spd.GetColumnText | (0, spd.GetColumnIndex(DefColumns.OPERATION_ID2)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-234d4180 | SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetNam… | SCP0001_PlantSite.cs:2004 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ else of (!string.IsNullOrWhiteSpace(sStorage)) ▸ if (sFactoryID == schkFactoryID &… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6cf819b3 | SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetNam… | SCP0001_PlantSite.cs:2005 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ else of (!string.IsNullOrWhiteSpace(sStorage)) ▸ if (sFactoryID == schkFactoryID &… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-da03bb40 | SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetNam… | SCP0001_PlantSite.cs:2011 | try | FLAG | bCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-100fe399 | SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetNam… | SCP0001_PlantSite.cs:2013 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-aa3355ed | SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetNam… | SCP0001_PlantSite.cs:2015 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## SCP0001_PlantSite.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-700b5efb | this.Load | SCP0001_PlantSite.cs:322 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5d37cd22 | this.Load | SCP0001_PlantSite.cs:323 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9fed188d | this.Load | SCP0001_PlantSite.cs:326 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ff4f3dee | this.Load | SCP0001_PlantSite.cs:327 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtCustomer, SpdSheet.shtCustomer, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-429d9fc9 | this.Load | SCP0001_PlantSite.cs:328 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtLocationOSP, SpdSheet.shtLocationOSP, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9f68e5b6 | this.Load | SCP0001_PlantSite.cs:330 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-52e8f98e | this.Load | SCP0001_PlantSite.cs:331 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtCustomer) | 화면 필드/플래그 변경 |  |  |  |
| AC-9f307960 | this.Load | SCP0001_PlantSite.cs:332 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtLocationOSP) | 화면 필드/플래그 변경 |  |  |  |
| AC-4cdc9b8d | this.Load | SCP0001_PlantSite.cs:334 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d8c1d26b | this.Load | SCP0001_PlantSite.cs:337 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-52ec20dc | this.Load | SCP0001_PlantSite.cs:340 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtLocationOSP) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c2034ac1 | this.Load | SCP0001_PlantSite.cs:343 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-925f8478 | this.Load | SCP0001_PlantSite.cs:347 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0001_PlantSite.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81b553b9 | this.Load | SCP0001_PlantSite.cs:234 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-fb5d3ce6 | this.Load | SCP0001_PlantSite.cs:236 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-5a64636c | this.Load | SCP0001_PlantSite.cs:237 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-f7e7b2f0 | this.Load | SCP0001_PlantSite.cs:238 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-d3d9cb3f | this.Load | SCP0001_PlantSite.cs:240 |  | FLAG | dtProdTypeW | dtProdType.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-19b34a6a | this.Load | SCP0001_PlantSite.cs:240 |  | DATA_OP | dtProdType.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fdfa6c86 | this.Load | SCP0001_PlantSite.cs:241 |  | DATA_OP | dtProdTypeW.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-800b5c57 | this.Load | SCP0001_PlantSite.cs:242 |  | DATA_OP | drRow1["CODE"] | "W" | 행/컬럼 값 대입 |  |  |  |
| AC-33db319e | this.Load | SCP0001_PlantSite.cs:243 |  | DATA_OP | drRow1["NAME"] | "Warranty" | 행/컬럼 값 대입 |  |  |  |
| AC-78ef472a | this.Load | SCP0001_PlantSite.cs:244 |  | DATA_OP | dtProdTypeW.Rows.Add | (drRow1) | 데이터 객체 조작/조회 |  |  |  |
| AC-37944b81 | this.Load | SCP0001_PlantSite.cs:246 |  | FLAG | dtLogisticW | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-3647c656 | this.Load | SCP0001_PlantSite.cs:247 |  | DATA_OP | dtLogisticW.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-055955fc | this.Load | SCP0001_PlantSite.cs:248 |  | DATA_OP | dtLogisticW.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3220eae | this.Load | SCP0001_PlantSite.cs:249 |  | DATA_OP | dtLogisticW.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-119bab37 | this.Load | SCP0001_PlantSite.cs:250 |  | DATA_OP | drRow2["CODE"] | "A002" | 행/컬럼 값 대입 |  |  |  |
| AC-5f289817 | this.Load | SCP0001_PlantSite.cs:251 |  | DATA_OP | drRow2["NAME"] | "A002" | 행/컬럼 값 대입 |  |  |  |
| AC-93417f0a | this.Load | SCP0001_PlantSite.cs:252 |  | DATA_OP | dtLogisticW.Rows.Add | (drRow2) | 데이터 객체 조작/조회 |  |  |  |

## SCP0001_PlantSite.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f3a0373 | DeleteButton | SCP0001_PlantSite.cs:481 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-23557bc7 | DeleteButton | SCP0001_PlantSite.cs:484 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (string.IsNullOrWhiteSpace(action) \|\| action != CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee563c07 | DeleteButton | SCP0001_PlantSite.cs:486 | if (fps != null) ▸ if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0e05056b | DeleteButton | SCP0001_PlantSite.cs:491 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df10dcbc | DeleteButton | SCP0001_PlantSite.cs:494 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (string.IsNullOrWhiteSpace(action) \|\| action != CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9de5ce27 | DeleteButton | SCP0001_PlantSite.cs:496 | if (fps != null) ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0001_PlantSite.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31fe60c9 | Dispose | SCP0001_PlantSite.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0001_PlantSite.Dsdm_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f361fd24 | dsdm.Changed | SCP0001_PlantSite.cs:1544 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.LOCATION_CODE), sLocation) | 그리드 값 설정 |  |  |  |
| AC-cc50a5cc | dsdm.Changed | SCP0001_PlantSite.cs:1545 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.LOCATION_DESCRIPTION), sLocationDesc) | 그리드 값 설정 |  |  |  |
| AC-4a6b098a | dsdm.Changed | SCP0001_PlantSite.cs:1553 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.FACTORY_ID), factoryID) | 그리드 값 설정 |  |  |  |
| AC-b4b715d4 | dsdm.Changed | SCP0001_PlantSite.cs:1554 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.BUILDING), factoryDesc) | 그리드 값 설정 |  |  |  |
| AC-df152f13 | dsdm.Changed | SCP0001_PlantSite.cs:1556 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.OPERATION_ID), "") | 그리드 값 설정 |  |  |  |
| AC-d384fee8 | dsdm.Changed | SCP0001_PlantSite.cs:1557 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.OPERATION_ID2), "") | 그리드 값 설정 |  |  |  |
| AC-c8fd5902 | dsdm.Changed | SCP0001_PlantSite.cs:1558 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.STORAGE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-28508dc3 | dsdm.Changed | SCP0001_PlantSite.cs:1565 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.OPERATION_ID), operationID) | 그리드 값 설정 |  |  |  |
| AC-d4aaa7b3 | dsdm.Changed | SCP0001_PlantSite.cs:1566 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.STORAGE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-59b8bb2a | dsdm.Changed | SCP0001_PlantSite.cs:1583 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.FACTORY_ID), "") | 그리드 값 설정 |  |  |  |
| AC-b882cdb8 | dsdm.Changed | SCP0001_PlantSite.cs:1584 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.FACTORY_ID2), "") | 그리드 값 설정 |  |  |  |
| AC-9a8b5817 | dsdm.Changed | SCP0001_PlantSite.cs:1585 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.OPERATION_ID), "") | 그리드 값 설정 |  |  |  |
| AC-2cd5bc25 | dsdm.Changed | SCP0001_PlantSite.cs:1586 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.OPERATION_ID2), "") | 그리드 값 설정 |  |  |  |
| AC-57c0ef28 | dsdm.Changed | SCP0001_PlantSite.cs:1587 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ELECTRODE_TYPE), "") | 그리드 값 설정 |  |  |  |
| AC-fb3e20c7 | dsdm.Changed | SCP0001_PlantSite.cs:1596 | if (siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSheet.SheetName == … | FLAG | dtDetailSalesSite | Data.Common(Data.Type.SaleSiteByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-719c2cf8 | dsdm.Changed | SCP0001_PlantSite.cs:1596 | if (siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSheet.SheetName == … | COMBO_DATA | Data.Common | (Data.Type.SaleSiteByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2b6f4b1a | dsdm.Changed | SCP0001_PlantSite.cs:1599 | if (siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(DefColumns.SCM_SITE_ID), dtDetailSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SCP0001_PlantSite.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee1c2a1d | EditButton | SCP0001_PlantSite.cs:516 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c1e67290 | EditButton | SCP0001_PlantSite.cs:517 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-5a95fa13 | EditButton | SCP0001_PlantSite.cs:519 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.HQ_VENDOR_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9a332c14 | EditButton | SCP0001_PlantSite.cs:520 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDAT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ce151144 | EditButton | SCP0001_PlantSite.cs:521 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.FP_PLAN_PERIOD), siMain.GetColumnIndex(DefColumns.FP_PLA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0dc82f86 | EditButton | SCP0001_PlantSite.cs:522 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PACKER_ITEM_ID_SUFFIX), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-760b5e94 | EditButton | SCP0001_PlantSite.cs:523 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LINK_PLANT_SITE), siMain.GetColumnIndex(DefColumns.LINK_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f484feab | EditButton | SCP0001_PlantSite.cs:533 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ i… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PACKER_ITEM_ID_SUFFIX), iRow, siMain.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5107a99c | EditButton | SCP0001_PlantSite.cs:537 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ i… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PACKER_LINE_ACTIVE_YN), iRow, siMain.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d64d412a | EditButton | SCP0001_PlantSite.cs:542 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ e… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PACKER_LINE_ACTIVE_YN), iRow, siMain.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2dbf049c | EditButton | SCP0001_PlantSite.cs:548 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (siMain.IsLock(siMain.SheetName) == false… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PACKER_ITEM_ID_SUFFIX), iRow, siMain.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-81530d24 | EditButton | SCP0001_PlantSite.cs:549 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (siMain.IsLock(siMain.SheetName) == false… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PACKER_LINE_ACTIVE_YN), iRow, siMain.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7f0bea1b | EditButton | SCP0001_PlantSite.cs:558 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siMain.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f7677626 | EditButton | SCP0001_PlantSite.cs:559 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b61321e1 | EditButton | SCP0001_PlantSite.cs:562 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-22ef4760 | EditButton | SCP0001_PlantSite.cs:569 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (_bOutsourcingYn) | MESSAGE | MessageHelper.GMessageBox | ("MSG00168") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c8dd060c | EditButton | SCP0001_PlantSite.cs:570 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (_bOutsourcingYn) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7529991c | EditButton | SCP0001_PlantSite.cs:579 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtLocationOSP) ▸ if (!_bOutsourcingYn) | MESSAGE | MessageHelper.GMessageBox | ("MSG00224") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-61590812 | EditButton | SCP0001_PlantSite.cs:580 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtLocationOSP) ▸ if (!_bOutsourcingYn) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0d493c4 | EditButton | SCP0001_PlantSite.cs:584 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-00761e29 | EditButton | SCP0001_PlantSite.cs:588 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.LOCATION_CODE), siSub.GetColumnIndex(DefColumns.LOCATION_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0f0fcfc7 | EditButton | SCP0001_PlantSite.cs:589 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.FACTORY_ID), siSub.GetColumnIndex(DefColumns.FACTORY_ID),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7a300ecd | EditButton | SCP0001_PlantSite.cs:590 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.OPERATION_ID), siSub.GetColumnIndex(DefColumns.OPERATION_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a96680ab | EditButton | SCP0001_PlantSite.cs:591 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.CREATED_BY), siSub.GetColumnIndex(DefColumns.LAST_UPDATE_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-19e2cf43 | EditButton | SCP0001_PlantSite.cs:595 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSheet.SheetName ==… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.DIVISION_ID), siSub.GetColumnIndex(DefColumns.SHIP_TO_CIT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6e134334 | EditButton | SCP0001_PlantSite.cs:596 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSheet.SheetName ==… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siSub.GetColumnIndex(DefColumns.LAST_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-53e48212 | EditButton | SCP0001_PlantSite.cs:603 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (siSub.ActiveSheet.SheetNa… | MESSAGE | MessageHelper.GMessageBox | ("MSG00224") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc8ba4e0 | EditButton | SCP0001_PlantSite.cs:604 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (siSub.ActiveSheet.SheetNa… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-494ca191 | EditButton | SCP0001_PlantSite.cs:607 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (siSub.ActiveSheet.SheetNa… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.DIVISION_ID), siSub.GetColumnIndex(DefColumns.SITE_DESCRI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eb67d172 | EditButton | SCP0001_PlantSite.cs:608 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (siSub.ActiveSheet.SheetNa… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.CREATED_BY), siSub.GetColumnIndex(DefColumns.LAST_UPDATE_… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0001_PlantSite.FindData_LocationOSP

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtLocationOSP) ▸ else of (sOutsourcing == "N")] / SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == SpdSheet.shtCustomer) ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtLocationOSP) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-375c928f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:844 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-30c0e327 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:849 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9bc68e77 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:852 | try | CALL_EXT | CString.GetComboBoxValue | (cboValid.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-49462eb0 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:859 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ef703a22 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:864 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0001_GET_LOCATION_OSP") ⇒ SCP.SCP0001_GET_LOCATION_OSP | 엔드포인트 요청 생성 |  |  |  |
| AC-ff3cc19e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:865 | try | DATA_OP | request.Parameters["p_division_id"] | divisionID | 행/컬럼 값 대입 |  |  |  |
| AC-eb6f6559 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:866 | try | DATA_OP | request.Parameters["p_scm_site_id"] | scmSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-cccd55bc | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:867 | try | DATA_OP | request.Parameters["p_valid_yn"] | validYN | 행/컬럼 값 대입 |  |  |  |
| AC-f594588f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:869 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1113b3f8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:878 | try | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-eb0c620f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:879 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2dd443af | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:882 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2875bf16 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:885 | try | GRID_INIT | siSub.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-978e40df | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:891 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-23e1c633 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:896 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0001_PlantSite.FindData_Main

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75048c53 | FindButton 외 1 | SCP0001_PlantSite.cs:625 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-51838550 | FindButton 외 1 | SCP0001_PlantSite.cs:629 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-fa10bea0 | FindButton 외 1 | SCP0001_PlantSite.cs:629 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e872e572 | FindButton 외 1 | SCP0001_PlantSite.cs:632 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2db32dae | FindButton 외 1 | SCP0001_PlantSite.cs:639 | try | CALL_EXT | CString.GetComboBoxValue | (cboOutsourcing.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-db3276e2 | FindButton 외 1 | SCP0001_PlantSite.cs:640 | try | CALL_EXT | CString.GetComboBoxValue | (cboValid.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3dfac9c | FindButton 외 1 | SCP0001_PlantSite.cs:647 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-169eba0e | FindButton 외 1 | SCP0001_PlantSite.cs:648 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-54a9c16b | FindButton 외 1 | SCP0001_PlantSite.cs:652 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0001_GET_PLANT_SITE") ⇒ SCP.SCP0001_GET_PLANT_SITE | 엔드포인트 요청 생성 |  |  |  |
| AC-54c64b03 | FindButton 외 1 | SCP0001_PlantSite.cs:653 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-852a5223 | FindButton 외 1 | SCP0001_PlantSite.cs:654 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-15d0799a | FindButton 외 1 | SCP0001_PlantSite.cs:655 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-d34e5274 | FindButton 외 1 | SCP0001_PlantSite.cs:656 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | pPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-df494d1a | FindButton 외 1 | SCP0001_PlantSite.cs:657 | try ▸ lambda | DATA_OP | request.Parameters["p_osp_yn"] | outsourcingYN | 행/컬럼 값 대입 |  |  |  |
| AC-1b88e7b2 | FindButton 외 1 | SCP0001_PlantSite.cs:658 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | validYN | 행/컬럼 값 대입 |  |  |  |
| AC-1a92a687 | FindButton 외 1 | SCP0001_PlantSite.cs:659 | try ▸ lambda | DATA_OP | request.Parameters["p_new_yn"] | newYN | 행/컬럼 값 대입 |  |  |  |
| AC-56988558 | FindButton 외 1 | SCP0001_PlantSite.cs:661 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-58659ffb | FindButton 외 1 | SCP0001_PlantSite.cs:663 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9cbe8658 | FindButton 외 1 | SCP0001_PlantSite.cs:670 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6b82f808 | FindButton 외 1 | SCP0001_PlantSite.cs:671 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4b9d56de | FindButton 외 1 | SCP0001_PlantSite.cs:674 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b1ab437e | FindButton 외 1 | SCP0001_PlantSite.cs:677 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-273f377d | FindButton 외 1 | SCP0001_PlantSite.cs:695 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0001_PlantSite.FindData_Sub

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (sOutsourcing == "Y")] / SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fb74294 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:727 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8b770fe6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:732 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3092f2c0 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:735 | try | CALL_EXT | CString.GetComboBoxValue | (cboValid.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ab7d6c53 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:742 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-7a371af6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:747 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0001_GET_LOCATION") ⇒ SCP.SCP0001_GET_LOCATION | 엔드포인트 요청 생성 |  |  |  |
| AC-00999bb2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:748 | try | DATA_OP | request.Parameters["p_division_id"] | divisionID | 행/컬럼 값 대입 |  |  |  |
| AC-14a69057 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:749 | try | DATA_OP | request.Parameters["p_scm_site_id"] | scmSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-9b01ad74 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:750 | try | DATA_OP | request.Parameters["p_valid_yn"] | validYN | 행/컬럼 값 대입 |  |  |  |
| AC-8cc2bd2b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:752 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-19563527 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:761 | try | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-36aa0775 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:762 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5f0f839f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:765 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-27919a84 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:768 | try | GRID_INIT | siSub.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ae9e1d25 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:774 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-d04f2f8d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:779 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0001_PlantSite.FindData_SubCustomer

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer)] / SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdSheet.shtCustomer) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24d7b968 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:803 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA") ⇒ DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-c373755c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:804 |  | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-b948c8da | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:805 |  | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-4ad99ddf | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:806 |  | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-b5221e29 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:807 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bd9ac395 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:808 |  | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-95104a84 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:810 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7df73ddd | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:819 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-256116d9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:820 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-85637db9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:830 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.SOLD_TO)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-8c44f4e4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:831 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.SHIP_TO)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-c1e2efcf | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCP0001_PlantSite.cs:839 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0001_PlantSite.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c27c48b | this.Load | SCP0001_PlantSite.cs:214 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0001_PlantSite.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1293cd8 | this.Load | SCP0001_PlantSite.cs:258 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-9ff332e0 | this.Load | SCP0001_PlantSite.cs:261 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl1) | 권한 검사/설정 |  |  |  |
| AC-580b2325 | this.Load | SCP0001_PlantSite.cs:263 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9901e742 | this.Load | SCP0001_PlantSite.cs:266 |  | LIST_REBIND | cboOutsourcing.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-c25931f9 | this.Load | SCP0001_PlantSite.cs:267 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-91d2e905 | this.Load | SCP0001_PlantSite.cs:270 |  | VALUE_SET | cboValid.SelectedValue | "Y" | 컨트롤 값 설정 |  |  |  |

## SCP0001_PlantSite.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sOutsourcing == "Y")] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f904810 | this.Load 외 3 | SCP0001_PlantSite.cs:360 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-3e183cc8 | this.Load 외 3 | SCP0001_PlantSite.cs:391 | if (spreadInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantByDivision", dtPlantByDivision) | 목록 컨트롤 재구성 |  |  |  |
| AC-71bdd28a | this.Load 외 3 | SCP0001_PlantSite.cs:392 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-7338980b | this.Load 외 3 | SCP0001_PlantSite.cs:393 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1f95552f | this.Load 외 3 | SCP0001_PlantSite.cs:398 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-80f18d2f | this.Load 외 3 | SCP0001_PlantSite.cs:421 | if (spreadInfo.SheetName == SpdSheet.shtSub) | LIST_REBIND | SpreadInfo.SetComBoParam | ("Location", dtLocation) | 목록 컨트롤 재구성 |  |  |  |
| AC-b3d987a5 | this.Load 외 3 | SCP0001_PlantSite.cs:422 | if (spreadInfo.SheetName == SpdSheet.shtSub) | LIST_REBIND | SpreadInfo.SetComBoParam | ("BuildingByPlant", dtBuildingByPlant) | 목록 컨트롤 재구성 |  |  |  |
| AC-08aa859b | this.Load 외 3 | SCP0001_PlantSite.cs:423 | if (spreadInfo.SheetName == SpdSheet.shtSub) | LIST_REBIND | SpreadInfo.SetComBoParam | ("OperationByBuilding", dtOperation) | 목록 컨트롤 재구성 |  |  |  |
| AC-1f3670fa | this.Load 외 3 | SCP0001_PlantSite.cs:424 | if (spreadInfo.SheetName == SpdSheet.shtSub) | LIST_REBIND | SpreadInfo.SetComBoParam | ("StorageID", dtStorage) | 목록 컨트롤 재구성 |  |  |  |
| AC-e952a4e9 | this.Load 외 3 | SCP0001_PlantSite.cs:425 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-5ece068e | this.Load 외 3 | SCP0001_PlantSite.cs:426 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-66a2f3fa | this.Load 외 3 | SCP0001_PlantSite.cs:431 | if (spreadInfo.SheetName == SpdSheet.shtCustomer) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-5bcba571 | this.Load 외 3 | SCP0001_PlantSite.cs:447 | if (spreadInfo.SheetName == SpdSheet.shtCustomer) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-44a09a30 | this.Load 외 3 | SCP0001_PlantSite.cs:448 | if (spreadInfo.SheetName == SpdSheet.shtCustomer) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-40c5f331 | this.Load 외 3 | SCP0001_PlantSite.cs:453 | if (spreadInfo.SheetName == SpdSheet.shtLocationOSP) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-7476b60f | this.Load 외 3 | SCP0001_PlantSite.cs:454 | if (spreadInfo.SheetName == SpdSheet.shtLocationOSP) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantByDivision", dtPlantByDivisionAll) | 목록 컨트롤 재구성 |  |  |  |
| AC-536bfed6 | this.Load 외 3 | SCP0001_PlantSite.cs:455 | if (spreadInfo.SheetName == SpdSheet.shtLocationOSP) | LIST_REBIND | SpreadInfo.SetComBoParam | ("StorageID", dtStorageByDivPlant) | 목록 컨트롤 재구성 |  |  |  |
| AC-f64ae9b8 | this.Load 외 3 | SCP0001_PlantSite.cs:456 | if (spreadInfo.SheetName == SpdSheet.shtLocationOSP) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-e5b9a50b | this.Load 외 3 | SCP0001_PlantSite.cs:457 | if (spreadInfo.SheetName == SpdSheet.shtLocationOSP) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0001_PlantSite.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9b8faf8 | InsertButton | SCP0001_PlantSite.cs:1434 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-906429b7 | InsertButton | SCP0001_PlantSite.cs:1437 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-bf1aad29 | InsertButton | SCP0001_PlantSite.cs:1439 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | dtPlanPeriod.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ff96a6e8 | InsertButton | SCP0001_PlantSite.cs:1440 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | dtPlanPeriod.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1103672f | InsertButton | SCP0001_PlantSite.cs:1441 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | dtPlanPeriod.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8504e342 | InsertButton | SCP0001_PlantSite.cs:1444 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, "40") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d3aca00 | InsertButton | SCP0001_PlantSite.cs:1445 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.OSP_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-387981c8 | InsertButton | SCP0001_PlantSite.cs:1446 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.OPERATION_GROUP, "P") | 데이터 객체 조작/조회 |  |  |  |
| AC-df1ba237 | InsertButton | SCP0001_PlantSite.cs:1447 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-db41f34d | InsertButton | SCP0001_PlantSite.cs:1448 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.NEW_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-c9dc3e9f | InsertButton | SCP0001_PlantSite.cs:1449 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.SHIP_FROZEN, sShipFrozen) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa8af96e | InsertButton | SCP0001_PlantSite.cs:1450 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.PROD_FROZEN, sprodFrozen) | 데이터 객체 조작/조회 |  |  |  |
| AC-4625170c | InsertButton | SCP0001_PlantSite.cs:1452 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.FP_PLAN_PERIOD, sprodFrozen) | 데이터 객체 조작/조회 |  |  |  |
| AC-5df30a96 | InsertButton | SCP0001_PlantSite.cs:1453 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.BUILD_AHEAD, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-6eb79c51 | InsertButton | SCP0001_PlantSite.cs:1454 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.PACKER_LINE_ACTIVE_YN, "N") | 데이터 객체 조작/조회 |  |  |  |
| AC-9466e691 | InsertButton | SCP0001_PlantSite.cs:1456 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-874badba | InsertButton | SCP0001_PlantSite.cs:1458 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange3 | (insCell, siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.C… | 그리드 편집 잠금 전환 |  |  |  |
| AC-dd22567c | InsertButton | SCP0001_PlantSite.cs:1459 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.PLANT_ID), siMain.GetColumnIndex(DefColumns.PLA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-215dc3e9 | InsertButton | SCP0001_PlantSite.cs:1461 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-07736797 | InsertButton | SCP0001_PlantSite.cs:1462 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange3 | (insCell, siMain.GetColumnIndex(DefColumns.PLANT_NAME), siMain.GetColumnIndex(DefColumns.P… | 그리드 편집 잠금 전환 |  |  |  |
| AC-bb157742 | InsertButton | SCP0001_PlantSite.cs:1463 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.OSP_YN), siMain.GetColumnIndex(DefColumns.OSP_Y… | 그리드 편집 잠금/해제 |  |  |  |
| AC-387ca6e7 | InsertButton | SCP0001_PlantSite.cs:1464 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.HQ_VENDOR_CODE), siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cf26dc6d | InsertButton | SCP0001_PlantSite.cs:1465 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8ce0fa27 | InsertButton | SCP0001_PlantSite.cs:1466 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.FP_PLAN_PERIOD), siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2ddc6904 | InsertButton | SCP0001_PlantSite.cs:1468 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LINK_PLANT_SITE), siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fd6a15b7 | InsertButton | SCP0001_PlantSite.cs:1476 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-523084be | InsertButton | SCP0001_PlantSite.cs:1481 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-d6cdaac4 | InsertButton | SCP0001_PlantSite.cs:1482 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-cba2a696 | InsertButton | SCP0001_PlantSite.cs:1484 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.LOCATION_CODE), siSub.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-25369fbb | InsertButton | SCP0001_PlantSite.cs:1485 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.FACTORY_ID), siSub.GetColumnIndex(DefColumns.FAC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a8694512 | InsertButton | SCP0001_PlantSite.cs:1486 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.OPERATION_ID), siSub.GetColumnIndex(DefColumns.O… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6a57fc90 | InsertButton | SCP0001_PlantSite.cs:1487 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.CREATED_BY), siSub.GetColumnIndex(DefColumns.LAS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-47dce30a | InsertButton | SCP0001_PlantSite.cs:1491 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSh… | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-bf045e2e | InsertButton | SCP0001_PlantSite.cs:1493 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSh… | GRID_COMBO | siSub.SetCellTypeCombo | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5e6a9d53 | InsertButton | SCP0001_PlantSite.cs:1496 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSh… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetValue(siMai… | 그리드 값 설정 |  |  |  |
| AC-4042c093 | InsertButton | SCP0001_PlantSite.cs:1497 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSh… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SCM_SITE_ID), siMain.GetValue(siMai… | 그리드 값 설정 |  |  |  |
| AC-55280506 | InsertButton | SCP0001_PlantSite.cs:1499 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSh… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.DIVISION_ID), siSub.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-876d8bdb | InsertButton | SCP0001_PlantSite.cs:1500 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSh… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SOLD_TO_NAME), siSub.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c9a3bd4d | InsertButton | SCP0001_PlantSite.cs:1501 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSh… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SHIP_TO_NAME), siSub.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ef888755 | InsertButton | SCP0001_PlantSite.cs:1502 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSh… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siSub.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-731f963a | InsertButton | SCP0001_PlantSite.cs:1504 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSh… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SOLD_TO)].Ce… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-5223e8b6 | InsertButton | SCP0001_PlantSite.cs:1505 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSh… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SHIP_TO)].Ce… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-75e175da | InsertButton | SCP0001_PlantSite.cs:1507 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSh… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.REP), CAppSetting.StringN) | 그리드 값 설정 |  |  |  |
| AC-afd4d7e7 | InsertButton | SCP0001_PlantSite.cs:1508 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSh… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.VALID_YN), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-4416ed5a | InsertButton | SCP0001_PlantSite.cs:1512 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (siSub.Act… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetValue(siMai… | 그리드 값 설정 |  |  |  |
| AC-f67883ff | InsertButton | SCP0001_PlantSite.cs:1513 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (siSub.Act… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SCM_SITE_ID), siMain.GetValue(siMai… | 그리드 값 설정 |  |  |  |
| AC-1e21cc82 | InsertButton | SCP0001_PlantSite.cs:1514 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (siSub.Act… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SITE_DESCRIPTION), siMain.GetValue(… | 그리드 값 설정 |  |  |  |
| AC-8ca46671 | InsertButton | SCP0001_PlantSite.cs:1515 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (siSub.Act… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.VALID_YN), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-80b1b7e1 | InsertButton | SCP0001_PlantSite.cs:1517 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (siSub.Act… | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.DIVISION_ID), siSub.GetColumnIndex(DefColumns.DI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-742c5f14 | InsertButton | SCP0001_PlantSite.cs:1518 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (siSub.Act… | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.SCM_SITE_ID), siSub.GetColumnIndex(DefColumns.SI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dc1c28c8 | InsertButton | SCP0001_PlantSite.cs:1519 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (siSub.Act… | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.CREATED_BY), siSub.GetColumnIndex(DefColumns.LAS… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0001_PlantSite.RefreshDetailSalesSite

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6c7a3b4 | this.Load 외 1 | SCP0001_PlantSite.cs:300 |  | FLAG | dtDetailSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-2a3630cc | this.Load 외 1 | SCP0001_PlantSite.cs:300 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, division, "ALL") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0001_PlantSite.RefreshOperation

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cf92662 | this.Load 외 1 | SCP0001_PlantSite.cs:294 |  | FLAG | dtOperation | DBUtils.Filter(dtOperationAll, "DIVISION_ID = '" + division + "' AND SITE_ID = '" + pScmSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-702cb2ff | this.Load 외 1 | SCP0001_PlantSite.cs:294 |  | DATA_OP | DBUtils.Filter | (dtOperationAll, "DIVISION_ID = '" + division + "' AND SITE_ID = '" + pScmSiteID + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0001_PlantSite.RefreshPlant

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-def8124b | this.Load 외 1 | SCP0001_PlantSite.cs:287 |  | FLAG | dtPlantByDivision | DBUtils.Filter(dtPlantByDivisionAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-22c82abb | this.Load 외 1 | SCP0001_PlantSite.cs:287 |  | DATA_OP | DBUtils.Filter | (dtPlantByDivisionAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0001_PlantSite.RefreshPlantSite

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41ba7622 | this.Load 외 1 | SCP0001_PlantSite.cs:281 |  | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-dc6af829 | this.Load 외 1 | SCP0001_PlantSite.cs:281 |  | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0001_PlantSite.RefreshStorageByDivPlant

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7137430e | this.Load 외 1 | SCP0001_PlantSite.cs:305 |  | FLAG | dtStorageByDivPlant | DBUtils.Filter(dtStorageByDivPlantAll, "DIVISION_ID = '" + division + "'",true) | 화면 필드/플래그 변경 |  |  |  |
| AC-9b810258 | this.Load 외 1 | SCP0001_PlantSite.cs:305 |  | DATA_OP | DBUtils.Filter | (dtStorageByDivPlantAll, "DIVISION_ID = '" + division + "'",true) | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0001_PlantSite.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7803cb4 | SaveButton | SCP0001_PlantSite.cs:940 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-86cc9bb8 | SaveButton | SCP0001_PlantSite.cs:940 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-807f2d46 | SaveButton | SCP0001_PlantSite.cs:1001 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0001_SAVE_PLANT_SITE") ⇒ SCP.SCP0001_SAVE_PLANT_SITE | 엔드포인트 요청 생성 |  |  |  |
| AC-72811023 | SaveButton | SCP0001_PlantSite.cs:1006 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0ed4a454 | SaveButton | SCP0001_PlantSite.cs:1010 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-faf716a4 | SaveButton | SCP0001_PlantSite.cs:1011 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-fbdadfb4 | SaveButton | SCP0001_PlantSite.cs:1012 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-34462db1 | SaveButton | SCP0001_PlantSite.cs:1013 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-f12d8d47 | SaveButton | SCP0001_PlantSite.cs:1014 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_site_description"] | p_site_description | 행/컬럼 값 대입 |  |  |  |
| AC-5bb639d3 | SaveButton | SCP0001_PlantSite.cs:1015 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_country"] | p_country | 행/컬럼 값 대입 |  |  |  |
| AC-1f5149b9 | SaveButton | SCP0001_PlantSite.cs:1016 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_city"] | p_city | 행/컬럼 값 대입 |  |  |  |
| AC-741a590f | SaveButton | SCP0001_PlantSite.cs:1017 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-d7404d7e | SaveButton | SCP0001_PlantSite.cs:1018 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_vmi_yn"] | p_vmi_yn | 행/컬럼 값 대입 |  |  |  |
| AC-afabaca8 | SaveButton | SCP0001_PlantSite.cs:1019 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-4100852c | SaveButton | SCP0001_PlantSite.cs:1020 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_new_yn"] | p_new_yn | 행/컬럼 값 대입 |  |  |  |
| AC-4cbbddf6 | SaveButton | SCP0001_PlantSite.cs:1021 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_frozen_type"] | p_frozen_type | 행/컬럼 값 대입 |  |  |  |
| AC-f0d1f213 | SaveButton | SCP0001_PlantSite.cs:1022 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_ship_frozen"] | p_ship_frozen | 행/컬럼 값 대입 |  |  |  |
| AC-3f56c6f5 | SaveButton | SCP0001_PlantSite.cs:1023 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_prod_frozen"] | p_prod_frozen | 행/컬럼 값 대입 |  |  |  |
| AC-4d3ce4ff | SaveButton | SCP0001_PlantSite.cs:1024 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_build_ahead"] | p_build_ahead | 행/컬럼 값 대입 |  |  |  |
| AC-1234e11e | SaveButton | SCP0001_PlantSite.cs:1025 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_fp_plan_period"] | p_fp_plan_period | 행/컬럼 값 대입 |  |  |  |
| AC-6273f5bb | SaveButton | SCP0001_PlantSite.cs:1026 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-3d66ed05 | SaveButton | SCP0001_PlantSite.cs:1027 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-6cff62bc | SaveButton | SCP0001_PlantSite.cs:1028 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-f36f0b86 | SaveButton | SCP0001_PlantSite.cs:1029 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_company_id"] | p_Company_id | 행/컬럼 값 대입 |  |  |  |
| AC-ca33ea55 | SaveButton | SCP0001_PlantSite.cs:1030 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_logistic_plant_id"] | p_logistic_plnat | 행/컬럼 값 대입 |  |  |  |
| AC-eddfd973 | SaveButton | SCP0001_PlantSite.cs:1031 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_packer_item_id_suffix"] | p_packer_item_id_suffix | 행/컬럼 값 대입 |  |  |  |
| AC-53a7a49a | SaveButton | SCP0001_PlantSite.cs:1032 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_hq_vendor_code"] | p_hq_vendor_code | 행/컬럼 값 대입 |  |  |  |
| AC-edc20406 | SaveButton | SCP0001_PlantSite.cs:1033 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_packer_line_active_yn"] | p_packer_line_active_yn | 행/컬럼 값 대입 |  |  |  |
| AC-09ce7329 | SaveButton | SCP0001_PlantSite.cs:1035 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_scm_vendor_name"] | p_scm_vendor_name | 행/컬럼 값 대입 |  |  |  |
| AC-786cf1a7 | SaveButton | SCP0001_PlantSite.cs:1036 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_osp_yn_gb"] | p_osp_yn_gb | 행/컬럼 값 대입 |  |  |  |
| AC-11882099 | SaveButton | SCP0001_PlantSite.cs:1038 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_link_plant_site_id"] | p_link_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-6e26c90d | SaveButton | SCP0001_PlantSite.cs:1040 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f0e720e5 | SaveButton | SCP0001_PlantSite.cs:1040 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-be592392 | SaveButton | SCP0001_PlantSite.cs:1049 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-887fa160 | SaveButton | SCP0001_PlantSite.cs:1058 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-27ab9109 | SaveButton | SCP0001_PlantSite.cs:1090 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-7d2cdabf | SaveButton | SCP0001_PlantSite.cs:1090 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bccf72b3 | SaveButton | SCP0001_PlantSite.cs:1092 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!CheckValidation(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9fecbad3 | SaveButton | SCP0001_PlantSite.cs:1113 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) ▸… | CALL_EXT | siSub.GetColumnText | (0, siSub.GetColumnIndex(DefColumns.FACTORY_ID2)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa36809d | SaveButton | SCP0001_PlantSite.cs:1117 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d83194b | SaveButton | SCP0001_PlantSite.cs:1118 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) ▸… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c57fe685 | SaveButton | SCP0001_PlantSite.cs:1124 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) ▸… | CALL_EXT | siSub.GetColumnText | (0, siSub.GetColumnIndex(DefColumns.OPERATION_ID2)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-60a28f79 | SaveButton | SCP0001_PlantSite.cs:1128 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc3f51b5 | SaveButton | SCP0001_PlantSite.cs:1129 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ for (i <= siSub.GetMaxRowIndex()) ▸… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8ba4050 | SaveButton | SCP0001_PlantSite.cs:1167 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0001_SAVE_LOCATION") ⇒ SCP.SCP0001_SAVE_LOCATION | 엔드포인트 요청 생성 |  |  |  |
| AC-40d9e4f7 | SaveButton | SCP0001_PlantSite.cs:1172 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fc025d24 | SaveButton | SCP0001_PlantSite.cs:1176 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-a9e501a7 | SaveButton | SCP0001_PlantSite.cs:1177 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_location_seq"] | p_location_seq | 행/컬럼 값 대입 |  |  |  |
| AC-9bfebea0 | SaveButton | SCP0001_PlantSite.cs:1178 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e4cd7854 | SaveButton | SCP0001_PlantSite.cs:1179 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-5ac19537 | SaveButton | SCP0001_PlantSite.cs:1180 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-1e895526 | SaveButton | SCP0001_PlantSite.cs:1181 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_location_code"] | p_location_code | 행/컬럼 값 대입 |  |  |  |
| AC-d83615c5 | SaveButton | SCP0001_PlantSite.cs:1182 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_location_description"] | p_location_description | 행/컬럼 값 대입 |  |  |  |
| AC-0d8fb7c8 | SaveButton | SCP0001_PlantSite.cs:1183 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-c0354e48 | SaveButton | SCP0001_PlantSite.cs:1184 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-96e969ee | SaveButton | SCP0001_PlantSite.cs:1185 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-a365aec8 | SaveButton | SCP0001_PlantSite.cs:1186 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_storage_id"] | p_storage_id | 행/컬럼 값 대입 |  |  |  |
| AC-6ae66fab | SaveButton | SCP0001_PlantSite.cs:1188 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_ssp_storage_id"] | p_ssp_storage_id | 행/컬럼 값 대입 |  |  |  |
| AC-5f66afea | SaveButton | SCP0001_PlantSite.cs:1190 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-210ed8ee | SaveButton | SCP0001_PlantSite.cs:1191 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-97c387a3 | SaveButton | SCP0001_PlantSite.cs:1192 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-753fe114 | SaveButton | SCP0001_PlantSite.cs:1193 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-1dd3b5bd | SaveButton | SCP0001_PlantSite.cs:1195 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a6ab2234 | SaveButton | SCP0001_PlantSite.cs:1195 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-e99729f4 | SaveButton | SCP0001_PlantSite.cs:1204 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ if (t.Success) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-78355753 | SaveButton | SCP0001_PlantSite.cs:1213 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ if (t.Success) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-07cd66fa | SaveButton | SCP0001_PlantSite.cs:1220 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6cbe3611 | SaveButton | SCP0001_PlantSite.cs:1236 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-21460dc7 | SaveButton | SCP0001_PlantSite.cs:1236 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f2ac5927 | SaveButton | SCP0001_PlantSite.cs:1251 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | MESSAGE | MessageHelper.GMessageBox | ("MSG00120") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7671d560 | SaveButton | SCP0001_PlantSite.cs:1252 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c03a769b | SaveButton | SCP0001_PlantSite.cs:1294 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ SCP.SCP0001_SAVE_PLANT_SITE_CUSTOMER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-e9f2178d | SaveButton | SCP0001_PlantSite.cs:1295 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-10181f22 | SaveButton | SCP0001_PlantSite.cs:1296 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-0f586d68 | SaveButton | SCP0001_PlantSite.cs:1297 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-df020411 | SaveButton | SCP0001_PlantSite.cs:1298 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | DATA_OP | request.Parameters["p_soldto_code"] | sSoldTo | 행/컬럼 값 대입 |  |  |  |
| AC-b496b78f | SaveButton | SCP0001_PlantSite.cs:1299 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | DATA_OP | request.Parameters["p_soldto_description"] | sSoldToDesc | 행/컬럼 값 대입 |  |  |  |
| AC-81162401 | SaveButton | SCP0001_PlantSite.cs:1300 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | DATA_OP | request.Parameters["p_shipto_code"] | sShipTo | 행/컬럼 값 대입 |  |  |  |
| AC-46863981 | SaveButton | SCP0001_PlantSite.cs:1301 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | DATA_OP | request.Parameters["p_shipto_description"] | sShipToDesc | 행/컬럼 값 대입 |  |  |  |
| AC-133ed6aa | SaveButton | SCP0001_PlantSite.cs:1302 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | DATA_OP | request.Parameters["p_rep_yn"] | sRepYN | 행/컬럼 값 대입 |  |  |  |
| AC-343cd6bd | SaveButton | SCP0001_PlantSite.cs:1303 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-ba430189 | SaveButton | SCP0001_PlantSite.cs:1304 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-1f284db0 | SaveButton | SCP0001_PlantSite.cs:1306 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b8123759 | SaveButton | SCP0001_PlantSite.cs:1311 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-639c7fb6 | SaveButton | SCP0001_PlantSite.cs:1315 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cfa0ac56 | SaveButton | SCP0001_PlantSite.cs:1329 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fbb9e743 | SaveButton | SCP0001_PlantSite.cs:1338 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ if (siSub.SheetName == SpdShee… | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a1dab966 | SaveButton | SCP0001_PlantSite.cs:1357 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == Sp… | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-d5cf982f | SaveButton | SCP0001_PlantSite.cs:1357 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == Sp… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3fbd95d | SaveButton | SCP0001_PlantSite.cs:1383 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == Sp… | ENDPOINT | new FoxDataRequest | ("SCP.SCP0001_SAVE_LOCATION_OSP") ⇒ SCP.SCP0001_SAVE_LOCATION_OSP | 엔드포인트 요청 생성 |  |  |  |
| AC-86daa708 | SaveButton | SCP0001_PlantSite.cs:1388 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == Sp… | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ce841bdc | SaveButton | SCP0001_PlantSite.cs:1392 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == Sp… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d2949888 | SaveButton | SCP0001_PlantSite.cs:1393 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == Sp… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2185d8ac | SaveButton | SCP0001_PlantSite.cs:1394 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == Sp… | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-4d725c80 | SaveButton | SCP0001_PlantSite.cs:1395 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == Sp… | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-9a46ff4b | SaveButton | SCP0001_PlantSite.cs:1396 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == Sp… | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-8b7cb748 | SaveButton | SCP0001_PlantSite.cs:1397 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == Sp… | DATA_OP | request.Parameters["p_storage_id"] | p_storage_id | 행/컬럼 값 대입 |  |  |  |
| AC-f34c470a | SaveButton | SCP0001_PlantSite.cs:1398 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == Sp… | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-294143d5 | SaveButton | SCP0001_PlantSite.cs:1399 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == Sp… | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-faef5945 | SaveButton | SCP0001_PlantSite.cs:1401 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == Sp… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-171fbe22 | SaveButton | SCP0001_PlantSite.cs:1401 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == Sp… | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-47d91e9c | SaveButton | SCP0001_PlantSite.cs:1410 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == Sp… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9514435d | SaveButton | SCP0001_PlantSite.cs:1419 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.SheetName == SpdSheet.shtSub) ▸ else of (siSub.SheetName == Sp… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0001_PlantSite.SetImageCell

진입점: FindButton [try] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7704aa99 | FindButton [try] 외 2 | SCP0001_PlantSite.cs:703 | for (iRow < siMain.ActiveSheet.RowCount) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.COUNTRY)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-989de424 | FindButton [try] 외 2 | SCP0001_PlantSite.cs:704 | for (iRow < siMain.ActiveSheet.RowCount) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.CITY)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SCP0001_PlantSite.SetWarranty

진입점: FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e19f48a | FindButton [try] 외 1 | SCP0001_PlantSite.cs:716 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (operationG == "W") | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), dtProdTypeW) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2b6a77d5 | FindButton [try] 외 1 | SCP0001_PlantSite.cs:717 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (operationG == "W") | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.LOGISTIC_PLANT_ID), dtLogisticW) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SCP0001_PlantSite.shtCustomerDataModel_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4d34464 | dsdm.Changed | SCP0001_PlantSite.cs:2039 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName == DefColumns.REP) ▸ if (iRepYnCnt > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00149") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f0eaa1a4 | dsdm.Changed | SCP0001_PlantSite.cs:2040 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName == DefColumns.REP) ▸ if (iRepYnCnt > 1) | GRID_SET | siSub.SetValue | (e.Row, e.Column, "N") | 그리드 값 설정 |  |  |  |
| AC-5c0b3c95 | dsdm.Changed | SCP0001_PlantSite.cs:2041 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName == DefColumns.REP) ▸ if (iRepYnCnt > 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0001_PlantSite.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aaa73dd3 | this.spdMain.CellClick | SCP0001_PlantSite.cs:1608 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-716a613e | this.spdMain.CellClick | SCP0001_PlantSite.cs:1616 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PLAN… | POPUP | new SCM0002_VendorPopup | () | 팝업/폼 생성 |  |  |  |
| AC-eb694662 | this.spdMain.CellClick | SCP0001_PlantSite.cs:1618 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PLAN… | UI_PROP | popup.Width | 850 | 속성 Width 설정 |  |  |  |
| AC-15a6bce3 | this.spdMain.CellClick | SCP0001_PlantSite.cs:1619 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PLAN… | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-9a087597 | this.spdMain.CellClick | SCP0001_PlantSite.cs:1620 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PLAN… | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-07490f10 | this.spdMain.CellClick | SCP0001_PlantSite.cs:1622 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PLAN… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-081c13bb | this.spdMain.CellClick | SCP0001_PlantSite.cs:1627 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PLAN… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID), popup.VendorCode) | 그리드 값 설정 |  |  |  |
| AC-3750fa18 | this.spdMain.CellClick | SCP0001_PlantSite.cs:1628 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PLAN… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_NAME), popup.VendorName) | 그리드 값 설정 |  |  |  |
| AC-4020dad1 | this.spdMain.CellClick | SCP0001_PlantSite.cs:1629 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PLAN… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), popup.VendorCode + "_" + divisionId… | 그리드 값 설정 |  |  |  |
| AC-cbb35f57 | this.spdMain.CellClick | SCP0001_PlantSite.cs:1630 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PLAN… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID), popup.CompanyID) | 그리드 값 설정 |  |  |  |
| AC-f9a68873 | this.spdMain.CellClick | SCP0001_PlantSite.cs:1637 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.HQ_VENDOR_CODE_NAME)) | POPUP | new SCM0002_VendorPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fdb9d1f7 | this.spdMain.CellClick | SCP0001_PlantSite.cs:1639 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.HQ_VENDOR_CODE_NAME)) | UI_PROP | popup.Width | 850 | 속성 Width 설정 |  |  |  |
| AC-3822578d | this.spdMain.CellClick | SCP0001_PlantSite.cs:1640 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.HQ_VENDOR_CODE_NAME)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-f6e21cf3 | this.spdMain.CellClick | SCP0001_PlantSite.cs:1641 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.HQ_VENDOR_CODE_NAME)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-79544353 | this.spdMain.CellClick | SCP0001_PlantSite.cs:1643 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.HQ_VENDOR_CODE_NAME)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6c070220 | this.spdMain.CellClick | SCP0001_PlantSite.cs:1648 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.HQ_VENDOR_CODE_NAME)) ▸ if (popup.ShowDialo… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.HQ_VENDOR_CODE), popup.VendorCode) | 그리드 값 설정 |  |  |  |
| AC-9036e430 | this.spdMain.CellClick | SCP0001_PlantSite.cs:1649 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.HQ_VENDOR_CODE_NAME)) ▸ if (popup.ShowDialo… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.HQ_VENDOR_CODE_NAME), popup.VendorName) | 그리드 값 설정 |  |  |  |
| AC-dfae78ad | this.spdMain.CellClick | SCP0001_PlantSite.cs:1658 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.LINK_PLANT_SITE_CODE)) | COMBO_DATA | Data_SCP.CallBizCommonDataAll | ("LINK_PLANT_SITE_CODE", scmSiteId, divisionId) ⇒ biz:CommonData.CommonDataList_SCP_ALL [code=LINK_PLANT_SITE_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e80485a2 | this.spdMain.CellClick | SCP0001_PlantSite.cs:1660 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.LINK_PLANT_SITE_CODE)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.LINK_PLANT_SITE_CODE), dtLinkPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SCP0001_PlantSite.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-329497bd | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1671 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-70ab4a74 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1673 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | divisionID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ff90c8ca | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1674 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | scmSiteID | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-dcc6d87a | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1677 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | plantID | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b4f517d | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1678 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | prodType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-069703e4 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1680 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | dtBuildingByPlant | Data.Common(Data.Type.BuildingByPlant, false, plantID) ⇒ biz:CommonData.CommonDataList [code=BuildingByPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-5b01a87c | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1680 | if (siMain.IsLock(siMain.SheetName) == true) | COMBO_DATA | Data.Common | (Data.Type.BuildingByPlant, false, plantID) ⇒ biz:CommonData.CommonDataList [code=BuildingByPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-26b27c30 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1685 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | _bOutsourcingYn | false | 화면 필드/플래그 변경 |  |  |  |
| AC-950ec97f | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1691 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | dtStorage | Data.Common(Data.Type.StorageID, false, divisionID, sPlant) ⇒ biz:CommonData.CommonDataList [code=StorageID] | 화면 필드/플래그 변경 |  |  |  |
| AC-c1074d47 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1691 | if (siMain.IsLock(siMain.SheetName) == true) | COMBO_DATA | Data.Common | (Data.Type.StorageID, false, divisionID, sPlant) ⇒ biz:CommonData.CommonDataList [code=StorageID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7c781a87 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1693 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | dtLocation | Data.Common(Data.Type.Location, false, prodType) ⇒ biz:CommonData.CommonDataList [code=Location] | 화면 필드/플래그 변경 |  |  |  |
| AC-baf4a139 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1693 | if (siMain.IsLock(siMain.SheetName) == true) | COMBO_DATA | Data.Common | (Data.Type.Location, false, prodType) ⇒ biz:CommonData.CommonDataList [code=Location] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-807311d9 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1695 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | dtOperation | Data.Common(Data.Type.OperationByBuilding, false, divisionID, scmSiteID, "") ⇒ biz:CommonData.CommonDataList [code=OperationByBuilding] | 화면 필드/플래그 변경 |  |  |  |
| AC-f58cda49 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1695 | if (siMain.IsLock(siMain.SheetName) == true) | COMBO_DATA | Data.Common | (Data.Type.OperationByBuilding, false, divisionID, scmSiteID, "") ⇒ biz:CommonData.CommonDataList [code=OperationByBuilding] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-200c4eba | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1697 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | iSelRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-30fa012c | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1698 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | iSelCol | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-26ce4662 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1701 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (string.IsNullOrWhiteSpace(_sActiveSheetName)) | FLAG | _sActiveSheetName | siSub.ActiveSheet.SheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-8adb93e1 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1703 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | bCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-73568320 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1705 | if (siMain.IsLock(siMain.SheetName) == true) | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d42d0587 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1706 | if (siMain.IsLock(siMain.SheetName) == true) | GRID_INIT | siSub.ChangeActiveSheet | (SpdSheet.shtSub) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6495cb5f | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1714 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (sOutsourcing == "Y") | FLAG | _bOutsourcingYn | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b0435f94 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1723 | if (siMain.IsLock(siMain.SheetName) == true) | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cd07485b | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1724 | if (siMain.IsLock(siMain.SheetName) == true) | GRID_INIT | siSub.ChangeActiveSheet | (SpdSheet.shtCustomer) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0e6e4059 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1733 | if (siMain.IsLock(siMain.SheetName) == true) | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtLocationOSP) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f2088403 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1734 | if (siMain.IsLock(siMain.SheetName) == true) | GRID_INIT | siSub.ChangeActiveSheet | (SpdSheet.shtLocationOSP) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-907de1d7 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1743 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtLocationOSP) ▸ if (sOutsourcing == "N") | FLAG | _bOutsourcingYn | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6dcb3ff5 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1748 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtLocationOSP) ▸ else of (sOutsourcing == "N") | FLAG | _bOutsourcingYn | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e6d24b6f | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1753 | if (siMain.IsLock(siMain.SheetName) == true) | GRID_INIT | siSub.ChangeSheet | (_sActiveSheetName) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-29661693 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1754 | if (siMain.IsLock(siMain.SheetName) == true) | GRID_INIT | siSub.ChangeActiveSheet | (_sActiveSheetName) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c7663d27 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1756 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | bCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-26f33700 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1766 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.COUNTRY) \|\| e.Column == siMain.GetCol… | POPUP | popCity.Form_Load | (false, sCountry, sCity) | 팝업 초기화(인자 전달) |  |  |  |
| AC-b3427077 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1767 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.COUNTRY) \|\| e.Column == siMain.GetCol… | UI_PROP | popCity.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-846d584d | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1768 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.COUNTRY) \|\| e.Column == siMain.GetCol… | POPUP | popCity.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7461d49e | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1773 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.COUNTRY) \|\| e.Column == siMain.GetCol… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.COUNTRY), sCountry) | 그리드 값 설정 |  |  |  |
| AC-c568aba2 | this.spdMain.CellDoubleClick | SCP0001_PlantSite.cs:1774 | else of (siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.COUNTRY) \|\| e.Column == siMain.GetCol… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CITY), sCity) | 그리드 값 설정 |  |  |  |

## SCP0001_PlantSite.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9a28087 | this.spdMain.ComboSelChange | SCP0001_PlantSite.cs:1817 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)) ▸ if (!string.IsNullOrEmp… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), vendorCode + "_" + divisionID + "-"… | 그리드 값 설정 |  |  |  |
| AC-739b2ef0 | this.spdMain.ComboSelChange | SCP0001_PlantSite.cs:1829 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)) ▸ if (e.Column == si… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PACKER_ITEM_ID_SUFFIX), e.Row, siMain.GetColumnIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-171f8fe9 | this.spdMain.ComboSelChange | SCP0001_PlantSite.cs:1832 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)) ▸ if (e.Column == si… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PACKER_ITEM_ID_SUFFIX), e.Row, siMain.GetColumnIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c2faf770 | this.spdMain.ComboSelChange | SCP0001_PlantSite.cs:1835 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)) ▸ if (e.Column == si… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), vendorCode + "_" + divisionID + "-"… | 그리드 값 설정 |  |  |  |
| AC-7ed0bdce | this.spdMain.ComboSelChange | SCP0001_PlantSite.cs:1844 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)) ▸ else of (e.Column … | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PACKER_LINE_ACTIVE_YN), e.Row, siMain.GetColumnIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b3dc3c21 | this.spdMain.ComboSelChange | SCP0001_PlantSite.cs:1848 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)) ▸ else of (e.Column … | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PACKER_LINE_ACTIVE_YN), e.Row, siMain.GetColumnIn… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0001_PlantSite.SpdMain_KeyPress

진입점: this.spdMain.KeyPress / this.spdSub.KeyPress

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-930f4353 | this.spdMain.KeyPress 외 1 | SCP0001_PlantSite.cs:207 | if (!fps.ActiveSheet.Cells[fps.ActiveSheet.ActiveRow.Index, fps.ActiveSheet.ActiveColumn.Index].Locked) ▸ if (fps.ActiveSheet.Columns[fps.Ac… | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |

## SCP0001_PlantSite.spdMainDsdm_Changed

진입점: dsdmMain.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2e97980 | dsdmMain.Changed | SCP0001_PlantSite.cs:2254 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FP_PLAN_PERIOD), sProdFozen) | 그리드 값 설정 |  |  |  |
| AC-3894b39d | dsdmMain.Changed | SCP0001_PlantSite.cs:2261 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.HQ_VENDOR_CODE), "") | 그리드 값 설정 |  |  |  |

## SCP0001_PlantSite.SpdSub_ActiveSheetChanged

진입점: spdSub.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-040d6754 | spdSub.ActiveSheetChanged | SCP0001_PlantSite.cs:2109 | if (sender != null && !bCheck) | FLAG | _sActiveSheetName | ((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName | 화면 필드/플래그 변경 |  |  |  |

## SCP0001_PlantSite.spdSub_ActiveSheetChanging

진입점: this.spdSub.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c634206 | this.spdSub.ActiveSheetChanging | SCP0001_PlantSite.cs:2099 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.ActivatedSheetIndex | siSub.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-8d8b2280 | this.spdSub.ActiveSheetChanging | SCP0001_PlantSite.cs:2101 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f00b81fb | this.spdSub.ActiveSheetChanging | SCP0001_PlantSite.cs:2102 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0001_PlantSite.spdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f852cd3e | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2116 | if (!siSub.IsLock(siSub.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-49619946 | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2130 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | POPUP | new SCM0002_PlantCustomerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d466509b | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2132 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | POPUP | popCustomer.Form_Load | (false, division, sSoldToCode, sShipToCode) | 팝업 초기화(인자 전달) |  |  |  |
| AC-73158619 | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2133 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | UI_PROP | popCustomer.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-eb76da4d | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2134 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | POPUP | popCustomer.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-85b8b75c | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2143 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SOLD_TO), popCustomer.SoldToCode) | 그리드 값 설정 |  |  |  |
| AC-ddc06764 | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2144 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SOLD_TO_NAME), popCustomer.SoldToDesc) | 그리드 값 설정 |  |  |  |
| AC-aebdb2d1 | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2145 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SHIP_TO), popCustomer.ShipToCode) | 그리드 값 설정 |  |  |  |
| AC-be6ae265 | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2146 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SHIP_TO_NAME), popCustomer.ShipToDesc) | 그리드 값 설정 |  |  |  |
| AC-605db110 | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2147 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SHIP_TO_REGION), popCustomer.ShiptoRegion) | 그리드 값 설정 |  |  |  |
| AC-35cb1a92 | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2148 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SHIP_TO_CITY), popCustomer.ShiptoCity) | 그리드 값 설정 |  |  |  |
| AC-8a78684e | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2150 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | DATA_OP | (siSub.SpreadObject.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-96659728 | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2156 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | CALL_EXT | siSub.GetColumnText | (e.Row, siSub.GetColumnIndex(DefColumns.DIVISION_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ee1eac9 | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2157 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | CALL_EXT | siSub.GetColumnText | (e.Row, siSub.GetColumnIndex(DefColumns.SCM_SITE_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd2096d0 | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2158 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | CALL_EXT | siSub.GetColumnText | (e.Row, siSub.GetColumnIndex(DefColumns.SOLD_TO)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a86caed | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2159 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | CALL_EXT | siSub.GetColumnText | (e.Row, siSub.GetColumnIndex(DefColumns.SHIP_TO)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6133ae3f | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2162 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SOLD_TO), "") | 그리드 값 설정 |  |  |  |
| AC-4290d67c | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2163 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SOLD_TO_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-3aad0156 | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2164 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SHIP_TO), "") | 그리드 값 설정 |  |  |  |
| AC-79e97e7b | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2165 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SHIP_TO_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-4f0b838a | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2166 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SHIP_TO_REGION), "") | 그리드 값 설정 |  |  |  |
| AC-869bd2e0 | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2167 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SHIP_TO_CITY), "") | 그리드 값 설정 |  |  |  |
| AC-06635ed4 | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2169 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4742a2bc | this.spdSub.CellDoubleClick | SCP0001_PlantSite.cs:2170 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSub.G… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0001_PlantSite.SpdSub_ClipboardPasted

진입점: this.spdSub.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc86c58e | this.spdSub.ClipboardPasted | SCP0001_PlantSite.cs:2211 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ for (iRow < e.CellRange.Row + e.CellRang… | DATA_OP | dtLocation.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-21a9f4a2 | this.spdSub.ClipboardPasted | SCP0001_PlantSite.cs:2212 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ for (iRow < e.CellRange.Row + e.CellRang… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.LOCATION_CODE2), codeVal) | 그리드 값 설정 |  |  |  |
| AC-73aaeaf9 | this.spdSub.ClipboardPasted | SCP0001_PlantSite.cs:2213 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ for (iRow < e.CellRange.Row + e.CellRang… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.LOCATION_CODE), codeVal) | 그리드 값 설정 |  |  |  |
| AC-cfa4bd21 | this.spdSub.ClipboardPasted | SCP0001_PlantSite.cs:2218 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ for (iRow < e.CellRange.Row + e.CellRang… | DATA_OP | dtBuildingByPlant.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8d9a0154 | this.spdSub.ClipboardPasted | SCP0001_PlantSite.cs:2219 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ for (iRow < e.CellRange.Row + e.CellRang… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.FACTORY_ID2), codeVal) | 그리드 값 설정 |  |  |  |
| AC-5e037c2e | this.spdSub.ClipboardPasted | SCP0001_PlantSite.cs:2220 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ for (iRow < e.CellRange.Row + e.CellRang… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.FACTORY_ID), codeVal) | 그리드 값 설정 |  |  |  |
| AC-7b195d06 | this.spdSub.ClipboardPasted | SCP0001_PlantSite.cs:2224 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ for (iRow < e.CellRange.Row + e.CellRang… | DATA_OP | dtOperation.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2ab3ac16 | this.spdSub.ClipboardPasted | SCP0001_PlantSite.cs:2225 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ for (iRow < e.CellRange.Row + e.CellRang… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.OPERATION_ID2), codeVal) | 그리드 값 설정 |  |  |  |
| AC-3f347bfa | this.spdSub.ClipboardPasted | SCP0001_PlantSite.cs:2226 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ for (iRow < e.CellRange.Row + e.CellRang… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.OPERATION_ID), codeVal) | 그리드 값 설정 |  |  |  |
| AC-1799f0cd | this.spdSub.ClipboardPasted | SCP0001_PlantSite.cs:2230 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ for (iRow < e.CellRange.Row + e.CellRang… | DATA_OP | dtStorage.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f09229d8 | this.spdSub.ClipboardPasted | SCP0001_PlantSite.cs:2231 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ for (iRow < e.CellRange.Row + e.CellRang… | GRID_SET | siSub.SetValue | (iRow, siSub.GetColumnIndex(DefColumns.STORAGE_ID), codeVal) | 그리드 값 설정 |  |  |  |

## SCP0001_PlantSite.SpdSub_ComboSelChange

진입점: this.spdSub.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-034a05ba | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1858 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-436a59c4 | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1871 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.LOCATION_CODE), sLocation) | 그리드 값 설정 |  |  |  |
| AC-518882ff | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1872 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.LOCATION_DESCRIPTION), sLocationDesc) | 그리드 값 설정 |  |  |  |
| AC-e537c306 | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1880 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.FACTORY_ID), factoryID) | 그리드 값 설정 |  |  |  |
| AC-21851268 | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1881 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.BUILDING), factoryDesc) | 그리드 값 설정 |  |  |  |
| AC-82c09470 | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1883 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.OPERATION_ID), "") | 그리드 값 설정 |  |  |  |
| AC-c26505e3 | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1884 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.OPERATION_ID2), "") | 그리드 값 설정 |  |  |  |
| AC-04e19684 | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1885 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.STORAGE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-dbc6dadd | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1892 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.OPERATION_ID), operationID) | 그리드 값 설정 |  |  |  |
| AC-5b49b888 | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1893 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.STORAGE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-de7df36f | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1910 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.FACTORY_ID), "") | 그리드 값 설정 |  |  |  |
| AC-75a37295 | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1911 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.FACTORY_ID2), "") | 그리드 값 설정 |  |  |  |
| AC-eb2be8bc | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1912 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.OPERATION_ID), "") | 그리드 값 설정 |  |  |  |
| AC-f2990ce0 | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1913 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.OPERATION_ID2), "") | 그리드 값 설정 |  |  |  |
| AC-71611d47 | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1914 | if (siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (e.Column == siSub.GetColumnIndex(Def… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ELECTRODE_TYPE), "") | 그리드 값 설정 |  |  |  |
| AC-645fa808 | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1923 | if (siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSheet.SheetName == … | FLAG | dtDetailSalesSite | Data.Common(Data.Type.SaleSiteByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-19fa2645 | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1923 | if (siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSheet.SheetName == … | COMBO_DATA | Data.Common | (Data.Type.SaleSiteByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a8bdb773 | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1926 | if (siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(DefColumns.SCM_SITE_ID), dtDetailSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7d4794d4 | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1937 | if (siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (siSub.ActiveSheet.SheetNam… | FLAG | dtStorageByDivPlant | Data_SCP.Common(Data_SCP.Type.StorageByDivPlant, false, division, sPlant) | 화면 필드/플래그 변경 |  |  |  |
| AC-b54db4c3 | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1937 | if (siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (siSub.ActiveSheet.SheetNam… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.StorageByDivPlant, false, division, sPlant) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-51f03403 | this.spdSub.ComboSelChange | SCP0001_PlantSite.cs:1938 | if (siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ else of (siSub.ActiveSheet.SheetNam… | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(DefColumns.STORAGE_ID), dtStorageByDivPlant) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SCP0001_PlantSite.spdSub_EditChange

진입점: this.spdSub.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffa533e0 | this.spdSub.EditChange | SCP0001_PlantSite.cs:2182 | if (e.Column == siSub.GetColumnIndex(DefColumns.SOLD_TO)) | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SHIP_TO), "") | 그리드 값 설정 |  |  |  |

## SCP0001_PlantSite.spdSub_TopChange

진입점: this.spdSub.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-125e493d | this.spdSub.TopChange | SCP0001_PlantSite.cs:2189 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

