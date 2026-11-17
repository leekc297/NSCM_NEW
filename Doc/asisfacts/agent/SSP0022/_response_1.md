=== FILE: analysis.md ===
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

=== FILE: source_links.md ===
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

=== FILE: web_components.md ===
# SSP0022 Web 컴포넌트 매핑 (React + Wijmo)

## 1. 화면 배치 (props.csv 기준)
| 영역 | 컨트롤 | 사실 |
|---|---|---|
| 조회조건 패널 | usrConditionPanel1 | Dock=Top, Size(1689, 75), UsrPanelType=HidePanel |
| 조회조건 레이아웃 | usrLayoutControl2 | Dock=Top, Size(1689, 72); layoutControlGroup2 Size(1689, 78) |
| 본문 분할 | splitContainer1 (parent=this) | Panel1 = spdMain, Panel2 = spdDetail + spdSub + usrLayoutControl3 |
| 하단 조회조건 | usrLayoutControl3 (Panel2) | btnRequestor, drpPeriod2, txtModelId2, txtRequestor, textNickName2, btnSearch, txtItemld2, btnItemID2, txtLotID |

- splitContainer1의 **Orientation, SplitterDistance, Size**는 props.csv 발췌가 잘려 **확인 필요**다. 따라서 상/하인지 좌/우인지, 분할 비율이 얼마인지 확정하지 않는다. 확인할 곳은 `SSP0022_ShipmentRequestElectrode.Designer.cs`의 splitContainer1 속성 블록이다.
- 구조로 보면 위(또는 앞) 영역은 PSI 메인 그리드(spdMain), 아래(또는 뒤) 영역은 상세 조건과 상세 그리드(spdDetail 탭, spdSub)다.

## 2. 컨트롤 → React/Wijmo 매핑

### 2-1. 상단 조회조건 (usrLayoutControl2)
| As-is 컨트롤 | 유형 | 라벨(원문) | 속성 사실 | TO-BE 후보 |
|---|---|---|---|---|
| clbCompany_ID | UsrCombo | "Company*" (layoutControlItem1) | Size(156,20) | Wijmo ComboBox (필수) |
| clbDivision_ID | UsrCombo | "Division*" (lblCombo1) | Size(125,20) | Wijmo ComboBox (필수) |
| cboPlanDate | UsrCombo | "Plan-date*" (PlanDate) | Size(113,20) | Wijmo ComboBox (필수) |
| drpPeriod | UsrDateRangePicker | "Period*" (layoutControlItem6) | **Enabled=false**, Size(197,20) | 날짜범위(읽기 전용) |
| cboBucketType | UsrCombo | "Bucket" (lblBucket) | Size(70,20) | Wijmo ComboBox |
| clbPlantSite | UsrCheckedList | "Plant" (layoutControlItem7) | Size(115,21) | Wijmo MultiSelect |
| txtItemId + btnItemId | UsrMultiLineEditor + UsrButton | "Material" (lblItemId) | Size(100,21) / (39,24) | 멀티라인 입력 + 팝업 버튼 |
| lblUOMType | UsrLabel | "UOM Type" | Size(66,25) | 라벨 |
| rdButton1 | UsrRadio | "UOM" | **Checked=true** | Radio |
| rdButton2 | UsrRadio | "Cell" | — | Radio |
| rdButton3 | UsrRadio | "Pancake m" | — | Radio |
| chkSum | UsrCheckBox | "Sum" | — | CheckBox |
| chkPastPeriod | UsrCheckBox | "Including Past Period" | **Visible=false** | CheckBox(숨김) |
| btnMeasure | UsrButton | 텍스트 확인 필요 (layoutControlItem10) | Size(39,25) | Measure 선택 버튼 |
| chkDelegateModel | UsrCheckBox | "Delegate Model" | — | CheckBox |
| chkTeamLeader | UsrCheckBox | "Team Leader" | — | CheckBox |
| chkPartLeader | UsrCheckBox | "Part Leader" | — | CheckBox |
| chkMyModel | UsrCheckBox | "My Model" | **Visible=false** | CheckBox(숨김) |
| txtModelId / btnModelId | UsrMultiLineEditor / UsrButton | 라벨 확인 필요 | btnModelId **Visible=false** | 입력 |
| textNickName | TextBox | 라벨 확인 필요 (lblNickname 항목 있음) | Size(104,20) | Input |
| clbCellType | UsrCheckedList | 라벨 확인 필요 | Size(86,21) | MultiSelect |
| formDown | UsrButton | "Excel Form" | Size(90,25) | 버튼 |
| btnExcelUpload | UsrButton | "Upload" | Size(70,25) | 버튼 |

