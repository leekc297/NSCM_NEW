# SSP0022 Shipment Request(Electrode) — As-is 분석

> 출처: AsisFacts 정적 추출 결과(Fact Pack SSP0022)만 사용했다. Fact Pack에 없는 내용은 **확인 필요**로 적었다.
> 주석 처리된 호출 3건은 §7에 '주석 처리됨'으로만 적었고, 현행 기능 집계에는 넣지 않았다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0022 |
| 클래스 | `SSP0022_ShipmentRequestElectrode` |
| 도메인 | SSP (프로젝트 `GSCM.SSP.Forms.UIL\Plan`) |
| 화면명(시트명 기준) | Shipment Request(Electrode) |
| 업무 기능명 | 확인 필요 (TB_FX_ProgramInfo 2행·TB_FX_MenuItemInfo 2행이 있으나 행 내용은 Fact Pack에 없음) |

### 1-1. 파일 구성
| 구분 | 파일 | 줄수 |
|---|---|---:|
| current | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0022_ShipmentRequestElectrode.UIL\SSP0022_ShipmentRequestElectrode.cs` | 4792 |
| current | `...\SSP0022_ShipmentRequestElectrode.UIL\SSP0022_ShipmentRequestElectrode.Designer.cs` | 2286 |
| current | `...\SSP0022_ShipmentRequestElectrode.UIL\Properties\AssemblyInfo.cs` | 37 |
| shared | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0022_BodItemPopup.cs` / `.Designer.cs` | 423 / 512 |
| shared | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0022_ShipmentRequestPopup.cs` / `.Designer.cs` | 1347 / 353 |
| legacy | `06.UIL\GSCM.SSP.Plan.UIL\SSP0022_ShipmentRequestElectrode.cs` / `.Designer.cs` | 4463 / 2286 |

- legacy는 구버전 사본이다. 본문 분석은 current와 shared만 기준으로 한다.
- 두 팝업(`SSP0022_BodItemPopup`, `SSP0022_ShipmentRequestPopup`)을 본 화면의 어느 핸들러가 띄우는지는 Fact Pack에 호출 기록이 없어 **확인 필요**다. `btnItemId_Click`, `BtnItemID2_Click`, `BtnRequestor_Click`, `SpdDetail_CellDoubleClick` 등이 후보지만 이는 추정이므로 확정하지 않는다.

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

### 2-1. 본 화면 (current, `SSP0022_ShipmentRequestElectrode`)
| 진입점 | 호출 경로 | 줄 | 엔드포인트 |
|---|---|---:|---|
| this.Load | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle | 3869 | `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| this.Load | `Form_Load` > InitControls > GetBucketType | 2096 | `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| FindButton(조회) | FindButton > FindData_Main | 2185 | `SSP.SSP0022_GET_SHIPMENT_PSI` |
| FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 3869 | `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| InsertButton(행추가) | InsertButton > InsertRow | 1476 | `biz:CommonData.CommonDataList` [code=PlantByElectordeShipFromSite] |
| InsertButton | InsertButton > InsertRow | 1477 | `biz:CommonData.CommonDataList` [code=PlantByElectordeShipToSite] |
| EditButton(수정) | EditButton > GetSSPUserCheck | 4448 | `SSP.SSP0002_GET_USER_INFO_LIST` |
| SaveButton(저장) | SaveButton > SaveData_Detail | 2671 | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` |
| SaveButton | SaveButton > SaveData_Detail > FindData_Request_Detail | 2339 | `SSP.SSP0022_GET_REQUEST_DETAIL` |
| SaveButton | SaveButton > SaveData_Detail > FindData_Request_Detail > InitSpread > GetSpdTitle | 3869 | `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| SaveButton | SaveButton > SaveData | 2863 | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` |
| SaveButton | SaveButton > SaveData > FindData_Main | 2185 | `SSP.SSP0022_GET_SHIPMENT_PSI` |
| this.formDown.Click | `btnExcelFormDownload_Click` > FindData_Request_Detail_DownLoad | 3043 | `SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN` |
| this.btnExcelUpload.Click | `btnExcelUpload_Click` > FindData_Main | 2185 | `SSP.SSP0022_GET_SHIPMENT_PSI` |
| this.btnExcelUpload.Click | `btnExcelUpload_Click` > FindData_Main > InitSpread > GetSpdTitle | 3869 | `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| this.btnExcelUpload.Click | `btnExcelUpload_Click` > FindData_Request_Detail | 2339 | `SSP.SSP0022_GET_REQUEST_DETAIL` |
| this.btnMeasure.Click | `BtnMeasure_Click` > InitSpread > GetSpdTitle | 3869 | `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| this.btnSearch.Click | `BtnSearch_Click` > FindData_Request_Detail | 2339 | `SSP.SSP0022_GET_REQUEST_DETAIL` |
| this.btnSearch.Click | `BtnSearch_Click` > FindData_Request_Detail > InitSpread > GetSpdTitle | 3869 | `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| this.btnSearch.Click | `BtnSearch_Click` > FindData_Detail | 2484 | `SSP.SSP0022_GET_STOCK_DETAIL` |
| this.spdDetail.ComboSelChange | `SpdDetail_ComboSelChange` > FindData_BOD | 3907 | `SSP.SSP0022_GET_ITEM_POPUP` |
| this.spdDetail.CellDoubleClick | `SpdDetail_CellDoubleClick` > FindData_BOD | 3907 | `SSP.SSP0022_GET_ITEM_POPUP` |
| this.spdDetail.ClipboardPasted | `SpdDetail_ClipboardPasted` > FindData_BOD | 3907 | `SSP.SSP0022_GET_ITEM_POPUP` |
| this.spdMain.CellDoubleClick | `SpdMain_CellDoubleClick` > FindData_Main | 2185 | `SSP.SSP0022_GET_SHIPMENT_PSI` |
| this.spdMain.CellDoubleClick | `SpdMain_CellDoubleClick` > FindData_Main > InitSpread > GetSpdTitle | 3869 | `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| clbCompany_ID.SelectedIndexChanged | `clbCompanyID_SelectedIndexChanged` | 3664 | `biz:CommonData.CommonDataList` [code=PlantEE] |
| clbCompany_ID.SelectedIndexChanged | `clbCompanyID_SelectedIndexChanged` > InitSpread > GetSpdTitle | 3869 | `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| cboPlanDate.SelectedIndexChanged | `cboPlanDate_SelectedIndexChanged` > GetSpdTitle | 3869 | `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` |
| (진입점 미연결) | BodItemValidChk_main | 4094 | `SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK` |
| (진입점 미연결) | BodItemValidChk | 4143 | `SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK` |

