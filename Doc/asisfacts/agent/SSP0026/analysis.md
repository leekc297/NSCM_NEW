# SSP0026 Shipment Request Pack — As-is 분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0026)에 있는 사실만 사용했습니다. Fact Pack에 없는 내용은 **확인 필요**로 적었습니다.
> 추출 대상은 현행(current) 파일과 공용(shared) 팝업 파일입니다. 구버전 사본(legacy)은 참고용으로만 적었습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0026 |
| 클래스 | `SSP0026_ShipmentRequestPack` |
| 도메인 | SSP |
| 메인 프로젝트 | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0026_ShipmentRequestPack.UIL\SSP0026_ShipmentRequestPack.UIL.csproj` |
| 공용 팝업 프로젝트 | `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj` |
| Grid 구성 방식 | **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** |
| 화면 메타 테이블 행 수 | SCM_MST_SHEET_COLUMNS 116 / SCM_MST_SHEET_MEASURE 19 / TB_FX_SearchCondition 48 / TB_FX_GroupMenuAuth 12 / TB_FX_Favorite 9 / SCM_ADM_LOOKUP_MASTER_DETAIL 7 / SCM_ADM_EXCEL_COLUMNS 2 / TB_FX_MenuItemInfo 2 / TB_FX_ProgramInfo 2 / SCM_ADM_DB_SCRIPT_BACKUP 154 |

### 1-1. 파일 구성

| 구분 | 파일 | 줄수 | 비고 |
|---|---|---:|---|
| current | `...\SSP0026_ShipmentRequestPack.UIL\SSP0026_ShipmentRequestPack.cs` | 4607 | 메인 로직 |
| current | `...\SSP0026_ShipmentRequestPack.UIL\SSP0026_ShipmentRequestPack.Designer.cs` | 1887 | 컨트롤과 이벤트 배선 |
| current | `...\SSP0026_ShipmentRequestPack.UIL\Properties\AssemblyInfo.cs` | 37 | 어셈블리 정보 |
| shared | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0026_BodItemPopup.cs` | 416 | BOD Item 팝업 |
| shared | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0026_BodItemPopup.Designer.cs` | 565 | |
| shared | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0026_ItembyDivisionPopup.cs` | 402 | Division별 Item 팝업 |
| shared | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0026_ItembyDivisionPopup.Designer.cs` | 487 | |
| legacy | `06.UIL\GSCM.SSP.Plan.UIL\SSP0026_ShipmentRequestPack.cs` | 4669 | 구버전 사본이며 분석 대상에서 제외 |
| legacy | `06.UIL\GSCM.SSP.Plan.UIL\SSP0026_ShipmentRequestPack.Designer.cs` | 1887 | 구버전 사본이며 분석 대상에서 제외 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

### 2-1. 메인 화면 (`SSP0026_ShipmentRequestPack`)

| 진입점 | 호출 경로 | 줄 | 엔드포인트 | 상태 |
|---|---|---:|---|---|
| Form_Load (this.Load) | Form_Load > InitControls | 231 | `biz:CommonData.CommonDataList` [code=MyDivision] | BIZ_MATCH |
| Form_Load | Form_Load > InitControls | 306 | `biz:CommonData.CommonDataList` [code=Measure] | BIZ_MATCH |
| Form_Load | Form_Load > InitControls > GetBucketType | 3044 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH |
| Form_Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 3027 | `SSP.SSP0026_GET_SPREAD_TITLE` | MATCH |
| FindButton(조회) | FindButton > FindData | 755 | `biz:CommonData.CommonDataList` [code=Measure] | BIZ_MATCH |
| FindButton | FindButton > FindData | 787 | `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` | MATCH |
| FindButton | FindButton > FindData | 848 | `SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL` | MATCH |
| FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 3027 | `SSP.SSP0026_GET_SPREAD_TITLE` | MATCH |
| SaveButton(저장) | SaveButton > SaveData | 1508 | `SSP.SSP0026_SAVE_SHIP_REQ_PACK` | MATCH |
| SaveButton | SaveButton > SaveData | 1580 | `SSP.SSP0026_SAVE_SHIP_REQ_CELL` | MATCH |
| SaveButton | SaveButton > SaveData > FindData | 755 / 787 / 848 | Measure / `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` / `SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL` | 재조회 |
| SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 3027 | `SSP.SSP0026_GET_SPREAD_TITLE` | 재조회 |
| SaveButton | SaveButton > SaveData_Detail | 1783 | `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK` | MATCH |
| SaveButton | SaveButton > SaveData_Detail | 1860 | `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_CELL` | MATCH (⚠ DB에 SP 없음) |
| SaveButton | SaveButton > SaveData_Detail > FindData_Detail | 1071 / 1115 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` | 재조회 |
| btnSearch.Click (`BtnSearch_Click`) | BtnSearch_Click > FindData_Detail | 1071 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` | MATCH |
| BtnSearch_Click | BtnSearch_Click > FindData_Detail | 1115 | `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` | MATCH (⚠ DB에 SP 없음) |
| BtnSearch_Click | BtnSearch_Click > FindData_Result_Detail | 969 | `SSP.SSP0026_GET_RESULT_DETAIL` | MATCH |
| BtnSearch_Click | BtnSearch_Click > FindData_Result_Detail > InitSpread > GetSpdTitle | 3027 | `SSP.SSP0026_GET_SPREAD_TITLE` | MATCH |
| spdMain.CellDoubleClick (`SpdMain_CellDoubleClick`) | > FindData_Detail_DblClick | 1232 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` | MATCH |
| SpdMain_CellDoubleClick | > FindData_Detail_DblClick | 1274 | `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` | MATCH (⚠ DB에 SP 없음) |
| SpdMain_CellDoubleClick | > FindData_Detail_DblClick > InitSpread > GetSpdTitle | 3027 | `SSP.SSP0026_GET_SPREAD_TITLE` | MATCH |
| formDown.Click (`btnExcelFormDownload_Click`) | > FindData_Request_Detail_DownLoad | 4309 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN` | MATCH |
| btnExcelUpload.Click (`btnExcelUpload_Click`) | > FindData (755/787/848) · FindData_Detail (1071/1115) · FindData > InitSpread > GetSpdTitle (3027) | — | Measure / PACK / CELL / DETAIL_PACK / DETAIL_CELL / SPREAD_TITLE | MATCH |
| btnMeasure.Click (`btnMeasure_Click`) | > InitSpread > GetSpdTitle | 3027 | `SSP.SSP0026_GET_SPREAD_TITLE` | MATCH |
| btnColumn.Click (`btnColumn_Click`) | > InitSpread > GetSpdTitle | 3027 | `SSP.SSP0026_GET_SPREAD_TITLE` | MATCH (btnColumn 은 Designer 에서 Visible=false) |
| cboDivision.SelectedIndexChanged (`cboDivision_SelectedIndexChanged`) | > InitSpread > GetSpdTitle | 3027 | `SSP.SSP0026_GET_SPREAD_TITLE` | MATCH |
| spdMain.ActiveSheetChanged (`SpdMain_ActiveSheetChanged`) | > InitSpread > GetSpdTitle | 3027 | `SSP.SSP0026_GET_SPREAD_TITLE` | MATCH |
| spdMain.ComboSelChange (`SpdMain_ComboSelChange`) | > FindData_BOD_Main | 3930 | `SSP.SSP0026_GET_BOD_ITEM` | MATCH |
| SpdMain_ComboSelChange | > FindData_BOD_Main | 3951 | `biz:CommonData.CommonDataList` [code=TransMode] | BIZ_MATCH |
| spdMain.ClipboardPasted (`SpdMain_ClipboardPasted`) | > FindData_BOD_Main | 3930 / 3951 | `SSP.SSP0026_GET_BOD_ITEM` / TransMode | MATCH |
| spdDetail.ComboSelChange (`SpdDetail_ComboSelChange`) | 직접 호출 | 3191 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] | BIZ_MATCH |
| SpdDetail_ComboSelChange | > FindData_BOD | 3982 / 4003 | `SSP.SSP0026_GET_BOD_ITEM` / TransMode | MATCH |
| spdDetail.ClipboardPasted (`SpdDetail_ClipboardPasted`) | 직접 호출 | 3464, 3482 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] | BIZ_MATCH |
| SpdDetail_ClipboardPasted | > FindData_BOD | 3982 / 4003 | `SSP.SSP0026_GET_BOD_ITEM` / TransMode | MATCH |

### 2-2. 공용 팝업

| 클래스 | 진입점 | 경로 | 줄 | 엔드포인트 |
|---|---|---|---:|---|
| SSP0026_BodItemPopup | Form_Load | Form_Load > FindData | 254 | `SSP.SSP0026_GET_BOD_ITEM` |
| SSP0026_BodItemPopup | Form_Load | Form_Load > InitControls > GetDivision | 388 | `SCM.SCM0001_GET_DIVISION` |
| SSP0026_BodItemPopup | Form_Load | Form_Load > InitControls > GetDivisionbyScmSite | 402 | `SCM.SCM0001_GET_SITE_BY_DIVISION` |
| SSP0026_BodItemPopup | FindButton / `btnButtonList_UsrButtonList_Click_Detected` | > FindData | 254 | `SSP.SSP0026_GET_BOD_ITEM` |
| SSP0026_ItembyDivisionPopup | Form_Load | Form_Load > FindData | 242 | `SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP` |
| SSP0026_ItembyDivisionPopup | Form_Load | Form_Load > InitControls > GetDivision | 374 | `SCM.SCM0001_GET_DIVISION` |
| SSP0026_ItembyDivisionPopup | FindButton / `btnButtonList_UsrButtonList_Click_Detected` | > FindData | 242 | `SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP` |
| SSP0026_ItembyDivisionPopup | (진입점 미연결) | GetDivisionbyScmSite | 388 | `SCM.SCM0001_GET_SITE_BY_DIVISION` |

> 메인 화면의 `BtnItemID_Click`, `BtnItemID2_Click`, `btnProject_Click`, `BtnRequestor_Click` 중 어느 핸들러가 위 팝업을 여는지는 Fact Pack에 호출 관계로 나와 있지 않습니다. **확인 필요**

### 2-3. 진입점이 연결되지 않은 호출 (정적 분석 기준)

| 메서드 | 줄 | 엔드포인트 | 비고 |
|---|---:|---|---|
| `<field:dtPgmAuthId>` | 60 | `biz:CommonData.CommonDataList` [code=LookupCommon] | 필드 초기화식입니다. CreateSpread:340 의 `if(drPgmAuthId != null)` 조건(Cell Biz 시트 생성 여부)과 관련됩니다. 실행 시점은 **확인 필요** |
| GetBizTypebyDivision | 3056 | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` | 호출처 없음 |
| BodValidChk_Main | 3794 | `SSP.SSP0002_GET_BOD_VALID_CHECK` | 호출처 없음 |
| BodValidChk | 3862 | `SSP.SSP0002_GET_BOD_VALID_CHECK` | 호출처 없음 |
| spdMain_ComboSelChange (소문자) | 2182 | `biz:CommonData.CommonDataList` [code=MktFcstEditMeasure] | 배선된 핸들러는 대문자 `SpdMain_ComboSelChange` 입니다. 소문자 메서드는 배선이 없습니다 |
| spdMain_Changed | 2499, 2561 | `biz:CommonData.CommonDataList` [code=DefaultBucketDay] | 배선 없음 |

