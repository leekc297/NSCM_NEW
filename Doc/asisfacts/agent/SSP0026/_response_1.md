=== FILE: analysis.md ===
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

=== FILE: source_links.md ===
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

=== FILE: web_components.md ===
# SSP0026 웹 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑 (메인 화면)

라벨은 props.csv 에 있는 LayoutControlItem.Text 또는 컨트롤 Text 원문입니다. 원문이 없으면 '확인 필요'로 적었습니다.

### 1-1. 조회조건 패널 (usrConditionPanel1 → usrLayoutControl2)

| As-is 컨트롤 | 유형 | 라벨(원문) | 크기 | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|
| cboDivision | UsrCombo | Division (LCI `clbDivision`) | 244×20 | 단일선택 ComboBox | SelectedIndexChanged → Grid 재구성(GetSpdTitle) |
| clbPlantSite | UsrCheckedList | Plant Site (lblPlantSite) | 244×21 | 다중선택 MultiSelect | |
| clbSalesSite | UsrCheckedList | Sales Site (lblSalesSite) | 242×21 | 다중선택 MultiSelect | |
| clbCustomer | UsrCheckedList | End Customer (lblCustomer) | 247×21 | 다중선택 MultiSelect | SelectedIndexChanged 배선 |
| clbTeam | UsrCheckedList | Team (lblTeam) | 306×21 | 다중선택 MultiSelect | SelectedIndexChanged 배선 |
| txtItemId | UsrMultiLineEditor | Model (lblModel) | 255×21 | 다중 입력 텍스트 + 팝업 버튼 | |
| btnItemId | UsrButton | (Text 확인 필요) | 37×20 | 아이콘 버튼 | BtnItemID_Click |
| txtProject | UsrMultiLineEditor | Project (lblProject) | 255×21 | 다중 입력 텍스트 + 팝업 버튼 | |
| btnProject | UsrButton | (Text 확인 필요) | 39×20 | 아이콘 버튼 | btnProject_Click |
| cboBucketType | UsrCombo | Bucket (lblBucket) | 256×20 | ComboBox | 값 DAILY/WEEKLY/MONTHLY (SetSpreadColumn 조건) |
| drpPeriod | UsrDateRangePicker | (LCI `Period` 의 Text 확인 필요) | 180×20 | DateRange | |
| btnMeasure | UsrButton | (Text 확인 필요) | 34×20 | 버튼 | btnMeasure_Click → Grid 재구성 |
| chkSum | UsrCheckBox | Sum | 70×21 | CheckBox | M_/W_ 컬럼 표시 전환 |
| chkPastPeriod | UsrCheckBox | Including Past Period | 180×21 | CheckBox | Checked=true, **Visible=false** |
| btnColumn | UsrButton | (Text 확인 필요) | 40×21 | — | **Visible=false** |
| formDown | UsrButton | Excel Form | 90×21 | 버튼 | 양식 다운로드 |
| btnExcelUpload | UsrButton | Upload | 70×21 | 버튼 | MSG00265 확인 후 업로드 |
| (lblItemType) | LayoutControlItem | Item Type | 297×24 | 확인 필요 | 연결된 Control 이 props 에 없음 |

### 1-2. 하단 상세 영역 (splitContainer1.Panel2 → usrLayoutControl3)

| As-is 컨트롤 | 유형 | 라벨(원문) | TO-BE 후보 | 비고 |
|---|---|---|---|---|
| drpPeriod2 | UsrDateRangePicker | 확인 필요 | DateRange | |
| txtRequestor / btnRequestor | UsrMultiLineEditor / UsrButton | 확인 필요 | 텍스트 + 팝업 버튼 | BtnRequestor_Click |
| txtItemld2 / btnItemID2 | UsrMultiLineEditor / UsrButton | 확인 필요 | 텍스트 + 팝업 버튼 | BtnItemID2_Click |
| txtLotID | UsrMultiLineEditor | 확인 필요 | 다중 입력 텍스트 | |
| textNickName2 | TextBox | 확인 필요 | Input | |
| btnSearch | SimpleButton | 확인 필요 | 버튼 | BtnSearch_Click → 상세 조회 |

### 1-3. Grid

| As-is | 위치 | TO-BE |
|---|---|---|
| spdMain (FpSpread) | splitContainer1.Panel1 | Wijmo FlexGrid, 시트 탭(Pack Biz / Cell Biz), 3행 헤더 |
| spdDetail (FpSpread) | splitContainer1.Panel2 | Wijmo FlexGrid, 시트 탭(Shipment Request Detail / Shipment Result Detail) |
| spdSub (FpSpread) | splitContainer1.Panel2 | 화면 비표시용 Excel 양식 Grid(Shipment Request Detail Excel). 표시 여부는 **확인 필요** |

### 1-4. 공용 팝업

| 팝업 | 컨트롤 | 라벨 |
|---|---|---|
| SSP0026_BodItemPopup | clbDivision, clbFromSite, clbToSite, txtItemID, txtToSite, btnButtonList, spdMain | lblDivision / lblFromSite / lblToSite / lblItemID / lbl_ToSiteText (Text 원문 확인 필요) |
| SSP0026_ItembyDivisionPopup | clbDivision, clbScmSite, txtItemID, txtProject, btnButtonList, spdMain | 확인 필요 (controls.csv 절단) |