### 2-2. 공유 팝업 `SSP0022_BodItemPopup` (shared)
| 진입점 | 호출 경로 | 줄 | 엔드포인트 |
|---|---|---:|---|
| this.Load | `Form_Load` > FindData | 258 | `SSP.SSP0022_GET_ITEM_POPUP` |
| this.Load | `Form_Load` > InitControls | 173 | `biz:CommonData.CommonDataList` [code=PlantByElectordeShipFromSite] |
| this.Load | `Form_Load` > InitControls | 174 | `biz:CommonData.CommonDataList` [code=PlantByElectordeShipToSite] |
| this.Load | `Form_Load` > InitControls > GetDivision | 395 | `SCM.SCM0001_GET_DIVISION` |
| this.Load | `Form_Load` > InitControls > GetDivisionbyScmSite | 409 | `SCM.SCM0001_GET_SITE_BY_DIVISION` |
| this.btnButtonList.UsrButtonList_Click_Detected | `btnButtonList_UsrButtonList_Click_Detected` > FindData | 258 | `SSP.SSP0022_GET_ITEM_POPUP` |
| FindButton | FindButton > FindData | 258 | `SSP.SSP0022_GET_ITEM_POPUP` |

### 2-3. 공유 팝업 `SSP0022_ShipmentRequestPopup` (shared)
| 진입점 | 호출 경로 | 줄 | 엔드포인트 |
|---|---|---:|---|
| this.Load | `Form_Load` > InitControls > GetDayRange | 1225 | `SCP.GET_DATE_RANGE_1MONTH` |
| this.clbDivision.SelectedIndexChanged | `clbDivision_SelectedIndexChanged` | 1240 / 1242 / 1246 / 1247 | `biz:CommonData.CommonDataList` [code=PlantByElectordeShipFromSite / PlantByElectordeShipToSite / Incoterms / TransportMode] |
| this.clbDivision.SelectedIndexChanged | `clbDivision_SelectedIndexChanged` > FindData | 362 | `SSP.SSP0022_GET_ITEM_POPUP` |
| spdMain.ComboSelChange | `SpdMain_ComboSelChange` | 943 / 945 | `biz:CommonData.CommonDataList` [code=PlantByElectordeShipFromSite / PlantByElectordeShipToSite] |
| spdMain.ComboSelChange | `SpdMain_ComboSelChange` > FindData | 362 | `SSP.SSP0022_GET_ITEM_POPUP` |
| this.btnButtonList.UsrButtonList_Click_Detected | `btnButtonList_UsrButtonList_Click_Detected` > SaveData | 539 | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` |
| SaveButton | SaveButton > SaveData | 539 | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` |
| (진입점 미연결) | BodValidChk | 663 | `SSP.SSP0002_GET_BOD_VALID_CHECK` |
| (진입점 미연결) | BodItemValidChk | 770 | `SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK` |
| (진입점 미연결) | 필드 초기화 dtFcstType / dtOperationGroup / dtBaseDay | 43 / 44 / 49 | `biz:CommonData.CommonDataList` [code=LookupCommon] |
| (진입점 미연결) | 필드 초기화 dtIncoterms / dtTransMode | 46 / 47 | `biz:CommonData.CommonDataList` [code=Incoterms / TransportMode] |