### 2-2. 하단 상세 조건 (usrLayoutControl3)
| As-is 컨트롤 | 유형 | 라벨 | TO-BE 후보 |
|---|---|---|---|
| drpPeriod2 | UsrDateRangePicker | 확인 필요 | 날짜범위 |
| txtModelId2 | UsrMultiLineEditor | 확인 필요 | 입력 |
| txtRequestor + btnRequestor | UsrMultiLineEditor + UsrButton | 확인 필요 | 입력 + 사용자 팝업 |
| textNickName2 | TextBox | 확인 필요 | Input |
| txtItemld2 + btnItemID2 | UsrMultiLineEditor + UsrButton | 확인 필요 | 입력 + 팝업 |
| txtLotID | UsrMultiLineEditor | 확인 필요 | 입력 |
| btnSearch | SimpleButton | 확인 필요 | 상세 조회 버튼 |

### 2-3. Grid
| As-is | 시트 | TO-BE |
|---|---|---|
| spdMain (Panel1) | Shipment Request(Electrode) | Wijmo FlexGrid (헤더 3단, 동적 날짜 컬럼) |
| spdDetail (Panel2) | Stock Detail, Shipment Request Detail | 탭 + Wijmo FlexGrid |
| spdSub (Panel2) | Shipment Request Detail Excel | Wijmo FlexGrid (엑셀 양식/업로드용) |
| BodItemPopup spdMain | `Project` (추정 — 확인 필요) | 팝업 FlexGrid |
| ShipmentRequestPopup spdMain | `Shipment Reqeust(Electrode)` (추정 — 확인 필요) | 팝업 FlexGrid (편집) |

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

모든 시트에서 division 14종의 결과가 같다. division에 따른 표시 차이는 없다.

### 3-1. `Shipment Request(Electrode)` — META+코드연결, 표시 22 (?9)
메타 28/0과 MEASURE 10/0 위에 날짜 DB 루프 컬럼이 붙는다.

| 컬럼 | 라벨 | 메타 | 코드 변경 |
|---|---|---|---|
| DIVISION_ID | Div | 기본 | |
| SCM_SITE_ID | SCM_SITE_ID | 기본 | |
| PLANT_ID | Plant | 기본 | |
| FROM_SITE / TO_SITE | From Site / To Site | 기본 | |
| MODEL_ID / ITEM_ID / NICK_NAME | Model / Material / Nick Name | 기본 | |
| CELL_TYPE / ELECTRODE_TYPE | Cell Type / Elec Type | 기본 | |
| BOD_ID / BOD_LT / OPERATION_LT | Bod ID / BOD L/T / Oper. L/T | 기본 | |
| INCOTERMS / TRANSPORT_MODE | Incoterms / Trans Mode | 기본 | |
| LAST_UPDATED_BY | Requestor | 기본 | |
| PSI_NAME / MEASURE_NAME | PSI / Measure | 기본 | |
| TEMPCOLUMN | TEMPCOLUMN | 기본 | |
| TOT_BOH_QTY / JR_BOH_QTY / PC_BOH_QTY | BOH / J/R / Pancake | 기본 | UOM 라디오일 때 표시 |
| TOT/JR/PC_BOH_QTY_CELL | BOH / J/R / Pancake | 기본 | Cell 라디오일 때 표시 |
| TOT/JR/PC_BOH_QTY_PCM | BOH / J/R / Pancake | 기본 | Pancake m 라디오일 때 표시 |
| BACK_COLOR, CONFIRM_DAY("Confrim Day"), MEASURE, NPC_ITEM_ID("Noteched Pancake"), ORIGIN_DIVISION_ID, TOT_BOH_JR | — | 숨김 | |
| (동적) 날짜 컬럼 | SSP0022_GET_SHEET_CALENDAR_3SPAN COLUMN_LABEL_NAME | — | `B_` 포함이면 숨김, 아니면 숫자(3자리). Tag 접두어 X_/Y_/Z_ × D_/W_/M_에 따라 표시 |

라벨 원문의 오탈자("Confrim Day", "Noteched Pancake")는 메타 원문 그대로다.

### 3-2. `Stock Detail` — META+코드연결, 표시 31 (?9)
기본 표시 컬럼:

| 컬럼 | 라벨 |
|---|---|
| DIVISION_ID | Div |
| PLANT_ID | Plant |
| MODEL_ID / ITEM_ID / NICK_NAME | Model / Material / Nick Name |
| CELL_TYPE | Cell Type |
| VERSION | Version |
| LOT_ID / PALLET_ID / LANE | Lot ID / Pallet ID / Lane |
| OPERATION_ID / STORAGE_ID | Operation / Storage |
| TOTAL_QTY_UOM / TOTAL_QTY_PCM | UOM / Pancake M |
| GMES_QTY_UOM / GMES_QTY_PCM | UOM / Pancake M |
| IWMS_QTY_UOM / IWMS_QTY_PCM | UOM / Pancake M |
| OWMS_QTY_UOM / OWMS_QTY_PCM | UOM / Pancake M |
| MES_HOLD_YN / QMS_HOLD_YN / IWMS_HOLD_YN / OWMS_HOLD_YN | MES / QMS / iWMS / oWMS Hold YN |
| AVAILABLE_YN | Available Stock YN |
| CHANGE_STATUS | Change Status |
| EXPIRATION_DATE | Expiration Date |
| PACKAGE_TYPE_CODE | Package Type (oWMS) |

숨김: FROM_SITE("Site"). 그 밖에 BOH 9컬럼 CODE_ONLY_CHANGE(?)가 있으며, 실제로 이 시트에 적용되는지는 확인 필요다.

### 3-3. `Shipment Request Detail` — META+코드연결, 표시 19 (?9)
- 기본: DIVISION_ID(Div), ORIGIN_DIVISION_ID(Org Div), FROM_SITE(From Site*), TO_SITE(To Site*), MODEL_ID(Model*), ITEM_ID(Material*), NICK_NAME(Nick Name), SHIPMENT_DATE(**Shipment ETA***), SHIPMENT_QTY(Qty*), INCOTERMS(Incoterms*), TRANSPORT_MODE(Trans Mode*), BOD_ID, CONFIRM_DAY, REQUEST_DATE(Request Date), REQUESTOR(Requestor), EDIT_FLAG
- 숨김: SCM_SITE_ID, PLANT_ID, LT, ETD, ETA, ROUTE_ID, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, ELECTRODE_YN, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID
- 숨김 컬럼 중 ROUTE_ID~TO_CITY 8종은 `SpdDetail_ClipboardPasted`가 BOD 조회 결과로 채운다.
- 셀 콤보: InsertRow:1481~1482에서 FROM_SITE·TO_SITE에 PlantByElectordeShipFromSite/ToSite 콤보를 설정한다.

### 3-4. `Shipment Request Detail Excel` — META+코드연결, 표시 12 (?9)
- 기본: COMPANY_ID(Company*), DIVISION_ID(Div*), FROM_SITE(FromSite*), TO_SITE(ToSite*), ITEM_ID(Material*), YYYYMMDD(yyyyMMdd*), QTY(Qty*), INCOTERMS(Incoterms*), TRANSPORT_MODE(Trans Mode*)

### 3-5. `Project` — 코드 하드코딩 전용(메타 없음), 8컬럼
DIVISION_ID(Division), DIVISION_NAME(Division), MODEL_ID(Model), ITEM_ID(Material), INCOTERMS(Incoterms), TRANSPORT_MODE(Transport Mode), BOD_ID(BOD ID), CONFIRM_DAY(Confirm Day) — InitSpread:208~215

### 3-6. `Shipment Reqeust(Electrode)` — 코드 하드코딩 전용(메타 없음), 26컬럼
시트명의 "Reqeust" 오탈자는 원문 그대로다. InitSpread:257~285.

| 유형 | 컬럼(라벨) |
|---|---|
| Combo | DIVISION_ID(Div*), SCM_SITE_ID(SCM Site*), PLANT_ID(Plant), FROM_SITE(From Site*), TO_SITE(To Site*), INCOTERMS(Incoterms*), TRANSPORT_MODE("Trans Mode* ") |
| Text | MODEL_ID(Model*), ITEM_ID(Material*), NICK_NAME(Nick Name) |
| Date | SHIPMENT_DATE(Shipment Date*), ETD, ETA |
| Num | SHIPMENT_QTY("Qty* "), LT(L/T(Day)) |
| Text(라벨=필드명) | ROUTE_ID, BOD_ID, CONFIRM_DAY, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, ELECTRODE_YN, ORIGIN_FROM_DIVISION_ID |