## 2. 화면 배치

| 영역 | 속성(원문) | 해석 |
|---|---|---|
| usrConditionPanel1 | Dock=Top, Size=1284×94, UsrPanelType=HidePanel | 상단 조회조건이며 접을 수 있음 |
| splitContainer1 | Dock=Fill, Orientation=Horizontal | **상/하 분할**: 상 Panel1=spdMain, 하 Panel2=usrLayoutControl3 + spdDetail + spdSub |
| splitContainer1.SplitterDistance | 확인 필요 (props.csv 절단) | 상/하 비율 미확정 |

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

표기: 필수 = USER_SELECTABLE_FLAG='N', 기본 = DEFAULT_FLAG='Y', 숨김 = 메타 VISIBLE/VALID 가 아님, →표시/→숨김 = 코드에서 변경.

### 3-1. `Pack Biz` (spdMain, META+코드연결, 3행 헤더)

| 컬럼 | 라벨 | 40 | 그 외 Division |
|---|---|---|---|
| DIVISION_ID | Division* | 필수 | — |
| END_CUSTOMER | End Customer | 필수 | — |
| TEAM_NAME_KO | Team | 필수 | — |
| LAST_UPDATED_BY | Requestor | 필수 | — |
| REMARK | Customer Requirement | 필수 | — |
| CONFIRM_DAY | CONFIRM_DAY | 기본 | — |
| FROM_SITE | From ( Plant )* | 기본 | — |
| SITE_DESCRIPTION | Plant site | 기본 | — |
| TO_SITE | To ( Sales-Site )* | 기본 | — |
| INCOTERMS | Incoterms* | 기본 | — |
| TR_MODE | Trans Mode* | 기본 | — |
| MODEL_ID | Model* | 기본 | — |
| NICK_NAME | Nick Name | 기본 | — |
| MEASURE | Measure* | 기본 | — |
| FCST_TYPE | FCST Type* | 기본 →숨김 | →숨김 |
| SHIPTO_CODE | (메타 없음) | →표시 | →표시 |
| ORDER_TYPE_DETAIL | (메타 없음) | →표시 | →표시 |
| BOD_ID / MEASURE_COLOR / PROJECT_CODE / SHIP_FROZEN | BOD ID* / MEASUR_COLOR / Project Code* / DMF0045 | 숨김 | — |

합계: 40 = 16, 그 외 = 2. 여기에 SP 와 GetSpdTitle 이 만드는 D_/W_/M_ 버킷 컬럼이 붙습니다(Measure 8건, Division 40).

### 3-2. `Cell Biz` (spdMain, META+코드연결, CreateSpread:340 `drPgmAuthId != null` 일 때만 생성)

| 컬럼 | 라벨 | 40 |
|---|---|---|
| DIVISION_ID | Division* | 필수 |
| END_CUSTOMER | End Customer | 필수 |
| TEAM_NAME_KO | Team | 필수 |
| LAST_UPDATED_BY | Requestor | 필수 |
| REMARK | Customer Requirement | 필수 |
| FCST_TYPE | FCST Type* | 기본 |
| FROM_SITE | Frorm ( Plant )* | 기본 |
| TO_SITE | To ( Sales-Site )* | 기본 |
| INCOTERMS | Incoterms* | 기본 |
| TR_MODE | Trans Mode* | 기본 |
| MODEL_ID | Model* | 기본 |
| NICK_NAME | Nick Name | 기본 |
| MEASURE | Measure* | 기본 |
| BOD_ID / MEASURE_COLOR / SHIP_FROZEN / SITE_DESCRIPTION | BOD ID* / MEASUR_COLOR / Confirm day / Plant site | 숨김 |

합계: 40 = 13, 그 외 Division 은 메타 없음. Measure 10건(Division 40). ORDER_TYPE_DETAIL 과 SHIPTO_CODE 는 CODE_ONLY_CHANGE 이지만 Cell Biz 에는 영향이 없습니다.

### 3-3. `Shipment Request Detail` (spdDetail, META+코드연결, MergePolicy.None) — 모든 Division 35

| 컬럼 | 라벨 | 컬럼 | 라벨 |
|---|---|---|---|
| DIVISION_ID | Div* | MODEL_ID | Model* |
| FROM_SITE | From Site* | NICK_NAME | Nick Name |
| SITE_DESCRIPTION | Plant Site | QTY | Qty* |
| TO_SITE | To Site* | YYYYMMDD | Shipment Date* |
| SHIPTO_CODE | Ship to* | EXPECTED_SHIP_DATE | Expected Shipping Date |
| SHIPTO_NAME | Ship to Name | ETD_DATE | ETD |
| SOLDTO_CODE | Sold to | ETA_DATE | ETA |
| END_CUSTOMER | End Customer | LT_TOTAL | L/T(Day) |
| INCOTERMS | Incoterms* | REQUEST_ID | Confrim/Plan ID |
| TR_MODE | Trans Mode* | CHANGE_REQUEST_NO | Change Request No |
| FCST_TYPE | FCST Type* | STATUS | Status |
| ORDER_TYPE_DETAIL | Order Type Detail | REMARK | Remark |
| BOD_ID | BOD_ID | LAST_UPDATED_BY | Requestor |
| MODEL_USER | Model PIC | LAST_UPDATED_DATE | Request Date |
| MKT_OWMER | MKT Owner | EDIT_FLAG | EDIT_FLAG |
| ATTRIBUTE3 | RTF | TEMP | TEMP |
| ATTRIBUTE4 | RTF ETD | ATTRIBUTE5 | RTF QTY |
| ATTRIBUTE6 | RTF Detail | (숨김) MODEL_PIC, MOEL_USER | Model PIC |