- '진입점 미연결'은 정적 파서가 이벤트·버튼에서 출발해 도달하지 못한 호출이다. 실제로 쓰이는지(다른 메서드 안에서 간접 호출되는지)는 **확인 필요**다.

## 3. 엔드포인트 전체 표 (활성 호출 15종)

| # | 엔드포인트 | 상태 | 호출 수 | SP / SQL | 주요 참조 테이블 |
|---:|---|---|---:|---|---|
| 1 | `biz:CommonData.CommonDataList` (code=Incoterms·LookupCommon·PlantByElectordeShipFromSite·PlantByElectordeShipToSite·PlantEE·TransportMode) | BIZ_MATCH | 16 (2+3+4+4+1+2) | 비즈 공통(UP_FX_GetCommonDataList 계열) | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_ADM_LOOKUP_MASTER, SCM_MST_SITE, SCP_MST_BOD_V |
| 2 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | SCM_ADM_LOOKUP_MASTER_DETAIL |
| 3 | `SSP.SSP0022_GET_SHIPMENT_PSI` | MATCH | 1 | SP SSP0022_GET_SHIPMENT_PSI | SSP_ANL_SHIP_PLAN_EE, SSP_ANL_BOH_CUTOFF_EE, SSP_ANL_SHIP_REQ_EE, SSP_ANL_SHIP_CONFIRM, SSP_DNM_SHIP_RESULT_OWMS_V, SSP_DNM_FP_MRP_INTRANSIT_SN, SSP_MST_SHIP_MASTER_EE, SSP_MST_MODEL_USER_EE, SSP_MST_DELEGATE, SSP_MST_SITE_ITEM_EE_V, SCP_MST_FINAL_ITEM, SCP_MST_BOD_N_V, SCM_MST_SHEET_MEASURE, SCM_MST_TITLESET_USER, SCM_SYS_CALENDAR_M, SCM_MST_SITE, SCM_MST_SITE_CUSTOMER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_CODE_LOOKUP_VALUE 외 # 임시테이블 다수·동적 SQL |
| 4 | `SSP.SSP0022_GET_REQUEST_DETAIL` | MATCH | 1 | SP SSP0022_GET_REQUEST_DETAIL | DYNAMIC@SSP0022_GET_REQUEST_DETAIL (동적 SQL — 참조 테이블은 **확인 필요**) |
| 5 | `SSP.SSP0022_GET_STOCK_DETAIL` | MATCH | 1 | SP SSP0022_GET_STOCK_DETAIL | DYNAMIC@SSP0022_GET_STOCK_DETAIL (동적 SQL — 참조 테이블은 **확인 필요**) |
| 6 | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` | MATCH | 3 | SP SSP0022_SAVE_SHIPMENT_REQUEST | INSERT/UPDATE SSP_ANL_SHIP_REQ_EE, INSERT SSP_ANL_SHIP_REQ_EE_H, INSERT SCM_SYS_LOG_BATCH(EXEC PR_SCM_SYS_LOG_BATCH), SELECT SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SSP_MST_SITE_ITEM_EE_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M |
| 7 | `SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN` | MATCH | 1 | SP SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN | SSP_MST_SHIP_CALENDAR, SSP_ANL_SHIP_REQ_EE, SCP_MST_BOD_N_V, SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M |
| 8 | `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | MATCH | 1 (호출 지점 1곳, 진입 경로 9개) | SP SSP0022_GET_SHEET_CALENDAR_3SPAN | SCM_SYS_CALENDAR_M |
| 9 | `SSP.SSP0022_GET_ITEM_POPUP` | MATCH | 3 | SP SSP0022_GET_ITEM_POPUP | SCM_MST_SITE, SCP_MST_BOD_N_V, SCM_SYS_CALENDAR_M, SCP_MST_BOD_ITEM, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_SITE_ITEM_EE_V |
| 10 | `SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK` | MATCH | 3 (모두 진입점 미연결) | SP SSP0022_GET_BOD_ITEM_VALID_CHECK | SCP_MST_BOD_ITEM, SCP_MST_BOD_N_V, SCM_ADM_LOOKUP_MASTER_DETAIL |
| 11 | `SSP.SSP0002_GET_USER_INFO_LIST` | MATCH | 1 | SP SSP0002_GET_USER_INFO_LIST | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION |
| 12 | `SCM.SCM0001_GET_DIVISION` | MATCH | 1 (BodItemPopup) | SP SCM0001_GET_DIVISION | SCM_MST_DIVISION |
| 13 | `SCM.SCM0001_GET_SITE_BY_DIVISION` | MATCH | 1 (BodItemPopup) | SP SCM0001_GET_SITE_BY_DIVISION | SCM_MST_SITE (REF:VALUE, REF:NODES 검출) |
| 14 | `SSP.SSP0002_GET_BOD_VALID_CHECK` | MATCH | 1 (ShipmentRequestPopup BodValidChk:663, 진입점 미연결) | SP SSP0002_GET_BOD_VALID_CHECK | SCP_MST_BOD_N_V |
| 15 | `SCP.GET_DATE_RANGE_1MONTH` | MATCH | 1 (ShipmentRequestPopup) | [statement] foxquery_sql\SCP.GET_DATE_RANGE_1MONTH.sql | SCM_SYS_CALENDAR_M |

