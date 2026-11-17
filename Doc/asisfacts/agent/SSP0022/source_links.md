# SSP0022 소스 링크 표

경로 약어:
- **M** = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0022_ShipmentRequestElectrode.UIL\SSP0022_ShipmentRequestElectrode.cs` (current)
- **MD** = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0022_ShipmentRequestElectrode.UIL\SSP0022_ShipmentRequestElectrode.Designer.cs` (current)
- **BP** = `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0022_BodItemPopup.cs` / **BPD** = 같은 이름의 `.Designer.cs` (shared)
- **SP** = `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0022_ShipmentRequestPopup.cs` / **SPD** = 같은 이름의 `.Designer.cs` (shared)

## 1. 엔드포인트 호출 지점 (활성 36건)
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | InsertRow | 1476 | `biz:CommonData.CommonDataList` [code=PlantByElectordeShipFromSite] |
| M | InsertRow | 1477 | `biz:CommonData.CommonDataList` [code=PlantByElectordeShipToSite] |
| M | GetBucketType | 2096 | `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| M | FindData_Main | 2185 | `SSP.SSP0022_GET_SHIPMENT_PSI` |
| M | FindData_Request_Detail | 2339 | `SSP.SSP0022_GET_REQUEST_DETAIL` |
| M | FindData_Detail | 2484 | `SSP.SSP0022_GET_STOCK_DETAIL` |
| M | SaveData_Detail | 2671 | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` |
| M | SaveData | 2863 | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` |
| M | FindData_Request_Detail_DownLoad | 3043 | `SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN` |
| M | clbCompanyID_SelectedIndexChanged | 3664 | `biz:CommonData.CommonDataList` [code=PlantEE] |
| M | GetSpdTitle | 3869 | `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| M | FindData_BOD | 3907 | `SSP.SSP0022_GET_ITEM_POPUP` |
| M | BodItemValidChk_main | 4094 | `SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK` (진입점 미연결) |
| M | BodItemValidChk | 4143 | `SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK` (진입점 미연결) |
| M | GetSSPUserCheck | 4448 | `SSP.SSP0002_GET_USER_INFO_LIST` |
| BP | InitControls | 173 | `biz:CommonData.CommonDataList` [code=PlantByElectordeShipFromSite] |
| BP | InitControls | 174 | `biz:CommonData.CommonDataList` [code=PlantByElectordeShipToSite] |
| BP | FindData | 258 | `SSP.SSP0022_GET_ITEM_POPUP` |
| BP | GetDivision | 395 | `SCM.SCM0001_GET_DIVISION` |
| BP | GetDivisionbyScmSite | 409 | `SCM.SCM0001_GET_SITE_BY_DIVISION` |
| SP | `<field:dtFcstType>` | 43 | `biz:CommonData.CommonDataList` [code=LookupCommon] |
| SP | `<field:dtOperationGroup>` | 44 | `biz:CommonData.CommonDataList` [code=LookupCommon] |
| SP | `<field:dtIncoterms>` | 46 | `biz:CommonData.CommonDataList` [code=Incoterms] |
| SP | `<field:dtTransMode>` | 47 | `biz:CommonData.CommonDataList` [code=TransportMode] |
| SP | `<field:dtBaseDay>` | 49 | `biz:CommonData.CommonDataList` [code=LookupCommon] |
| SP | FindData | 362 | `SSP.SSP0022_GET_ITEM_POPUP` |
| SP | SaveData | 539 | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` |
| SP | BodValidChk | 663 | `SSP.SSP0002_GET_BOD_VALID_CHECK` (진입점 미연결) |
| SP | BodItemValidChk | 770 | `SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK` (진입점 미연결) |
| SP | SpdMain_ComboSelChange | 943 | `biz:CommonData.CommonDataList` [code=PlantByElectordeShipFromSite] |
| SP | SpdMain_ComboSelChange | 945 | `biz:CommonData.CommonDataList` [code=PlantByElectordeShipToSite] |
| SP | GetDayRange | 1225 | `SCP.GET_DATE_RANGE_1MONTH` |
| SP | clbDivision_SelectedIndexChanged | 1240 | `biz:CommonData.CommonDataList` [code=PlantByElectordeShipFromSite] |
| SP | clbDivision_SelectedIndexChanged | 1242 | `biz:CommonData.CommonDataList` [code=PlantByElectordeShipToSite] |
| SP | clbDivision_SelectedIndexChanged | 1246 | `biz:CommonData.CommonDataList` [code=Incoterms] |
| SP | clbDivision_SelectedIndexChanged | 1247 | `biz:CommonData.CommonDataList` [code=TransportMode] |

## 2. 주석 처리됨 (활성 아님)
| 파일 | 줄 | 내용 |
|---|---:|---|
| M | 4003 | SSP.SSP0002_GET_BOD_VALID_CHECK — 주석 처리됨 |
| BP | 396 | DM.Get_Division — 주석 처리됨 (FoxQuery 미등록) |
| SP | 1226 | SCP.SCM0001_GET_SCP_DAY_PERIOD — 주석 처리됨 |

## 3. 이벤트 배선 위치
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| MD | InitializeComponent | 264 | formDown.Click += btnExcelFormDownload_Click |
| MD | InitializeComponent | 306 | btnExcelUpload.Click += btnExcelUpload_Click |
| MD | InitializeComponent | 489 | chkPastPeriod.CheckedChanged += chkPastPeriod_CheckedChanged_1 |
| MD | InitializeComponent | 1459 | spdMain.CellClick += spdMain_CellClick_1 |
| M | .ctor | 347 | Load += Form_Load |
| M | InitEvent | 815~848 | TopChange, cboBucketType, rdButton1~3, chkSum, chkPastPeriod, btnMeasure, btnItemId, btnItemID2, btnSearch, btnRequestor, spdMain·spdDetail 셀 이벤트, clbDivision_ID, clbCompany_ID, cboPlanDate |
| M | clbCompanyID_SelectedIndexChanged | 3669 / 3673 | cboPlanDate.SelectedIndexChanged -= / += |
| BPD | InitializeComponent | 189 / 282 / 416 | clbDivision / btnButtonList / spdMain.CellDoubleClick |
| BP | .ctor | 137 | Load += Form_Load |
| SPD | InitializeComponent | 144 / 192 | clbDivision / btnButtonList |
| SP | .ctor | 143 | Load += Form_Load |
| SP | Form_Load | 160 / 162 / 163 / 164 | spdMain CellClick / EditChange / ComboSelChange / TextChanged |

## 4. Grid 정의 위치
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | CreateSpread | 571~574 | AddSheet: Shipment Request(Electrode)(spdMain) / Stock Detail·Shipment Request Detail(spdDetail) / Shipment Request Detail Excel(spdSub) |
| M | CreateSpread | 577~596 | GetSheetInfo / ChangeSheet |
| M | InitSpread | 607~617 | Shipment Request(Electrode): InitSheet, SetSheetHeaderColumn(3), InitSpreadDateColumn, SetSpreadColumn |
| M | InitSpread | 628~663 | UOM 라디오별 BOH 9컬럼 Visible |
| M | InitSpread | 669~707 | Stock Detail(3) / Shipment Request Detail(1) / Shipment Request Detail Excel(1) SetSheetHeaderColumn |
| M | InitSpreadDateColumn | 753~799 | 날짜 컬럼 DB 루프, 주말 색상, 헤더 span |
| M | SpdDetail_SheetTabClick | 1343~1354 | 탭 0/1/2 → 시트 전환 |
| M | InsertRow | 1481~1482 | FROM_SITE/TO_SITE SetCellTypeCombo |
| M | EditButton | 1525 / 1705 | GetSheetInfo(spdMain / spdDetail) |
| M | cboBucketType_SelectedIndexChanged | 1814 | SetSpreadColumn |
| M | rdButton_Changed | 1823~1861 | BOH Visible + SetSpreadColumn |
| M | chkPastPeriod_CheckedChanged / chkSum_CheckedChanged | 1865 / 1870 | SetSpreadColumn |
| M | SetSpreadColumn | 1904~2081 | 컬럼 Tag 접두어별 Visible |
| M | ExportExcel | 4338 / 4380 | Formula / DefaultStyle |
| (확인 필요) | InitSpread | 208~215 | 시트 Project 하드코딩 8컬럼 |
| (확인 필요) | InitSpread | 257~285 | 시트 Shipment Reqeust(Electrode) 하드코딩 26컬럼 |

## 5. 메타·데이터 읽기 위치
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | SetChangeControl | 379~421 | Filter GROUP_ID/USER_ID, NowGroupID, GetSSPInnerTable 8회 |
| M | InitControls | 444 / 453 | FP_Log2 |
| M | InitControls | 471~511 | NowGroupID, CODE/NAME, dtShipmentInputPeriod VALUE·Diff_VALUE, dtCompany CODE |
| M | SetChangedControl | 530~548 | CODE, DIVISION_ID, dtMyCompany NAME |
| M | SpdDetail_ClipboardPasted | 982~992 | BOD 결과 컬럼 9종 |
| M | Plan_Current_Check | 3548~3573 | Tmp_dtPlanDate CODE/NAME/FROM_DATE/TO_DATE |
| M | clbDivision_ID_SelectedIndexChanged | 3640 / 3642 | DIVISION_ID |
| M | cboPlanDate_SelectedIndexChanged | 3697~3711 | CODE / FROM_DATE / TO_DATE |
| SP | `<field:dtDivision>` | 38 | NowGroupID |