컬럼 순서는 SCM_MST_SHEET_COLUMNS 의 SORT_ORDER_NO 를 따릅니다. 이 표는 순서가 아니며, 실제 순서는 **확인 필요**입니다.

### 3-4. `Shipment Result Detail` (spdDetail, META+코드연결) — 모든 Division 12

DIVISION_ID(Division*), FROM_SITE(From ( Plant )*), SITE_DESCRIPTION(Plant site), TO_SITE(To ( Sales-Site )*), SHIP_TO(Ship to), SHIPTO_DESCRIPTION(Ship to Name), MODEL_ID(Model*), QTY(Qty*), YYYYMMDD(Shipment Date), LAST_UPDATED_BY(Last Updated by), LAST_UPDATED_DATE(Last Update Date), TEMP(TEMP). 숨김: SCM_SITE_ID.

### 3-5. `Shipment Request Detail Excel` (spdSub, META+코드연결) — 모든 Division 10

DIVISION_ID(Div*), FROM_SITE(FromSite*), TO_SITE(ToSite*), SHIPTO_CODE(ShipTo*), ITEM_ID(Model*), QTY(Qty*), YYYYMMDD(yyyyMMdd*), INCOTERMS(Incoterms*), TRANSPORT_MODE(Trans Mode*), FCST_TYPE(FCST Type*). Excel 양식 다운로드와 업로드의 기준 컬럼입니다. SCM_ADM_EXCEL_COLUMNS 2행과의 관계는 **확인 필요**합니다.

### 3-6. `Shipment Request Detail_BACKUP` — 메타 정의만 있고 코드 미참조(미사용 가능), 19

BOD_ID, DIVISION_ID, EDIT_FLAG, FCST_TYPE, FROM_SITE, INCOTERMS, LAST_UPDATED_BY, LAST_UPDATED_DATE, MODEL_ID, NICK_NAME, ORDER_TYPE_DETAIL, QTY, REMARK, SHIPTO_CODE, SHIPTO_NAME, SITE_DESCRIPTION, TO_SITE, TR_MODE, YYYYMMDD (숨김: FCST_TYPE2). TO-BE 에서 구현하지 않는 후보입니다.

### 3-7. `Project` — 코드 하드코딩 전용(메타 없음), 14 (공용 팝업 Grid)

| 줄 | 헤더 | 필드 |
|---:|---|---|
| 189 / 204 | Division | DIVISION_ID |
| 190 / 205 | Division | DIVISION_NAME |
| 191 | Project Code | PROJECT_CODE |
| 192 | Project | PROJECT_NAME |
| 193 | SCM Site | SCM_SITE_ID |
| 194 | Site | SITE_DESCRIPTION |
| 195 / 207 | Model Code / Material | ITEM_ID |
| 196 | Model | ITEM_NAME |
| 197 | Type | ITEM_TYPE |
| 198 | Nick Name | NICK_NAME |
| 199 | Class Name | ITEM_CLASS_NAME |
| 208 | Incoterms | INCOTERMS |
| 209 | Transport Mode | TRANSPORT_MODE |
| 210 | BOD ID | BOD_ID |

189~199 줄과 204~210 줄은 서로 다른 팝업 Grid 정의로 보입니다. 각 줄이 어느 파일(ItembyDivisionPopup / BodItemPopup)에 속하는지는 grid_code.csv 가 잘려 있어 **확인 필요**입니다. TO-BE 에서는 팝업별로 Grid 를 나눠 구현해야 합니다.

## 4. 시트 연결 규칙

1. spdMain 활성 시트(Pack Biz / Cell Biz)가 저장과 조회 SP 를 결정합니다.
   - FindData: ActiveSheetIndex 0 → PACK SP(787), 1 → CELL SP(848)
   - SaveData: PACK(1508) / CELL(1580)
2. `SpdMain_CellDoubleClick` 은 메인 행으로 spdDetail 의 Shipment Request Detail 을 조회합니다(FindData_Detail_DblClick → DETAIL_PACK 1232 / DETAIL_CELL 1274).
3. `SpdMain_ActiveSheetChanged` 에서 Pack Biz 로 바뀌었는데 spdDetail 에 Shipment Result Detail 시트가 없으면 AddSheet 합니다(3604). Cell Biz 일 때는 ChangeSheet 만 합니다(3629).
4. `BtnSearch_Click`: spdDetail.ActiveSheetIndex 가 0 이면 Request Detail 조회, 1 이면 Result Detail 조회입니다(3112 / 3120).
5. Excel Form 버튼은 spdSub(Shipment Request Detail Excel) 기준으로 양식을 내려받습니다(EXCEL_DOWN SP). Upload 버튼은 MSG00265 확인 후 Request Detail 시트로 반영합니다.
6. spdDetail 편집:
   - TO_SITE 를 바꾸면 SHIPTO_CODE 콤보를 ShipToCodeByDivision 으로 다시 채웁니다.
   - 콤보 선택이나 붙여넣기가 있으면 GET_BOD_ITEM 과 TransMode 를 조회합니다.