- 본 화면(current) 4003줄의 `SSP.SSP0002_GET_BOD_VALID_CHECK` 호출은 **주석 처리됨**이다. 활성 호출은 팝업 663줄 하나뿐이다.

## 4. 이벤트 배선 표 (45건)

| 대상 | 이벤트 | 핸들러 | 파일·위치 |
|---|---|---|---|
| this.formDown | Click | `btnExcelFormDownload_Click` | main Designer InitializeComponent:264 |
| this.btnExcelUpload | Click | `btnExcelUpload_Click` | main Designer:306 |
| this.chkPastPeriod | CheckedChanged | `chkPastPeriod_CheckedChanged_1` | main Designer:489 |
| this.spdMain | CellClick | `spdMain_CellClick_1` | main Designer:1459 |
| this | Load | `Form_Load` | main .ctor:347 |
| this.spdMain | TopChange | `SpdMain_TopChange` | main InitEvent:815 |
| this.spdDetail | TopChange | `SpdDetail_TopChange` | InitEvent:816 |
| this.cboBucketType | SelectedIndexChanged | `cboBucketType_SelectedIndexChanged` | InitEvent:818 |
| this.rdButton1 / rdButton2 / rdButton3 | CheckedChanged | `rdButton_Changed` | InitEvent:819 / 820 / 821 |
| this.chkSum | CheckedChanged | `chkSum_CheckedChanged` | InitEvent:822 |
| this.chkPastPeriod | CheckedChanged | `chkPastPeriod_CheckedChanged` | InitEvent:823 |
| this.btnMeasure | Click | `BtnMeasure_Click` | InitEvent:824 |
| this.btnItemId | Click | `btnItemId_Click` | InitEvent:825 |
| this.btnItemID2 | Click | `BtnItemID2_Click` | InitEvent:826 |
| this.btnSearch | Click | `BtnSearch_Click` | InitEvent:827 |
| this.btnRequestor | Click | `BtnRequestor_Click` | InitEvent:828 |
| this.spdMain | CellClick | `SpdMain_CellClick` | InitEvent:830 |
| this.spdDetail | ActiveSheetChanged | `SpdDetail_ActiveSheetChanged` | InitEvent:831, 834 (같은 핸들러를 2번 등록) |
| this.spdDetail | SheetTabClick | `SpdDetail_SheetTabClick` | InitEvent:833 |
| this.spdDetail | CellClick | `SpdDetail_CellClick` | InitEvent:836 |
| this.spdDetail | ComboSelChange | `SpdDetail_ComboSelChange` | InitEvent:837 |
| this.spdDetail | CellDoubleClick | `SpdDetail_CellDoubleClick` | InitEvent:838 |
| this.spdDetail | ClipboardPasted | `SpdDetail_ClipboardPasted` | InitEvent:839 |
| this.spdDetail | EditChange | `SpdDetail_EditChange` | InitEvent:840 |
| this.spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:841 |
| this.spdMain | Change | `SpdMain_Change` | InitEvent:842 |
| clbDivision_ID | SelectedIndexChanged | `clbDivision_ID_SelectedIndexChanged` | InitEvent:846 |
| clbCompany_ID | SelectedIndexChanged | `clbCompanyID_SelectedIndexChanged` | InitEvent:847 |
| cboPlanDate | SelectedIndexChanged | `cboPlanDate_SelectedIndexChanged` | InitEvent:848 (+=), clbCompanyID_SelectedIndexChanged:3669 (-=) → :3673 (+=) |
| this.clbDivision | SelectedIndexChanged | `clbDivision_SelectedIndexChanged` | BodItemPopup Designer:189 / ShipmentRequestPopup Designer:144 |
| this.btnButtonList | UsrButtonList_Click_Detected | `btnButtonList_UsrButtonList_Click_Detected` | BodItemPopup Designer:282 / ShipmentRequestPopup Designer:192 |
| this.spdMain | CellDoubleClick | `spdMain_CellDoubleClick` | BodItemPopup Designer:416 |
| this | Load | `Form_Load` | BodItemPopup .ctor:137 / ShipmentRequestPopup .ctor:143 |
| spdMain | CellClick | `SpdMain_CellClick` | ShipmentRequestPopup Form_Load:160 |
| spdMain | EditChange | `SpdMain_EditChange` | ShipmentRequestPopup Form_Load:162 |
| spdMain | ComboSelChange | `SpdMain_ComboSelChange` | ShipmentRequestPopup Form_Load:163 |
| spdMain | TextChanged | `SpdMain_TextChanged` | ShipmentRequestPopup Form_Load:164 |

