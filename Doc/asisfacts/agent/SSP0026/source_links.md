# SSP0026 소스 링크 표

## 0. 파일 약어

| 약어 | 경로 |
|---|---|
| M | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0026_ShipmentRequestPack.UIL\SSP0026_ShipmentRequestPack.cs` |
| MD | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0026_ShipmentRequestPack.UIL\SSP0026_ShipmentRequestPack.Designer.cs` |
| BP | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0026_BodItemPopup.cs` |
| BPD | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0026_BodItemPopup.Designer.cs` |
| IP | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0026_ItembyDivisionPopup.cs` |
| IPD | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0026_ItembyDivisionPopup.Designer.cs` |
| L | `06.UIL\GSCM.SSP.Plan.UIL\SSP0026_ShipmentRequestPack.cs` (legacy, 4669줄, 분석 제외) |

## 1. 엔드포인트 호출 지점 (endpoints.csv 37건 전체)

| # | 파일 | 메서드 | 줄 | 내용 |
|---:|---|---|---:|---|
| 1 | M | `<field:dtPgmAuthId>` | 60 | `biz:CommonData.CommonDataList` [code=LookupCommon] (진입점 미연결) |
| 2 | M | InitControls | 231 | `biz:CommonData.CommonDataList` [code=MyDivision] |
| 3 | M | InitControls | 306 | `biz:CommonData.CommonDataList` [code=Measure] |
| 4 | M | FindData | 755 | `biz:CommonData.CommonDataList` [code=Measure] |
| 5 | M | FindData | 787 | `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` |
| 6 | M | FindData | 848 | `SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL` |
| 7 | M | FindData_Result_Detail | 969 | `SSP.SSP0026_GET_RESULT_DETAIL` |
| 8 | M | FindData_Detail | 1071 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` |
| 9 | M | FindData_Detail | 1115 | `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` (⚠ DB에 SP 없음) |
| 10 | M | FindData_Detail_DblClick | 1232 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` |
| 11 | M | FindData_Detail_DblClick | 1274 | `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` (⚠ DB에 SP 없음) |
| 12 | M | SaveData | 1508 | `SSP.SSP0026_SAVE_SHIP_REQ_PACK` |
| 13 | M | SaveData | 1580 | `SSP.SSP0026_SAVE_SHIP_REQ_CELL` |
| 14 | M | SaveData_Detail | 1783 | `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK` |
| 15 | M | SaveData_Detail | 1860 | `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_CELL` (⚠ DB에 SP 없음) |
| 16 | M | spdMain_ComboSelChange | 2182 | `biz:CommonData.CommonDataList` [code=MktFcstEditMeasure] (진입점 미연결) |
| 17 | M | spdMain_Changed | 2499 | `biz:CommonData.CommonDataList` [code=DefaultBucketDay] (진입점 미연결) |
| 18 | M | spdMain_Changed | 2561 | `biz:CommonData.CommonDataList` [code=DefaultBucketDay] (진입점 미연결) |
| 19 | M | GetSpdTitle | 3027 | `SSP.SSP0026_GET_SPREAD_TITLE` |
| 20 | M | GetBucketType | 3044 | `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| 21 | M | GetBizTypebyDivision | 3056 | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` (진입점 미연결) |
| 22 | M | SpdDetail_ComboSelChange | 3191 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| 23 | M | SpdDetail_ClipboardPasted | 3464 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| 24 | M | SpdDetail_ClipboardPasted | 3482 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| 25 | M | BodValidChk_Main | 3794 | `SSP.SSP0002_GET_BOD_VALID_CHECK` (진입점 미연결) |
| 26 | M | BodValidChk | 3862 | `SSP.SSP0002_GET_BOD_VALID_CHECK` (진입점 미연결) |
| 27 | M | FindData_BOD_Main | 3930 | `SSP.SSP0026_GET_BOD_ITEM` |
| 28 | M | FindData_BOD_Main | 3951 | `biz:CommonData.CommonDataList` [code=TransMode] |
| 29 | M | FindData_BOD | 3982 | `SSP.SSP0026_GET_BOD_ITEM` |
| 30 | M | FindData_BOD | 4003 | `biz:CommonData.CommonDataList` [code=TransMode] |
| 31 | M | FindData_Request_Detail_DownLoad | 4309 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN` |
| 32 | BP | FindData | 254 | `SSP.SSP0026_GET_BOD_ITEM` |
| 33 | BP | GetDivision | 388 | `SCM.SCM0001_GET_DIVISION` |
| 34 | BP | GetDivisionbyScmSite | 402 | `SCM.SCM0001_GET_SITE_BY_DIVISION` |
| 35 | IP | FindData | 242 | `SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP` |
| 36 | IP | GetDivision | 374 | `SCM.SCM0001_GET_DIVISION` |
| 37 | IP | GetDivisionbyScmSite | 388 | `SCM.SCM0001_GET_SITE_BY_DIVISION` (진입점 미연결) |

## 2. 주석 처리된 호출 (현행 아님)

| 파일 | 줄 | 내용 |
|---|---:|---|
| BP | 389 | DM.Get_Division — 주석 처리됨 |
| IP | 375 | DM.Get_Division — 주석 처리됨 |

## 3. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| MD | InitializeComponent | 307 | formDown.Click += btnExcelFormDownload_Click |
| MD | InitializeComponent | 349 | btnExcelUpload.Click += btnExcelUpload_Click |
| MD | InitializeComponent | 426 | btnMeasure.Click += btnMeasure_Click |
| MD | InitializeComponent | 461 | cboDivision.SelectedIndexChanged += cboDivision_SelectedIndexChanged |
| MD | InitializeComponent | 499 | btnColumn.Click += btnColumn_Click |
| MD | InitializeComponent | 536 | chkSum.CheckedChanged += chkSum_CheckedChanged |
| MD | InitializeComponent | 572 | btnProject.Click += btnProject_Click |
| MD | InitializeComponent | 678 | cboBucketType.SelectedIndexChanged += cboBucketType_SelectedIndexChanged |
| MD | InitializeComponent | 832 | clbCustomer.SelectedIndexChanged += clbCustomer_SelectedIndexChanged |
| MD | InitializeComponent | 872 | clbTeam.SelectedIndexChanged += clbTeam_SelectedIndexChanged |
| M | .ctor | 203 | this.Load += Form_Load |
| M | InitEvent | 586~601 | spdMain/spdDetail TopChange·CellDoubleClick·ComboSelChange·ClipboardPasted·ActiveSheetChanged, btnSearch·btnItemId·btnItemID2·btnRequestor Click, chkPastPeriod CheckedChanged |
| BPD | InitializeComponent | 193 / 286 / 422 | clbDivision_SelectedIndexChanged / btnButtonList_UsrButtonList_Click_Detected / spdMain_CellDoubleClick |
| BP | .ctor | 136 | this.Load += Form_Load |
| IPD | InitializeComponent | 184 / 277 / 395 | clbDivision_SelectedIndexChanged / btnButtonList_UsrButtonList_Click_Detected / spdMain_CellDoubleClick |
| IP | .ctor | 126 | this.Load += Form_Load |

## 4. Grid 와 시트 정의 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | CreateSpread | 331~335 | AddSheet/GetSheetInfo/ChangeSheet "Pack Biz" (spdMain, 인자 3¦1¦40) |
| M | CreateSpread | 340~343 | "Cell Biz" — `if(drPgmAuthId != null)` |
| M | CreateSpread | 351~356, 369 | "Shipment Request Detail" (spdDetail, 1¦1¦60) |
| M | CreateSpread | 358~360 | "Shipment Result Detail" (spdDetail) |
| M | CreateSpread | 363~366 | "Shipment Request Detail Excel" (spdSub) |
| M | CreateSpread | 373 | ChangeSheet "Pack Biz" |
| M | InitSpread | 386 / 392 / 398 / 405 / 407 | SetSheetHeaderColumn(Request Detail) / MergePolicy.None / SetSheetHeaderColumn(Result Detail) / InitSheet / SetSheetHeaderColumn(Excel) |
| M | InitSpread | 413~418 / 425~430 | CreateSheetHeaderColumn + SetSpreadHeaderSpan + SetSpreadColumn (Pack Biz / Cell Biz) |
| M | SetSpreadHeaderSpan | 523~577 | 3행 헤더 Span, SUM, `B_` 숨김, SAT/SUN 글자색 |
| M | EditButton | 639 / 675 / 714 | GetSheetInfo (Cell Biz / Request Detail, bEdit_Mode_Detail) |
| M | FindData | 832 / 885 | SetSpreadColumn (ActiveSheetIndex 0 / 1) |
| M | SaveData / SaveData_Detail | 1407 / 1680 | GetSheetInfo (활성 시트) |
| M | InsertRow | 1965·1966 / 2049·2050 | FROM_SITE·TO_SITE 콤보 (spdMain / spdDetail) |
| M | cboBucketType_SelectedIndexChanged | 2124 | SetSpreadColumn |
| M | spdMain_ComboSelChange | 2146 / 2183 | FROM_SITE / MEASURE 콤보 (진입점 미연결 메서드) |
| M | chkSum_CheckedChanged | 2893 | SetSpreadColumn |
| M | SetSpreadColumn | 2909~2960 | 버킷과 과거기간에 따른 컬럼 Visible |
| M | BtnSearch_Click | 3112 / 3120 | ChangeSheet Request Detail / Result Detail |
| M | SpdDetail_ComboSelChange | 3193 | SHIPTO_CODE 콤보 |
| M | SpdDetail_ClipboardPasted | 3466 / 3484 | SHIPTO_CODE 콤보 |
| M | SpdMain_ActiveSheetChanged | 3592~3629 | Pack Biz 컬럼 표시 변경, Result Detail 시트 추가, Cell Biz 전환 |
| M | chkPastPeriod_CheckedChanged | 3776 | SetSpreadColumn |
| M | btnExcelUpload_Click | 4360·4361 | MSG00265 확인 후 Request Detail 전환 |
| M | btnExcelFormDownload_Click | 4374·4375 | Excel 시트 전환 |
| M | ExportExcel | 4501 / 4543 | Formula / DefaultStyle |
| (팝업, 파일 귀속 확인 필요) | InitSpread | 189~199, 204~210 | 하드코딩 AddTextColumn (Project 시트) |

## 5. 메타와 데이터 컬럼 읽기 지점

| 파일 | 메서드 | 줄 | 컬럼 |
|---|---|---:|---|
| M | InitControls | 231·247·248·252·257·260·267 | NowGroupID |
| M | InitControls | 267 | c[CODE], c[NAME] |
| M | InitControls | 274 / 283 / 289·302 / 295 / 301·303 | FROM_DATE / FIRST_DATE / NAME / CONFIRM_DAY / TO_DATE |
| M | Set_SumValues | 1334 | MEASURE |
| M | InsertRow | 2034·2035·2040 | NowGroupID |
| M | cboDivision_SelectedIndexChanged | 2082·2087·2092·2095 | NowGroupID |
| M | clbTeam_SelectedIndexChanged | 2104·2108 | NowGroupID |
| M | clbCustomer_SelectedIndexChanged | 2116 | NowGroupID |
| M | spdMain_ComboSelChange | 2145 | NowGroupID |
| M | SpdMain_ActiveSheetChanged | 3583 | NowGroupID |
| M | Re_Design | 4076 / 4088 | SHIP_FROZEN / CONFIRM_DAY |
| M | ShowCell | 4236 | SHIP_FROZEN |
| BP | InitControls | 169 | NowGroupID |
| IP | InitControls / clbDivision_SelectedIndexChanged | 155 / 302 | NowGroupID |