=== FILE: oracle_migration.md ===
# SSP0026 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| # | SP | 상태 | 진입 | 읽기 객체 | 쓰기 객체 | EXEC 체인 / 함수 | MSSQL 특이 요소 |
|---:|---|---|---|---|---|---|---|
| 1 | `SSP0026_GET_SHIPMENT_REQUEST_PACK` | MATCH | 조회 / 저장 후 재조회 / 업로드 | SCM_MST_TITLESET_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_PLAN_VERSION_V, SCP_PLN_SHIPMENT_PLAN, SCP_PLN_SHIPMENT_PLAN_PEGGING, SCM_MST_SITE, SCP_MST_BOD_N_V, SSP_ANL_SHIP_REQ_P, SCM_DNM_SCS_SHIP_RESULT, SSP_ANL_SHIP_CONFIRM, SCM_DNM_SCS_PROD_PLAN, SCM_MST_SITE_CUSTOMER, SCM_SYS_CALENDAR_M, SCM_DNM_SCS_STOCK, SCM_MST_SHEET_MEASURE, SCM_MST_SITE_ITEM, SCM_MST_PROJECT, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO | #TBLDYNAMICTITLEST_SSP0026, #TMP_RESULT_TABLE, #TMP_ROWDATA, #TMP_ROWDATA_RN, #Z, #QTY, #BOH, #TMP_SCP_ANL_SHIPMENT_PLAN_FG, #TBLDYNAMIC_REQUESTOR, #TMP_RESULT_PIVOT_TABLE(_TEMP) (임시) | — | STRING_SPLIT, #임시테이블, 동적 SQL(DYNAMIC@) |
| 2 | `SSP0026_GET_SHIPMENT_REQUEST_CELL` | MATCH | 조회 / 재조회 / 업로드 | SCM_MST_TITLESET_USER, SCP_PLAN_VERSION_V, SSP_PLAN_VERSION_V, SSP_ANL_SHIP_PLAN_40, SCP_PLN_SHIPMENT_PLAN(_PEGGING), SCM_MST_SITE, SCP_MST_BOD_N_V, DM_PLN_SHIPMENT_REQ, SSP_ANL_SHIP_CONFIRM, SCM_MST_ITEM_SN, SSP_DNM_FORMATION_POST_CELL, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_MST_SITE_ITEM, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO | #TBLDYNAMIC_SSP0026_40_STD 외 #임시 다수 | — | STRING_SPLIT, #임시테이블, 동적 SQL |
| 3 | `SSP0026_GET_RESULT_DETAIL` | MATCH | 하단 Search (Result 시트) | SCM_SYS_CALENDAR_M | — | FN_NEXT_DAY | 동적 SQL |
| 4 | `SSP0026_GET_REQUEST_DETAIL_PACK` | MATCH | 하단 Search / 더블클릭 / 저장 후 / 업로드 | (정적 추출 없음, 확인 필요) | — | — | 동적 SQL |
| 5 | `SSP0026_GET_REQUEST_DETAIL_CELL` | MATCH, **⚠ DB에 SP 없음** | 하단 Search / 더블클릭 / 저장 후 / 업로드 | 확인 불가 | 확인 불가 | — | 원문 없음 |
| 6 | `SSP0026_SAVE_SHIP_REQ_PACK` | MATCH | 저장 (Pack Biz) | SCM_SYS_CALENDAR_M, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SSP_ANL_SHIP_PLAN_PACK_REQ, SCM_MST_SITE_CUSTOMER, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER, TB_FX_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, NERP_CONV_MASTER, SCM_MST_CUSTOMER, SCM_MST_SITE, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO | SSP_ANL_SHIP_PLAN_PACK_REQ, SSP_ANL_SHIP_REQ_P_H, XIF_SCS_PACK_SHIP_PLAN_S_SN, SCM_SYS_LOG_BATCH, UPDATE:A(별칭), #TBLDYNAMIC_SSP0026_SHPIMENTREQ | EXEC PR_SCP_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH / FN_NEXT_DAY, SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_GET_SITE_CUSTOMER_INFO, FN_ZERO_LPAD, FN_GET_ITEM_NICKNAME, FN_GET_SSP_MKT_OWNER_NAME | #임시테이블, UPDATE 별칭 구문 |
| 7 | `SSP0026_SAVE_SHIP_REQ_CELL` | MATCH | 저장 (Cell Biz) | SCM_SYS_CALENDAR_M, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, DM_PLN_SHIPMENT_REQ | DM_PLN_SHIPMENT_REQ, DM_PLN_SHIPMENT_REQ_H, SCM_SYS_LOG_BATCH, UPDATE:A | EXEC PR_SCP_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH / FN_NEXT_DAY, SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | #임시테이블, UPDATE 별칭 |
| 8 | `SSP0026_SAVE_SHIP_REQ_DETAIL_PACK` | MATCH | 저장 (Request Detail) | SCM_SYS_CALENDAR_M, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SSP_ANL_SHIP_REQ_P, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER, TB_FX_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, NERP_CONV_MASTER, SCM_MST_ITEM_SN, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER, SCM_MST_SSO_USER_INFO | SSP_ANL_SHIP_REQ_P, SSP_ANL_SHIP_REQ_P_H, XIF_SCS_PACK_SHIP_PLAN_S_SN, SCM_SYS_LOG_BATCH, UPDATE:A | EXEC PR_SCP_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH / FN_NEXT_DAY, SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_ZERO_LPAD, FN_GET_ITEM_NICKNAME, FN_GET_SITE_CUSTOMER_INFO, FN_GET_SSP_MKT_OWNER_NAME | #임시테이블, UPDATE 별칭 |
| 9 | `SSP0026_SAVE_SHIP_REQ_DETAIL_CELL` | MATCH, **⚠ DB에 SP 없음** | 저장 (Request Detail, Cell) | 확인 불가 | 확인 불가 | — | 원문 없음 |
| 10 | `SSP0026_GET_SPREAD_TITLE` | MATCH | Grid 재구성(Load / 조회 / 시트 변경 / Division / Measure / Column) | SCM_MST_SHEET_COLUMNS, SCM_SYS_CALENDAR_M | — | — | STRING_SPLIT |
| 11 | `DM0003_GET_BUCKET_TYPE_CODE` | MATCH | Form_Load | SCM_ADM_LOOKUP_MASTER_DETAIL | — | — | — |
| 12 | `SCM0001_GET_BIZ_TYPE_BY_DIVISION` | MATCH (진입점 미연결) | — | SCM_MST_PROJECT | — | — | REF:VALUE, REF:NODES (XML 메서드 사용 여부 원문 확인 필요) |
| 13 | `SSP0002_GET_BOD_VALID_CHECK` | MATCH (진입점 미연결) | — | SCP_MST_BOD_N_V | — | — | — |
| 14 | `SSP0026_GET_BOD_ITEM` | MATCH | Grid 콤보 / 붙여넣기, BOD 팝업 | SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM | — | — | STRING_SPLIT |
| 15 | `SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN` | MATCH | Excel Form | SSP_MST_SHIP_CALENDAR, SSP_ANL_SHIP_REQ_P, SCP_MST_BOD_N_V, SCM_MST_SITE, SCM_CODE_LOOKUP_VALUE | — | FN_GET_LOOKUP_VALUE | STRING_SPLIT |
| 16 | `SCM0001_GET_DIVISION` | MATCH | 팝업 Form_Load | SCM_MST_DIVISION | — | — | — |
| 17 | `SCM0001_GET_SITE_BY_DIVISION` | MATCH | BOD 팝업 Form_Load (Item 팝업은 미연결) | SCM_MST_SITE | — | — | REF:VALUE, REF:NODES |
| 18 | `SSP0026_GET_ITEM_BY_DIVISION_POPUP` | MATCH | Item 팝업 Load / 조회 | SCM_MST_SITE_ITEM, SCM_MST_DIVISION, SCM_MST_SITE, SCM_MST_ITEM_SN, SCM_MST_PROJECT | — | — | STRING_SPLIT |