배선에서 확인된 사실:
- `chkPastPeriod`의 CheckedChanged에는 핸들러 2개(`chkPastPeriod_CheckedChanged_1`, `chkPastPeriod_CheckedChanged`)가, 본 화면 `spdMain`의 CellClick에도 2개(`spdMain_CellClick_1`, `SpdMain_CellClick`)가 등록되어 있다.
- `SpdDetail_ActiveSheetChanged`는 같은 이벤트에 2번(831, 834) 등록되어 있다. 이벤트 1회에 핸들러가 2번 실행되는지는 런타임에서 **확인 필요**다.
- `clbCompanyID_SelectedIndexChanged`는 cboPlanDate 핸들러를 풀었다(3669) 다시 건다(3673). 회사를 바꾸는 동안 Plan-date 연쇄 이벤트를 막는 패턴이다.

## 5. Grid 구성 방식

**구성 방식: `HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)`**

| 층 | 내용 | 근거 |
|---|---|---|
| META(프레임워크) | `SpreadInfo.SetSheetHeaderColumn`이 SCM_MST_SHEET_COLUMNS로 컬럼을 만든다. 헤더 행 수: Shipment Request(Electrode)=3, Stock Detail=3, Shipment Request Detail=1, Shipment Request Detail Excel=1 | InitSpread:609/671/694/707 |
| DB루프(코드) | `InitSpreadDateColumn`이 `SSP0022_GET_SHEET_CALENDAR_3SPAN` 결과(GetSpdTitle)를 행마다 돌며 날짜 컬럼을 추가한다. 컬럼명에 `B_`가 있으면 숨김 텍스트 컬럼(폭 0), 아니면 숫자 컬럼(폭 100, 우측 정렬, 소수 3자리, 천단위 구분)이다. SAT은 Blue, SUN은 Red이고, 헤더 3단 span(LARGE/SMALL_CLASS_LABEL_NAME + "SUM")을 만든다 | InitSpreadDateColumn:753~799 |
| HARDCODED | 시트 `Project`(8컬럼), `Shipment Reqeust(Electrode)`(26컬럼)를 Add*Column으로 직접 구성한다 | InitSpread:208~215, 257~285 (어느 파일인지는 §8 참고) |
| 코드 표시 변경 | UOM 라디오(rdButton1/2/3)에 따라 BOH 9컬럼을 보이거나 숨기고, SetSpreadColumn이 컬럼 Tag 접두어(X_/Y_/Z_ × D_/W_/M_)와 Bucket·Sum·과거기간 조건으로 날짜 컬럼 표시를 바꾼다 | InitSpread:628~663, rdButton_Changed:1823~1858, SetSpreadColumn:1904~2081 |