## 4. 시트 연결 규칙
| 시트 | 연결 규칙 | Spread | 헤더 행 수 (AddSheet 인자) |
|---|---|---|---|
| Shipment Request(Electrode) | META+코드연결 | spdMain | 3 ¦ 1 ¦ 35 |
| Stock Detail | META+코드연결 | spdDetail (탭 0) | 3 ¦ 1 ¦ 60 |
| Shipment Request Detail | META+코드연결 | spdDetail (탭 1) | 1 ¦ 1 ¦ 60 |
| Shipment Request Detail Excel | META+코드연결 | spdSub (AddSheet), SheetTabClick의 탭 2 | 1 ¦ 1 ¦ 60 |
| Project | 코드 하드코딩 전용 | 확인 필요 | — |
| Shipment Reqeust(Electrode) | 코드 하드코딩 전용 | 확인 필요 | — |

AddSheet 인자 `3 ¦ 1 ¦ 35` 중 둘째와 셋째 값이 무엇을 뜻하는지는 프레임워크 시그니처를 보고 **확인 필요**다.

## 5. 표시 규칙 (코드)
| 조건 | 결과 |
|---|---|
| rdButton1(UOM) | TOT/JR/PC_BOH_QTY 표시, _CELL·_PCM 숨김. 날짜 컬럼 X_ 표시, Y_·Z_ 숨김 |
| rdButton2(Cell) | _CELL 표시, 나머지 숨김. Y_ 표시, X_·Z_ 숨김 |
| rdButton3(Pancake m) | _PCM 표시, 나머지 숨김. Z_ 표시, X_·Y_ 숨김 |
| Bucket=DAILY | ?_D_·?_W_ 표시(1917 등), ?_M_·?_W_ = chkSum.Checked(1922 등). W가 두 조건에 모두 걸려 최종값은 확인 필요 |
| Bucket=WEEKLY | ?_D_ 숨김, ?_W_ 표시, ?_M_ = chkSum.Checked |
| Bucket=MONTHLY | ?_D_·?_W_ 숨김, ?_M_ 표시 |
| Including Past Period 미체크 | 헤더 2행이 "SUM"이 아닌 컬럼 중 날짜가 기준일보다 과거인 컬럼은 숨김 (SetSpreadColumn:2081) |
| 주말 | SAT=Blue, SUN=Red 글자색 |

=== FILE: oracle_migration.md ===
# SSP0022 Oracle 전환 분석

## 1. 호출 SP 인벤토리 (13종 + statement 1종)
| SP | 호출 위치 | 참조 객체 수(추출) | 주요 참조 / EXEC 체인 |
|---|---|---:|---|
| `DM0003_GET_BUCKET_TYPE_CODE` | M GetBucketType:2096 | 2 | SELECT SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SSP0022_GET_SHIPMENT_PSI` | M FindData_Main:2185 | 52 | 아래 1-1 |
| `SSP0022_GET_REQUEST_DETAIL` | M FindData_Request_Detail:2339 | 2 | DYNAMIC@SSP0022_GET_REQUEST_DETAIL (동적 SQL 내부 객체 미추출) |
| `SSP0022_GET_STOCK_DETAIL` | M FindData_Detail:2484 | 2 | DYNAMIC@SSP0022_GET_STOCK_DETAIL (동적 SQL 내부 객체 미추출) |
| `SSP0022_SAVE_SHIPMENT_REQUEST` | M SaveData_Detail:2671, M SaveData:2863, SP SaveData:539 | 21 | 아래 1-2 |
| `SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN` | M FindData_Request_Detail_DownLoad:3043 | 10 | FN_GET_SSP_ETA_DATE, SSP_MST_SHIP_CALENDAR, SSP_ANL_SHIP_REQ_EE, STRING_SPLIT, SCP_MST_BOD_N_V, SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M |
| `SSP0022_GET_SHEET_CALENDAR_3SPAN` | M GetSpdTitle:3869 | 2 | SCM_SYS_CALENDAR_M |
| `SSP0022_GET_ITEM_POPUP` | M FindData_BOD:3907, BP FindData:258, SP FindData:362 | 8 | SCM_MST_SITE, SCP_MST_BOD_N_V, SCM_SYS_CALENDAR_M, SCP_MST_BOD_ITEM, STRING_SPLIT, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_SITE_ITEM_EE_V |
| `SSP0022_GET_BOD_ITEM_VALID_CHECK` | M 4094, M 4143, SP 770 (모두 진입점 미연결) | 4 | SCP_MST_BOD_ITEM, SCP_MST_BOD_N_V, SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SSP0002_GET_USER_INFO_LIST` | M GetSSPUserCheck:4448 | 6 | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION |
| `SCM0001_GET_DIVISION` | BP GetDivision:395 | 2 | SCM_MST_DIVISION |
| `SCM0001_GET_SITE_BY_DIVISION` | BP GetDivisionbyScmSite:409 | 4 | SCM_MST_SITE, REF:VALUE, REF:NODES |
| `SSP0002_GET_BOD_VALID_CHECK` | SP BodValidChk:663 (진입점 미연결). M 4003은 주석 처리됨 | 2 | SCP_MST_BOD_N_V |
| statement `SCP.GET_DATE_RANGE_1MONTH` | SP GetDayRange:1225 | 1 | foxquery_sql\SCP.GET_DATE_RANGE_1MONTH.sql → SCM_SYS_CALENDAR_M |