## 2. 공통코드 분기 (`biz:CommonData.CommonDataList` → UP_FX_GetCommonDataList)

| code | 호출 위치 | 참조 테이블 | 현행 여부 |
|---|---|---|---|
| MyDivision | InitControls:231 | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION | 현행 |
| Measure | InitControls:306, FindData:755 | SCM_MST_SHEET_MEASURE, DM_MST_CUSTOMER_FCST | 현행 |
| ShipToCodeByDivision | SpdDetail_ComboSelChange:3191, SpdDetail_ClipboardPasted:3464·3482 | SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER, SCM_MST_SITE | 현행 |
| TransMode | FindData_BOD_Main:3951, FindData_BOD:4003 | SCP_MST_BOD_V | 현행 |
| LookupCommon | `<field:dtPgmAuthId>`:60 | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | 필드 초기화(진입점 미연결, 확인 필요) |
| MktFcstEditMeasure | spdMain_ComboSelChange:2182 | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, DM_MST_CUSTOMER_FCST | 진입점 미연결 |
| DefaultBucketDay | spdMain_Changed:2499·2561 | SCM_ADM_LOOKUP_MASTER_DETAIL | 진입점 미연결 |

## 3. FoxQuery 미등록 / 직접 호출 / DB 부재

| 구분 | 대상 | 내용 |
|---|---|---|
| FoxQuery 미등록 | DM.Get_Division | 주석 처리됨(BodItemPopup:389, ItembyDivisionPopup:375). 전환 대상이 아닙니다 |
| DB에 SP 없음 | SSP0026_GET_REQUEST_DETAIL_CELL | FoxQuery 키는 있으나 DB 객체가 없습니다. As-is 운영 동작을 확인해야 합니다 |
| DB에 SP 없음 | SSP0026_SAVE_SHIP_REQ_DETAIL_CELL | 위와 같음 |
| 엔드포인트 미해석 | Data.UserPlantSiteByDivisionOspPack / Data_SCP.Common(ShipmentRequestPlantSite) / Data.UserSiteByEndCustomer(Auth) | InsertRow 와 콤보에서 사용합니다. 내부 SP 는 Fact Pack 범위 밖이라 **확인 필요**입니다 |