### 2-4. 주석 처리된 호출 (현행 기능 아님)

| 파일 | 줄 | 값 | 상태 |
|---|---:|---|---|
| SSP0026_BodItemPopup.cs | 389 | DM.Get_Division | 주석 처리됨 (FoxQuery 미등록) |
| SSP0026_ItembyDivisionPopup.cs | 375 | DM.Get_Division | 주석 처리됨 (FoxQuery 미등록) |

## 3. 엔드포인트 전체 표 (19개 키)

| # | 엔드포인트 | 상태 | 호출 수 | SP | 주요 참조 테이블(쓰기는 **굵게**) |
|---:|---|---|---:|---|---|
| 1 | `biz:CommonData.CommonDataList` | BIZ_MATCH | 12 (MyDivision 1, Measure 2, ShipToCodeByDivision 3, TransMode 2, LookupCommon 1, MktFcstEditMeasure 1, DefaultBucketDay 2) | UP_FX_GetCommonDataList(코드분기) | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SHEET_MEASURE, DM_MST_CUSTOMER_FCST, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER, SCM_MST_SITE, SCP_MST_BOD_V, SCM_ADM_LOOKUP_MASTER(_DETAIL) |
| 2 | `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` | MATCH | 1 | SSP0026_GET_SHIPMENT_REQUEST_PACK | SCM_MST_TITLESET_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_PLAN_VERSION_V, SCP_PLN_SHIPMENT_PLAN(_PEGGING), SCM_MST_SITE, SCP_MST_BOD_N_V, SSP_ANL_SHIP_REQ_P, SCM_DNM_SCS_SHIP_RESULT, SSP_ANL_SHIP_CONFIRM, SCM_DNM_SCS_PROD_PLAN, SCM_MST_SITE_CUSTOMER, SCM_SYS_CALENDAR_M, SCM_DNM_SCS_STOCK, SCM_MST_SHEET_MEASURE, SCM_MST_SITE_ITEM, SCM_MST_PROJECT, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO + #임시테이블 + 동적 SQL |
| 3 | `SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL` | MATCH | 1 | SSP0026_GET_SHIPMENT_REQUEST_CELL | SCM_MST_TITLESET_USER, SCP_PLAN_VERSION_V, SSP_PLAN_VERSION_V, SSP_ANL_SHIP_PLAN_40, SCP_PLN_SHIPMENT_PLAN(_PEGGING), SCM_MST_SITE, SCP_MST_BOD_N_V, DM_PLN_SHIPMENT_REQ, SSP_ANL_SHIP_CONFIRM, SCM_MST_ITEM_SN, SSP_DNM_FORMATION_POST_CELL, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_MST_SITE_ITEM, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO + #임시테이블 + 동적 SQL |
| 4 | `SSP.SSP0026_GET_RESULT_DETAIL` | MATCH | 1 | SSP0026_GET_RESULT_DETAIL | FN_NEXT_DAY, SCM_SYS_CALENDAR_M + 동적 SQL |
| 5 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` | MATCH | 2 | SSP0026_GET_REQUEST_DETAIL_PACK | 동적 SQL만 추출됨. 정적 참조 테이블 없음, **확인 필요** |
| 6 | `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` | MATCH | 2 | SSP0026_GET_REQUEST_DETAIL_CELL | ⚠ **DB에 SP 없음** |
| 7 | `SSP.SSP0026_SAVE_SHIP_REQ_PACK` | MATCH | 1 | SSP0026_SAVE_SHIP_REQ_PACK | **SSP_ANL_SHIP_PLAN_PACK_REQ**, **SSP_ANL_SHIP_REQ_P_H**, **XIF_SCS_PACK_SHIP_PLAN_S_SN**, **SCM_SYS_LOG_BATCH**, UPDATE:A, EXEC PR_SCP_SYS_LOG_BATCH / PR_SCM_SYS_LOG_BATCH |
| 8 | `SSP.SSP0026_SAVE_SHIP_REQ_CELL` | MATCH | 1 | SSP0026_SAVE_SHIP_REQ_CELL | **DM_PLN_SHIPMENT_REQ**, **DM_PLN_SHIPMENT_REQ_H**, **SCM_SYS_LOG_BATCH**, UPDATE:A |
| 9 | `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK` | MATCH | 1 | SSP0026_SAVE_SHIP_REQ_DETAIL_PACK | **SSP_ANL_SHIP_REQ_P**, **SSP_ANL_SHIP_REQ_P_H**, **XIF_SCS_PACK_SHIP_PLAN_S_SN**, **SCM_SYS_LOG_BATCH**, UPDATE:A |
| 10 | `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_CELL` | MATCH | 1 | SSP0026_SAVE_SHIP_REQ_DETAIL_CELL | ⚠ **DB에 SP 없음** |
| 11 | `SSP.SSP0026_GET_SPREAD_TITLE` | MATCH | 1 | SSP0026_GET_SPREAD_TITLE | SCM_MST_SHEET_COLUMNS, SCM_SYS_CALENDAR_M, STRING_SPLIT |
| 12 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | 1 | DM0003_GET_BUCKET_TYPE_CODE | SCM_ADM_LOOKUP_MASTER_DETAIL |
| 13 | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` | MATCH (미연결) | 1 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | SCM_MST_PROJECT, REF:VALUE/NODES |
| 14 | `SSP.SSP0002_GET_BOD_VALID_CHECK` | MATCH (미연결) | 2 | SSP0002_GET_BOD_VALID_CHECK | SCP_MST_BOD_N_V |
| 15 | `SSP.SSP0026_GET_BOD_ITEM` | MATCH | 3 | SSP0026_GET_BOD_ITEM | SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, STRING_SPLIT |
| 16 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN` | MATCH | 1 | SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN | FN_GET_LOOKUP_VALUE, SSP_MST_SHIP_CALENDAR, SSP_ANL_SHIP_REQ_P, SCP_MST_BOD_N_V, SCM_MST_SITE, SCM_CODE_LOOKUP_VALUE, STRING_SPLIT |
| 17 | `SCM.SCM0001_GET_DIVISION` | MATCH | 2 (팝업) | SCM0001_GET_DIVISION | SCM_MST_DIVISION |
| 18 | `SCM.SCM0001_GET_SITE_BY_DIVISION` | MATCH | 2 (팝업, 1건 미연결) | SCM0001_GET_SITE_BY_DIVISION | SCM_MST_SITE, REF:VALUE/NODES |
| 19 | `SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP` | MATCH | 1 (팝업) | SSP0026_GET_ITEM_BY_DIVISION_POPUP | SCM_MST_SITE_ITEM, SCM_MST_DIVISION, SCM_MST_SITE, SCM_MST_ITEM_SN, SCM_MST_PROJECT, STRING_SPLIT |

## 4. 이벤트 배선 표

| # | 대상 | 이벤트 | 핸들러 | 위치 | 파일 |
|---:|---|---|---|---|---|
| 1 | this.formDown | Click | `btnExcelFormDownload_Click` | InitializeComponent:307 | 메인 Designer |
| 2 | this.btnExcelUpload | Click | `btnExcelUpload_Click` | InitializeComponent:349 | 메인 Designer |
| 3 | this.btnMeasure | Click | `btnMeasure_Click` | InitializeComponent:426 | 메인 Designer |
| 4 | this.cboDivision | SelectedIndexChanged | `cboDivision_SelectedIndexChanged` | InitializeComponent:461 | 메인 Designer |
| 5 | this.btnColumn | Click | `btnColumn_Click` | InitializeComponent:499 | 메인 Designer |
| 6 | this.chkSum | CheckedChanged | `chkSum_CheckedChanged` | InitializeComponent:536 | 메인 Designer |
| 7 | this.btnProject | Click | `btnProject_Click` | InitializeComponent:572 | 메인 Designer |
| 8 | this.cboBucketType | SelectedIndexChanged | `cboBucketType_SelectedIndexChanged` | InitializeComponent:678 | 메인 Designer |
| 9 | this.clbCustomer | SelectedIndexChanged | `clbCustomer_SelectedIndexChanged` | InitializeComponent:832 | 메인 Designer |
| 10 | this.clbTeam | SelectedIndexChanged | `clbTeam_SelectedIndexChanged` | InitializeComponent:872 | 메인 Designer |
| 11 | this | Load | `Form_Load` | .ctor:203 | 메인 .cs |
| 12 | this.spdMain | TopChange | `SpdMain_TopChange` | InitEvent:586 | 메인 .cs |
| 13 | this.spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:587 | 메인 .cs |
| 14 | this.spdDetail | TopChange | `SpdDetail_TopChange` | InitEvent:588 | 메인 .cs |
| 15 | this.btnSearch | Click | `BtnSearch_Click` | InitEvent:589 | 메인 .cs |
| 16 | this.spdMain | ComboSelChange | `SpdMain_ComboSelChange` | InitEvent:590 | 메인 .cs |
| 17 | this.spdDetail | ComboSelChange | `SpdDetail_ComboSelChange` | InitEvent:591 | 메인 .cs |
| 18 | this.spdDetail | CellDoubleClick | `SpdDetail_CellDoubleClick` | InitEvent:592 | 메인 .cs |
| 19 | this.spdDetail | ClipboardPasted | `SpdDetail_ClipboardPasted` | InitEvent:593 | 메인 .cs |
| 20 | this.spdMain | ClipboardPasted | `SpdMain_ClipboardPasted` | InitEvent:594 | 메인 .cs |
| 21 | this.btnItemId | Click | `BtnItemID_Click` | InitEvent:595 | 메인 .cs |
| 22 | this.btnItemID2 | Click | `BtnItemID2_Click` | InitEvent:596 | 메인 .cs |
| 23 | this.btnRequestor | Click | `BtnRequestor_Click` | InitEvent:597 | 메인 .cs |
| 24 | this.chkPastPeriod | CheckedChanged | `chkPastPeriod_CheckedChanged` | InitEvent:598 | 메인 .cs |
| 25 | this.spdDetail | ActiveSheetChanged | `SpdDetail_ActiveSheetChanged` | InitEvent:599 | 메인 .cs |
| 26 | this.spdMain | ActiveSheetChanged | `SpdMain_ActiveSheetChanged` | InitEvent:601 | 메인 .cs |
| 27 | this.clbDivision | SelectedIndexChanged | `clbDivision_SelectedIndexChanged` | InitializeComponent:193 / :184 | BodItemPopup / ItembyDivisionPopup Designer |
| 28 | this.btnButtonList | UsrButtonList_Click_Detected | `btnButtonList_UsrButtonList_Click_Detected` | InitializeComponent:286 / :277 | BodItemPopup / ItembyDivisionPopup Designer |
| 29 | this.spdMain | CellDoubleClick | `spdMain_CellDoubleClick` | InitializeComponent:422 / :395 | BodItemPopup / ItembyDivisionPopup Designer |
| (참고) | this | Load | `Form_Load` | .ctor:136 / .ctor:126 | BodItemPopup / ItembyDivisionPopup .cs |

> 핸들러 29종이 모두 배선되어 있습니다. 다음 핸들러는 Fact Pack에 엔드포인트 호출이 나오지 않습니다: `SpdMain_TopChange`, `SpdDetail_TopChange`, `SpdDetail_CellDoubleClick`, `SpdDetail_ActiveSheetChanged`, `BtnItemID_Click`, `BtnItemID2_Click`, `BtnRequestor_Click`, `btnProject_Click`, `clbCustomer_SelectedIndexChanged`, `clbTeam_SelectedIndexChanged`. 이 중 `chkSum_CheckedChanged`, `cboBucketType_SelectedIndexChanged`, `chkPastPeriod_CheckedChanged` 는 SetSpreadColumn(컬럼 표시 전환)을 호출합니다(grid_code 2893, 2124, 3776). 그 밖의 내부 동작은 **확인 필요**입니다.

## 5. Grid 구성 방식

**HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)**

### 5-1. Spread 와 시트

| Spread | 시트 | 생성 위치 | 헤더 구성 | 연결 규칙 |
|---|---|---|---|---|
| spdMain | Pack Biz | CreateSpread:331 (조건 없음) | CreateSheetHeaderColumn(siMain, 3, dtTitle)@InitSpread:413 + SetSpreadHeaderSpan + SetSpreadColumn | META+코드연결 |
| spdMain | Cell Biz | CreateSpread:340 `if(drPgmAuthId != null)` | CreateSheetHeaderColumn(siMain, 3, dtTitle)@InitSpread:425 + SetSpreadHeaderSpan + SetSpreadColumn | META+코드연결 |
| spdDetail | Shipment Request Detail | CreateSpread:351 | SetSheetHeaderColumn(siDetail, 1)@InitSpread:386, MergePolicy.None@392 | META+코드연결 |
| spdDetail | Shipment Result Detail | CreateSpread:358, SpdMain_ActiveSheetChanged:3604(없을 때 추가) | SetSheetHeaderColumn(siDetail, 1)@InitSpread:398 | META+코드연결 |
| spdSub | Shipment Request Detail Excel | CreateSpread:363 | InitSheet + SetSheetHeaderColumn(siSub, 1)@InitSpread:407 | META+코드연결 |
| (팝업 spdMain) | Project | 팝업 InitSpread:189~199, 204~210 AddTextColumn | 하드코딩 | 코드 하드코딩 전용(메타 없음) |
| — | Shipment Request Detail_BACKUP | 코드에서 참조하지 않음 | — | 메타 정의만 있고 코드 미참조(미사용 가능) |

- Pack Biz / Cell Biz 의 날짜 버킷 컬럼은 `SSP0026_GET_SPREAD_TITLE`(SCM_MST_SHEET_COLUMNS + SCM_SYS_CALENDAR_M) 결과 dtTitle 로 동적으로 만들어집니다.
- SetSpreadHeaderSpan 의 동작:
  - 헤더는 3행이며 대분류(LargeLabelName)와 소분류(SmallLabelName)로 Span 합니다.
  - "SUM" 헤더를 붙입니다(523~577).
  - 컬럼명에 `B_` 가 들어 있으면 숨깁니다(531).
  - DAY_CODE 가 SAT 이면 파랑, SUN 이면 빨강 글자색입니다(542).
- SetSpreadColumn 의 동작(siMain 대상):
  - 버킷 DAILY:
    - `D_` 또는 `W_` 컬럼 → 표시(2909)
    - `M_` 또는 `W_` 컬럼 → chkSum.Checked 에 따름(2914)
    - 같은 `W_` 가 두 조건에 모두 걸립니다(원문 그대로 적음).
  - 버킷 WEEKLY:
    - `D_` → 숨김(2921)
    - `W_` → 표시(2925)
    - `M_` → chkSum(2930)
  - 버킷 MONTHLY:
    - `D_`, `W_` → 숨김(2937)
    - `M_` → 표시(2941)
  - chkPastPeriod 가 해제되어 있고 SUM 컬럼이 아니며 `date > colDate` 이면 → Visible=chkPastPeriod.Checked(2960)
- SpdMain_ActiveSheetChanged 에서 Pack Biz 로 바뀌면:
  - SHIPTO_CODE 표시(3592·3593)
  - ORDER_TYPE_DETAIL 표시(3594)
  - FCST_TYPE 숨김(3595)

### 5-2. Division별 차이 (grid_effective 기준 최종 표시 컬럼 수)

| 시트 | 40 | 81 / 81_HD / 81_HG / 81_HM / 81_ST / 81_UC / 82 / EE / EE_HD / EE_HG / EE_HM / EE_ST / EE_UC |
|---|---:|---|
| Cell Biz | 13 | · (메타 없음) |
| Pack Biz | 16 | 2 (코드로 표시하는 SHIPTO_CODE, ORDER_TYPE_DETAIL 만) |
| Project | 14 | 14 |
| Shipment Request Detail | 35 | 35 |
| Shipment Request Detail Excel | 10 | 10 |
| Shipment Request Detail_BACKUP | 19 | 19 |
| Shipment Result Detail | 12 | 12 |

- Cell Biz 와 Pack Biz 의 SCM_MST_SHEET_COLUMNS 와 SCM_MST_SHEET_MEASURE 행은 Division 40 에만 있습니다. Measure 는 Cell Biz 10건, Pack Biz 8건입니다.
- Pack Biz 시트는 Division 과 관계없이 생성됩니다. 40 이외 Division 에서 실제로 2컬럼만 나오는지는 실행으로 **확인 필요**합니다.
- SP 실행 결과와 대조하면 84개 시트×Division 조합에서 4178건이 다릅니다(grid_diff.csv). 이 차이에는 SP 가 만드는 날짜 컬럼이 '메타에 없음'으로 잡힌 건이 포함됩니다.

## 6. 확인 필요 항목

1. `SSP0026_GET_REQUEST_DETAIL_CELL`, `SSP0026_SAVE_SHIP_REQ_DETAIL_CELL` 은 FoxQuery 에는 MATCH 이지만 **DB에 SP 가 없습니다**. Cell 상세 조회와 저장이 실제로 동작하는지 확인해야 합니다.
2. `SSP0026_GET_REQUEST_DETAIL_PACK` 은 동적 SQL만 추출되어 참조 테이블을 정적으로 알 수 없습니다. SP 원문 확인이 필요합니다.
3. `dtPgmAuthId` 필드 초기화([code=LookupCommon])와 `drPgmAuthId` 의 관계, 그리고 Cell Biz 시트를 노출하는 조건값(SCM_ADM_LOOKUP_MASTER_DETAIL 7행)을 확인해야 합니다.
4. 진입점이 연결되지 않은 메서드 6종(2-3절)이 현행에서 실제로 쓰이지 않는지 확인해야 합니다.
5. Fact Pack 4-2 표에 SaveButton:739 → `PersonalSettingPopup.SaveData` 매핑이 있습니다. 화면 자체 SaveData 와 이름이 겹친 것인지 확인해야 합니다.
6. InsertRow 와 spdMain_ComboSelChange 의 콤보 데이터 소스 `Data.UserPlantSiteByDivisionOspPack`, `Data_SCP.Common(ShipmentRequestPlantSite, …, "P", "E")`, `Data.UserSiteByEndCustomer(Auth)` 는 엔드포인트 목록에 없습니다. 내부에서 호출하는 SP 를 확인해야 합니다.
7. 팝업 하단 영역 컨트롤(drpPeriod2, txtRequestor, txtItemld2, txtLotID, textNickName2)의 라벨과 조회 파라미터 매핑을 확인해야 합니다. props.csv 가 잘려 있어 알 수 없습니다.
8. SplitContainer 의 SplitterDistance 값을 확인해야 합니다. props.csv 가 잘려 있습니다.
9. 메타 라벨에 오타로 보이는 값과 특이값이 있습니다: `Frorm ( Plant )*`, `MEASUR_COLOR`, `Confrim/Plan ID`, `MKT_OWMER`, `MOEL_USER`, Pack Biz 의 SHIP_FROZEN 라벨 `DMF0045`. 이 값을 TO-BE 에서 유지할지 정해야 합니다.
10. SCM_MST_SHEET_MEASURE 는 19행인데 유효 전개는 18건(10+8)입니다. 차이 1건이 무엇인지 확인해야 합니다.