### 1-1. `SSP0022_GET_SHIPMENT_PSI` 상세 (참조 객체 52건)
- 실테이블·뷰: SCM_MST_TITLESET_USER, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_PLAN_EE, SSP_MST_MODEL_USER_EE, SSP_MST_DELEGATE, SSP_ANL_BOH_CUTOFF_EE, SSP_DNM_SHIP_RESULT_OWMS_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_SITE_ITEM_EE_V, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_REQ_EE, SSP_DNM_FP_MRP_INTRANSIT_SN, SCP_MST_FINAL_ITEM, SCM_MST_SHEET_MEASURE, SSP_MST_SHIP_MASTER_EE, SCP_MST_BOD_N_V, SCM_CODE_LOOKUP_VALUE, SCM_MST_SITE_CUSTOMER
- 함수: FN_GET_LOOKUP_VALUE, FN_GET_SSP_ANL_SHIP_FROZEN, FN_GET_SSP_SITE_INFO, FN_GET_SSP_ETA_DATE, UF_FX_STRING_SPLIT, STRING_SPLIT
- # 임시테이블: #TBLDYNAMICTITLEST_SSP0022, #TMP_RESULT_TABLE, #TMP_PLAN_ITEM_CUTOFF, #TMP_BOH_CUTOFF_EE, #TMP_SHIP_PLAN_ETD, #TMP_INTRANSIT_ETA, #TMP_ROWDATA, #TMP_INV_REQ, #TMP_PLAN_INV, #TBLDYNAMIC_REQUESTOR, #TMP_RESULT_PIVOT_TABLE, #TMP_ROWDATA_OLD, #TMP_RESULT_TABLE_0LD, #TMP_RESULT_PIVOT_TABLE_OLD
- 동적 SQL: DYNAMIC@SSP0022_GET_SHIPMENT_PSI

### 1-2. `SSP0022_SAVE_SHIPMENT_REQUEST` 상세 (참조 객체 21건)
- 쓰기: UPDATE A(별칭), INSERT SSP_ANL_SHIP_REQ_EE, INSERT SSP_ANL_SHIP_REQ_EE_H(이력), INSERT SCM_SYS_LOG_BATCH
- EXEC 체인: PR_SCM_SYS_LOG_BATCH
- 배열 파싱: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL
- 함수: FN_GET_SSP_ETD_DATE
- # 임시테이블: #TBLDYNAMIC_SSP0022_SHPIMENTREQ, #TBLDYNAMIC_SSP0022_SHPIMENTREQ_H
- 조회: SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_SITE_ITEM_EE_V, SSP_ANL_SHIP_REQ_EE, SCM_SYS_CALENDAR_M

## 2. 공통코드 분기 (`biz:CommonData.CommonDataList`)
| code | 분기 SP : 테이블 | 호출 위치 |
|---|---|---|
| Incoterms | UP_FX_GetCommonDataList : SCM_ADM_LOOKUP_MASTER_DETAIL / UP_FX_GetCommonDataList_SCP : SCP_MST_BOD_V / UP_FX_GETCOMMONDATALIST_DM : SCM_ADM_LOOKUP_MASTER_DETAIL / DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST_COMMON : SCM_ADM_LOOKUP_MASTER_DETAIL | SP 46, 1246 |
| LookupCommon | UP_FX_GetCommonDataList : SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | SP 43, 44, 49 |
| PlantByElectordeShipFromSite | UP_FX_GetCommonDataList : SCM_ADM_LOOKUP_MASTER_DETAIL | M 1476, BP 173, SP 943, 1240 |
| PlantByElectordeShipToSite | UP_FX_GetCommonDataList : SCM_ADM_LOOKUP_MASTER_DETAIL | M 1477, BP 174, SP 945, 1242 |
| PlantEE | UP_FX_GetCommonDataList : SCM_MST_SITE | M 3664 |
| TransportMode | UP_FX_GetCommonDataList : SCM_ADM_LOOKUP_MASTER_DETAIL | SP 47, 1247 |