## 4. Oracle 전환 시 확인 포인트

1. **#임시테이블**: 조회 SP 2종(PACK / CELL)과 저장 SP 3종이 `#` 임시테이블을 CREATE / INSERT 합니다.
   - Oracle 에서는 GTT 나 컬렉션으로 바꿔야 합니다.
   - GTT 를 쓴다면 세션 내 재호출 시 시작 시점에 비우는지 반드시 확인해야 합니다.
2. **동적 SQL(DYNAMIC@)**: GET_SHIPMENT_REQUEST_PACK / CELL, GET_RESULT_DETAIL, GET_REQUEST_DETAIL_PACK 이 해당합니다.
   - 피벗 결과(#TMP_RESULT_PIVOT_TABLE)로 날짜 버킷 컬럼을 동적으로 만듭니다.
   - Oracle 에서는 SYS_REFCURSOR 와 동적 SQL 로 바꿔야 하며, 컬럼 순서와 이름이 GetSpdTitle(SCM_MST_SHEET_COLUMNS)과 맞아야 합니다.
3. **STRING_SPLIT**: SPREAD_TITLE, BOD_ITEM, ITEM_BY_DIVISION_POPUP, EXCEL_DOWN, SHIPMENT_REQUEST_PACK / CELL 에서 참조합니다. MSSQL 고유 함수이므로 대체가 필요합니다.
4. **REF:VALUE / REF:NODES**: SCM0001_GET_BIZ_TYPE_BY_DIVISION, SCM0001_GET_SITE_BY_DIVISION 에서 나왔습니다. XML 파라미터 처리일 가능성이 있으므로 SP 원문을 확인해야 합니다.
5. **UPDATE:A**: 별칭 대상 UPDATE(`UPDATE A … FROM`) 구문으로 추출되었습니다. Oracle 에서는 MERGE 나 상관 서브쿼리로 바꿔야 합니다. 원문 확인이 필요합니다.
6. **사용자 정의 함수 의존**: FN_NEXT_DAY, FN_ZERO_LPAD, FN_GET_ITEM_NICKNAME, FN_GET_SITE_CUSTOMER_INFO, FN_GET_SSP_MKT_OWNER_NAME, FN_GET_LOOKUP_VALUE, SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL. Oracle 측 존재 여부를 확인해야 합니다.
7. **로그 프로시저 체인**: PR_SCP_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH 를 거쳐 SCM_SYS_LOG_BATCH 에 기록합니다.
8. **인터페이스 테이블 쓰기**: XIF_SCS_PACK_SHIP_PLAN_S_SN 에 INSERT 합니다(SAVE_SHIP_REQ_PACK, SAVE_SHIP_REQ_DETAIL_PACK). 외부 시스템 연계 대상이므로 Oracle 측 테이블 위치를 확인해야 합니다.
9. **NERP_CONV_MASTER, TB_FX_USER 참조**: 저장 SP 3종이 참조합니다. 스키마와 시노님을 확인해야 합니다.
10. **이력 테이블**: SSP_ANL_SHIP_REQ_P_H, DM_PLN_SHIPMENT_REQ_H 에 INSERT 합니다. 저장 1회당 이력 건수가 AS-IS 와 같은지 대조해야 합니다.
11. **DB 부재 SP 2종**은 전환 원문이 없습니다. 기능을 유지할지는 업무 확인이 필요합니다.

## 5. 난이도 (사실 근거)

| SP | 근거 | 난이도 |
|---|---|---|
| GET_SHIPMENT_REQUEST_PACK | 참조 객체 40개 이상, #임시 12종, 동적 SQL, STRING_SPLIT | 상 |
| GET_SHIPMENT_REQUEST_CELL | 참조 객체 40개 이상, #임시 다수, 동적 SQL, STRING_SPLIT | 상 |
| SAVE_SHIP_REQ_PACK / SAVE_SHIP_REQ_DETAIL_PACK | #임시, UPDATE 별칭, 함수 7종, 로그 체인, 인터페이스 테이블 INSERT | 상 |
| SAVE_SHIP_REQ_CELL | #임시, UPDATE 별칭, 함수 3종, 로그 체인 | 중 |
| GET_RESULT_DETAIL / GET_REQUEST_DETAIL_PACK | 동적 SQL | 중 (DETAIL_PACK 은 정적 참조 0건이라 원문 확인 필요) |
| GET_SPREAD_TITLE / GET_BOD_ITEM / GET_ITEM_BY_DIVISION_POPUP / GET_REQUEST_DETAIL_PACK_EXCEL_DOWN | STRING_SPLIT 와 단순 SELECT | 중 |
| SCM0001_GET_BIZ_TYPE_BY_DIVISION / SCM0001_GET_SITE_BY_DIVISION | REF:VALUE / NODES | 중 (원문 확인 필요) |
| DM0003_GET_BUCKET_TYPE_CODE / SCM0001_GET_DIVISION / SSP0002_GET_BOD_VALID_CHECK | 단일 테이블 SELECT | 하 |
| GET_REQUEST_DETAIL_CELL / SAVE_SHIP_REQ_DETAIL_CELL | DB에 SP 없음 | 판정 불가 |

=== FILE: tobe_design.md ===
# SSP0026 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

### 1-1. 상단 메인 조회조건

| 순번 | 라벨(As-is 원문) | As-is 컨트롤 | 형태 | 비고 |
|---:|---|---|---|---|
| 1 | Division | cboDivision | 단일 콤보 | MyDivision(사용자 권한 Division). 바꾸면 Grid 를 다시 구성합니다 |
| 2 | Plant Site | clbPlantSite | 다중 체크 | |
| 3 | Sales Site | clbSalesSite | 다중 체크 | |
| 4 | End Customer | clbCustomer | 다중 체크 | 변경 이벤트 있음(NowGroupID 사용) |
| 5 | Team | clbTeam | 다중 체크 | 변경 이벤트 있음(NowGroupID 사용) |
| 6 | Model | txtItemId + btnItemId | 다중 입력 + 팝업 | |
| 7 | Project | txtProject + btnProject | 다중 입력 + 팝업 | |
| 8 | Bucket | cboBucketType | 콤보 | DM0003_GET_BUCKET_TYPE_CODE, DAILY / WEEKLY / MONTHLY |
| 9 | (Period, 라벨 확인 필요) | drpPeriod | 기간 | |
| 10 | Item Type | 확인 필요 | 확인 필요 | 연결 컨트롤 미확인 |
| 11 | Sum | chkSum | 체크 | 합계 컬럼 표시. 조회 파라미터 여부는 확인 필요 |
| 12 | Including Past Period | chkPastPeriod | 체크 | Designer Visible=false, Checked=true |
| — | (Measure 버튼) | btnMeasure | 버튼 | Grid 재구성 |

조회조건 저장 메타: TB_FX_SearchCondition 48행. 조건별 매핑은 **확인 필요**입니다.

### 1-2. 하단 상세 조회조건 (Panel2)

drpPeriod2, txtRequestor + btnRequestor, txtItemld2 + btnItemID2, txtLotID, textNickName2, btnSearch. 라벨 원문은 **확인 필요**입니다.

## 2. 액션별 호출 API 후보

| 액션 | As-is 핸들러 / 경로 | 호출 SP | TO-BE API 후보(가칭) |
|---|---|---|---|
| 화면 진입 | Form_Load > InitControls / CreateSpread | CommonDataList(MyDivision, Measure), DM0003_GET_BUCKET_TYPE_CODE, SSP0026_GET_SPREAD_TITLE | 공통 콤보 API + `ssp0026/spreadTitle` |
| 메인 조회 (Pack Biz) | FindButton > FindData:787 | SSP0026_GET_SHIPMENT_REQUEST_PACK (+GET_SPREAD_TITLE) | `ssp0026/searchPack` |
| 메인 조회 (Cell Biz) | FindButton > FindData:848 | SSP0026_GET_SHIPMENT_REQUEST_CELL | `ssp0026/searchCell` |
| 메인 저장 (Pack) | SaveButton > SaveData:1508 | SSP0026_SAVE_SHIP_REQ_PACK, 이후 재조회 | `ssp0026/savePack` |
| 메인 저장 (Cell) | SaveButton > SaveData:1580 | SSP0026_SAVE_SHIP_REQ_CELL, 이후 재조회 | `ssp0026/saveCell` |
| 상세 저장 | SaveButton > SaveData_Detail:1783 / 1860 | SSP0026_SAVE_SHIP_REQ_DETAIL_PACK / SSP0026_SAVE_SHIP_REQ_DETAIL_CELL(⚠ DB 없음) | `ssp0026/saveDetailPack` (Cell 은 미확정) |
| 메인 행 더블클릭 | SpdMain_CellDoubleClick > FindData_Detail_DblClick | SSP0026_GET_REQUEST_DETAIL_PACK / _CELL(⚠) | `ssp0026/searchRequestDetail` |
| 하단 Search (Request) | BtnSearch_Click > FindData_Detail | SSP0026_GET_REQUEST_DETAIL_PACK / _CELL(⚠) | 위와 같음 |
| 하단 Search (Result) | BtnSearch_Click > FindData_Result_Detail | SSP0026_GET_RESULT_DETAIL | `ssp0026/searchResultDetail` |
| Excel Form | btnExcelFormDownload_Click | SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN | `ssp0026/excelForm` |
| Upload | btnExcelUpload_Click (MSG00265 확인) | 업로드 후 FindData / FindData_Detail 재조회 | 화면에서 파싱한 뒤 Request Detail 에 반영. 저장은 상세 저장 API |
| Grid 콤보 / 붙여넣기 (메인) | SpdMain_ComboSelChange / SpdMain_ClipboardPasted > FindData_BOD_Main | SSP0026_GET_BOD_ITEM, CommonDataList(TransMode) | `ssp0026/bodItem` + 공통 TransMode |
| Grid 콤보 / 붙여넣기 (상세) | SpdDetail_ComboSelChange / SpdDetail_ClipboardPasted | CommonDataList(ShipToCodeByDivision), SSP0026_GET_BOD_ITEM, TransMode | 공통 ShipTo + `ssp0026/bodItem` |
| Division / Measure / 시트 전환 | cboDivision_SelectedIndexChanged, btnMeasure_Click, SpdMain_ActiveSheetChanged | SSP0026_GET_SPREAD_TITLE | `ssp0026/spreadTitle` |
| Bucket / Sum / 과거기간 | cboBucketType_SelectedIndexChanged, chkSum_CheckedChanged, chkPastPeriod_CheckedChanged | 없음(SetSpreadColumn 으로 화면 표시만 전환) | FE 컬럼 표시 로직 |
| BOD Item 팝업 | SSP0026_BodItemPopup | SSP0026_GET_BOD_ITEM, SCM0001_GET_DIVISION, SCM0001_GET_SITE_BY_DIVISION | 팝업 API |
| Item by Division 팝업 | SSP0026_ItembyDivisionPopup | SSP0026_GET_ITEM_BY_DIVISION_POPUP, SCM0001_GET_DIVISION | 팝업 API |

진입점이 연결되지 않은 호출(GetBizTypebyDivision, BodValidChk(_Main), spdMain_ComboSelChange 소문자, spdMain_Changed)은 TO-BE 구현 대상에서 빼는 후보입니다. 업무 확인 후 확정합니다.

## 3. Division별 Grid 변형 요약

| 시트 | Division 40 | 그 외 Division |
|---|---|---|
| Pack Biz | 16컬럼 + 버킷 컬럼, Measure 8 | 메타 없음. 코드 표시 2컬럼만 (확인 필요) |
| Cell Biz | 13컬럼 + 버킷 컬럼, Measure 10. `drPgmAuthId != null` 일 때만 시트 생성 | 메타 없음 |
| Shipment Request Detail | 35 | 35 |
| Shipment Result Detail | 12 | 12 |
| Shipment Request Detail Excel | 10 | 10 |
| Shipment Request Detail_BACKUP | 19 (코드 미참조) | 19 |
| Project (팝업) | 14 (하드코딩) | 14 |

공통 코드 규칙:
- Pack Biz 로 전환하면 SHIPTO_CODE 와 ORDER_TYPE_DETAIL 을 표시하고 FCST_TYPE 을 숨깁니다.
- 버킷(D_/W_/M_)과 Sum, 과거기간 표시 규칙을 적용합니다.
- 컬럼명에 `B_` 가 들어간 컬럼은 숨깁니다.
- 토요일은 파랑, 일요일은 빨강 헤더입니다.
- Request Detail 은 MergePolicy.None 입니다.

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 출처 |
|---|---|
| TB_FX_GroupMenuAuth 에 SSP0026 관련 12행 | DB 메타. C/R/U/D 값은 Fact Pack 에 없어 **확인 필요** |
| TB_FX_ProgramInfo 2행, TB_FX_MenuItemInfo 2행, TB_FX_Favorite 9행 | DB 메타 |
| Division 콤보 = MyDivision (TB_FX_USERGROUPAUTHEXTENTION 참조) | InitControls:231 |
| Cell Biz 시트 노출 = `drPgmAuthId != null` (dtPgmAuthId = LookupCommon) | CreateSpread:340, 필드:60 |
| FROM_SITE / TO_SITE 콤보가 사용자 기준으로 필터링됨 (UserPlantSiteByDivisionOspPack, UserSiteByEndCustomerAuth, NowGroupID·UserId 인자) | InsertRow:1965·1966·2049·2050 |
| 다수 이벤트에서 `UserInfoContext.Current["NowGroupID"]` 사용 | meta_reads.csv |
| 편집 모드 플래그 bEdit_Mode_Detail, 시트 잠금 IsLock 확인 | EditButton:675·714, InsertRow:2049, SpdDetail_ClipboardPasted:3466 |
| SHIP_FROZEN / CONFIRM_DAY 를 읽어 셀 처리 | Re_Design:4076·4088, ShowCell:4236 (구체 동작 확인 필요) |

## 5. 미확정 사항

1. Cell 상세 SP 2종(GET_REQUEST_DETAIL_CELL, SAVE_SHIP_REQ_DETAIL_CELL)이 DB에 없습니다. Cell Biz 상세 기능의 범위를 정해야 합니다.
2. Cell Biz 시트 노출 조건(LookupCommon 값)과 권한 그룹의 관계를 확인해야 합니다.
3. 버튼별 팝업 연결을 확인해야 합니다: btnItemId / btnItemID2 / btnProject / btnRequestor 가 각각 어느 팝업을 여는지.
4. 하단 조회조건의 라벨과 SP 파라미터 매핑을 확인해야 합니다.
5. Item Type 라벨에 연결된 컨트롤을 확인해야 합니다.
6. SplitContainer 상/하 비율(SplitterDistance)을 확인해야 합니다.
7. 메타 라벨 오타 유지 여부를 정해야 합니다(Frorm, MEASUR_COLOR, Confrim, MKT_OWMER, MOEL_USER, "DMF0045").
8. Shipment Request Detail_BACKUP 시트를 폐기할지 정해야 합니다.
9. 40 이외 Division 에서 Pack Biz 화면이 실제로 어떻게 보이는지 실행으로 확인해야 합니다.
10. 업로드 검증 로직(BOD 유효성 등)을 확인해야 합니다. BodValidChk 계열은 진입점이 연결되어 있지 않습니다.
11. SaveButton:739 → PersonalSettingPopup.SaveData 매핑이 맞는지 확인해야 합니다.