시트와 Spread의 연결은 CreateSpread:571~574 AddSheet 기준이다. spdMain=Shipment Request(Electrode), spdDetail=Stock Detail과 Shipment Request Detail, spdSub=Shipment Request Detail Excel.

### 5-1. division별 차이
- 메타 규칙을 division 14종(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)으로 펼친 결과, 모든 시트의 컬럼 수가 **모든 division에서 같다** (Detail 16/0, Detail Excel 9/0, Shipment Request(Electrode) 28/0, Stock Detail 28/0, MEASURE 10/0).
- 코드 분기 중 division 변수를 비교하는 것은 검출되지 않았다. 판단불가(?) 1,890건은 모두 화면 컨트롤 값(라디오·Bucket·체크박스)에 따른 런타임 분기다.
- 결론: Grid는 **division이 아니라 UOM Type·Bucket·Sum·Including Past Period 선택에 따라** 달라진다.

## 6. 데이터·메타 소비 (요약)
- `GetSSPInnerTable`(SetChangeControl:386~421, 8회)이 CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID를 읽고, Filter에서 GROUP_ID·USER_ID와 `UserInfoContext.Current.NowGroupID`를 비교한다.
- `FP_Log2`(InitControls:444, 453)는 로그를 남긴다(LOGTYPE, NOTE, USER_ID).
- InitControls:488~491은 `dtShipmentInputPeriod` Rows[0]·[1]의 VALUE와 Diff_VALUE를 읽는다. dtShipmentInputPeriod를 어디서 가져오는지는 **확인 필요**다.
- `cboPlanDate_SelectedIndexChanged`는 CODE, FROM_DATE, TO_DATE를, `Plan_Current_Check`는 Tmp_dtPlanDate의 CODE, NAME, FROM_DATE, TO_DATE를 읽는다.
- `SpdDetail_ClipboardPasted`는 BOD 조회 결과에서 ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY를 셀에 채운다(982~992).

## 7. 주석 처리됨 (활성 집계 제외)
| 파일 | 줄 | 값 | 비고 |
|---|---:|---|---|
| main cs | 4003 | SSP.SSP0002_GET_BOD_VALID_CHECK | 주석 처리됨 |
| BodItemPopup.cs | 396 | DM.Get_Division | 주석 처리됨 (FoxQuery 미등록) |
| ShipmentRequestPopup.cs | 1226 | SCP.SCM0001_GET_SCP_DAY_PERIOD | 주석 처리됨 |

## 8. 확인 필요 항목
1. 두 팝업을 본 화면의 어느 핸들러가 여는지(Fact Pack에 호출 사실 없음).
2. `Project`(InitSpread:208~215)와 `Shipment Reqeust(Electrode)`(InitSpread:257~285) 하드코딩 시트가 어느 파일·클래스에 있는지. 줄 번호로 보면 팝업 InitSpread일 수 있으나 grid_code.csv 발췌가 잘려 확정하지 못했다.
3. 진입점 미연결 호출(BodItemValidChk_main:4094, BodItemValidChk:4143, 팝업 BodValidChk:663·BodItemValidChk:770, 팝업 필드 초기화 5건)이 실제로 실행되는지.
4. `SSP0022_GET_REQUEST_DETAIL`과 `SSP0022_GET_STOCK_DETAIL`은 동적 SQL이라 참조 테이블이 추출되지 않았다.
5. 프레임워크 메타 소비 표에서 `SaveData`가 `PersonalSettingPopup.SaveData`로 매칭되었다(SaveButton:1799 등). 화면 자체 SaveData(2863)·팝업 SaveData(539)와의 이름 충돌로 생긴 오매칭인지 확인해야 한다.
6. grid_effective의 Detail/Stock/Detail Excel 시트에 붙은 BOH 9컬럼 `CODE_ONLY_CHANGE`는 시트 힌트가 없는 `rdButton_Changed`(1823~1858)에서 온 것이다. 실제로 어느 시트의 컬럼을 바꾸는지 확인해야 한다.
7. splitContainer1의 Orientation·SplitterDistance 값(props.csv 발췌가 잘림).
8. SpdDetail_SheetTabClick의 TabIndex 2는 `Shipment Request Detail Excel`로 바꾸지만, AddSheet에서는 이 시트가 spdSub에 붙어 있다. 실제 탭 구성을 확인해야 한다.