- Incoterms가 4개 분기 중 어느 쪽으로 실행되는지는 호출 인자에 달려 있어 **확인 필요**다.
- "Electorde" 철자는 코드 Type 원문 그대로다.

## 3. FoxQuery 미등록·직접 호출
| 항목 | 사실 |
|---|---|
| FoxQuery 미등록 | DM.Get_Division (BP:396) — 주석 처리됨이라 전환 대상 아님 |
| statement(비 SP) | SCP.GET_DATE_RANGE_1MONTH — FoxQuery SQL 파일 |
| 직접 SQL 호출 | Fact Pack에 기록 없음 |
| 주석 처리됨 | SSP.SSP0002_GET_BOD_VALID_CHECK(M:4003), SCP.SCM0001_GET_SCP_DAY_PERIOD(SP:1226) |

## 4. Oracle 전환 확인 포인트 (추출 사실 기준)
1. **STRING_SPLIT / UF_FX_STRING_SPLIT**: MSSQL 전용이며 금지 키워드 ⑩에 해당한다. SSP0022_GET_SHIPMENT_PSI, SSP0022_GET_ITEM_POPUP, SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN에서 검출되었다. Oracle 분할 함수나 쿼리로 대체해야 한다.
2. **# 임시테이블**: SSP0022_GET_SHIPMENT_PSI에 14종, SSP0022_SAVE_SHIPMENT_REQUEST에 2종이 있다. Oracle GTT로 바꿔야 하며, 같은 세션에서 다시 조회할 때를 대비해 GTT 비우기 시점을 확인해야 한다.
3. **동적 SQL**: SSP0022_GET_SHIPMENT_PSI, SSP0022_GET_REQUEST_DETAIL, SSP0022_GET_STOCK_DETAIL이 동적 SQL을 쓴다. 내부 객체와 MSSQL 구문이 추출되지 않았으므로 원문을 전수 확인해야 한다. PSI의 #TMP_RESULT_PIVOT_TABLE이 실제로 PIVOT 구문을 쓰는지도 원문으로 확인해야 한다.
4. **REF:VALUE, REF:NODES** (SCM0001_GET_SITE_BY_DIVISION): 파서가 이 참조를 검출했다. 무엇을 쓰는지(XML 메서드 등)는 원문 **확인 필요**다.
5. **UPDATE A(별칭 UPDATE)** (SSP0022_SAVE_SHIPMENT_REQUEST): MSSQL `UPDATE alias FROM` 형식으로 보인다. Oracle에서는 MERGE나 상관 서브쿼리로 바꿔야 하며, 원문 확인이 필요하다.
6. **SCM_ARR_SPL_CNT / SCM_ARR_SPL_VAL**: 화면에서 넘긴 배열 문자열을 파싱하는 함수다. Oracle 쪽 동일 함수가 있는지 확인해야 한다.
7. **EXEC PR_SCM_SYS_LOG_BATCH**: 저장 SP 안의 로그 프로시저 체인이다. Oracle 패키지 쪽 대응 프로시저를 확인해야 한다.
8. **사용자 함수 이관**: FN_GET_SSP_ETA_DATE, FN_GET_SSP_ETD_DATE, FN_GET_LOOKUP_VALUE, FN_GET_SSP_ANL_SHIP_FROZEN, FN_GET_SSP_SITE_INFO가 Oracle에 있는지 확인해야 한다.
9. **이력 테이블**: 저장 시 SSP_ANL_SHIP_REQ_EE_H에 INSERT한다. 이 동작을 빠뜨리면 안 된다.

## 5. 난이도 (사실 기반 지표만)
| SP | 근거 지표 |
|---|---|
| SSP0022_GET_SHIPMENT_PSI | 참조 객체 52건, # 임시테이블 14종, 동적 SQL, STRING_SPLIT — 추출 지표가 가장 많다 |
| SSP0022_SAVE_SHIPMENT_REQUEST | 참조 객체 21건, 쓰기 4종, 이력, EXEC 체인 |
| SSP0022_GET_REQUEST_DETAIL / SSP0022_GET_STOCK_DETAIL | 동적 SQL이라 추출된 지표만으로는 판단 불가 → 확인 필요 |
| 나머지 | 참조 객체 2~10건 |

=== FILE: tobe_design.md ===
# SSP0022 TO-BE 설계 기초 자료

> 아래는 As-is 사실에서 도출한 **후보**다. API 경로명은 확정값이 아니다.

## 1. 조회조건 (컨트롤 기준)

### 1-1. 상단 메인 조회 (FindButton → `SSP0022_GET_SHIPMENT_PSI`)
| 라벨(원문) | As-is 컨트롤 | 필수 | 비고 |
|---|---|---|---|
| Company* | clbCompany_ID | Y | 바꾸면 PlantEE 재조회 + 그리드 재구성(GetSpdTitle) |
| Division* | clbDivision_ID | Y | 바꾸면 clbDivision_ID_SelectedIndexChanged 실행 (DIVISION_ID 읽음) |
| Plan-date* | cboPlanDate | Y | 바꾸면 FROM_DATE/TO_DATE 반영 + GetSpdTitle |
| Period* | drpPeriod | Y | Enabled=false (Plan-date가 정한 값을 표시) |
| Bucket | cboBucketType | — | DM0003_GET_BUCKET_TYPE_CODE (DAILY/WEEKLY/MONTHLY 분기 존재) |
| Plant | clbPlantSite | — | 다중 선택 |
| Material | txtItemId (+btnItemId) | — | 멀티라인 |
| UOM Type | rdButton1 "UOM"(기본) / rdButton2 "Cell" / rdButton3 "Pancake m" | — | 표시만 바꿈 (재조회 없음) |
| Sum | chkSum | — | 표시만 바꿈 |
| Including Past Period | chkPastPeriod | — | Visible=false |
| Delegate Model / Team Leader / Part Leader | chkDelegateModel / chkTeamLeader / chkPartLeader | — | SP 인자와 어떻게 연결되는지 확인 필요 |
| My Model | chkMyModel | — | Visible=false |
| (라벨 확인 필요) | txtModelId, textNickName, clbCellType | — | |

### 1-2. 하단 상세 조회 (btnSearch → `SSP0022_GET_REQUEST_DETAIL` + `SSP0022_GET_STOCK_DETAIL`)
drpPeriod2, txtModelId2, txtRequestor(+btnRequestor), textNickName2, txtItemld2(+btnItemID2), txtLotID. 라벨은 모두 확인 필요다.

## 2. 액션별 호출 API 후보
| 액션 | As-is 경로 | 호출 SP | TO-BE API 후보 |
|---|---|---|---|
| 화면 진입 | Form_Load | DM0003_GET_BUCKET_TYPE_CODE, SSP0022_GET_SHEET_CALENDAR_3SPAN | GET bucket-type, GET sheet-calendar |
| 회사 변경 | clbCompanyID_SelectedIndexChanged | CommonData PlantEE, SSP0022_GET_SHEET_CALENDAR_3SPAN | GET common-code(PlantEE), GET sheet-calendar |
| Plan-date 변경 | cboPlanDate_SelectedIndexChanged | SSP0022_GET_SHEET_CALENDAR_3SPAN | GET sheet-calendar |
| 조회 | FindButton > FindData_Main | SSP0022_GET_SHIPMENT_PSI (+3SPAN) | POST shipment-psi/search |
| Measure | BtnMeasure_Click | SSP0022_GET_SHEET_CALENDAR_3SPAN | (그리드 재구성) |
| 메인 더블클릭 | SpdMain_CellDoubleClick | SSP0022_GET_SHIPMENT_PSI (+3SPAN) | POST shipment-psi/search |
| 상세 조회 | BtnSearch_Click | SSP0022_GET_REQUEST_DETAIL, SSP0022_GET_STOCK_DETAIL (+3SPAN) | POST request-detail/search, POST stock-detail/search |
| 행추가 | InsertButton > InsertRow | CommonData PlantByElectordeShipFromSite/ToSite | GET common-code (셀 콤보) |
| 수정 | EditButton > GetSSPUserCheck | SSP0002_GET_USER_INFO_LIST | GET ssp-user-check |
| 저장 | SaveButton > SaveData / SaveData_Detail | SSP0022_SAVE_SHIPMENT_REQUEST → 재조회(PSI 또는 REQUEST_DETAIL) | POST shipment-request/save |
| 상세 셀 변경·더블클릭·붙여넣기 | SpdDetail_ComboSelChange / CellDoubleClick / ClipboardPasted > FindData_BOD | SSP0022_GET_ITEM_POPUP | GET bod-item |
| Excel Form | btnExcelFormDownload_Click | SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN | GET request-detail/excel-form |
| Upload | btnExcelUpload_Click | SSP0022_GET_SHIPMENT_PSI, SSP0022_GET_REQUEST_DETAIL (+3SPAN) | 업로드 후 재조회 (업로드 자체를 저장하는 호출은 Fact Pack에 없음 → 확인 필요) |
| BOD 팝업 | SSP0022_BodItemPopup Form_Load / 조회 | SCM0001_GET_DIVISION, SCM0001_GET_SITE_BY_DIVISION, SSP0022_GET_ITEM_POPUP, CommonData From/To Site | 팝업 API |
| 출하요청 팝업 | SSP0022_ShipmentRequestPopup Form_Load / Division 변경 / 저장 | SCP.GET_DATE_RANGE_1MONTH, CommonData 4종, SSP0022_GET_ITEM_POPUP, SSP0022_SAVE_SHIPMENT_REQUEST | 팝업 API |
| 유효성 검사(미연결) | BodItemValidChk 등 | SSP0022_GET_BOD_ITEM_VALID_CHECK, SSP0002_GET_BOD_VALID_CHECK | 실행 여부 확인 후 결정 |

## 3. division별 Grid 변형 요약
- 메타 컬럼 수는 division 14종 모두 같다: Detail 16, Detail Excel 9, Shipment Request(Electrode) 28(+MEASURE 10), Stock Detail 28.
- 코드에는 division 분기가 없다.
- 실제 변형 축은 UOM Type 라디오(BOH 3계열 × 9컬럼, 날짜 Tag X_/Y_/Z_), Bucket(D_/W_/M_), Sum, Including Past Period다. TO-BE에서는 이것을 **클라이언트 컬럼 Visible 토글**로 구현하는 방안이 후보다. As-is에서도 재조회 없이 표시만 바꾼다(rdButton_Changed, chkSum_CheckedChanged → SetSpreadColumn).

## 4. 권한(C/R/U/D) 관련 사실
| 사실 | 출처 |
|---|---|
| 메뉴 권한 메타 TB_FX_GroupMenuAuth 13행 (C/R/U/D 값은 Fact Pack에 없음 → 확인 필요) | DB 메타 §8 |
| 프레임워크 버튼: FindButton, InsertButton, EditButton, SaveButton 오버라이드 | flow.csv |
| 수정(EditButton) 시 `SSP0002_GET_USER_INFO_LIST`로 SSP 사용자 검사 (TB_FX_USERGROUPAUTHEXTENTION 등 참조) | M GetSSPUserCheck:4448 |
| SetChangeControl에서 GROUP_ID, USER_ID를 `UserInfoContext.Current.NowGroupID` 기준으로 필터 | M 379~380 |
| 상세 행추가는 `siDetail.IsLock(...) == false`이고 활성 시트가 "Shipment Request Detail"일 때만 콤보 설정 | M InsertRow:1481 조건 |

## 5. 미확정 사항
1. 팝업 2종을 여는 핸들러.
2. 하드코딩 시트 Project / Shipment Reqeust(Electrode)가 어느 파일에 있는지.
3. 진입점 미연결 유효성 검사 SP의 실제 사용 여부.
4. 동적 SQL SP 3종의 내부 구조와 참조 테이블.
5. splitContainer1의 분할 방향과 비율.
6. 상단·하단 조회조건 중 라벨이 Fact Pack에서 잘린 컨트롤들의 라벨 원문.
7. Excel Upload의 저장 경로 (Fact Pack에는 업로드 후 재조회 호출만 있음).
8. TB_FX_SearchCondition 141행, SCM_MST_TITLESET_USER 4행, SCM_ADM_EXCEL_COLUMNS 1행, SCM_ADM_LOOKUP_MASTER_DETAIL 3행의 내용.
9. Delegate Model / Team Leader / Part Leader 체크가 SP 인자로 어떻게 넘어가는지.
