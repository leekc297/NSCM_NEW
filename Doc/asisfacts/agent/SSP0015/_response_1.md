=== FILE: analysis.md ===
# SSP0015 Shipment PSI — As-is 분석

> 이 문서는 AsisFacts 정적 추출 결과(Fact Pack)만 근거로 작성했습니다. Fact Pack에 없는 내용은 **확인 필요**로 표기했습니다.
> 주석 처리된 호출(commented_calls)은 현행 기능에 넣지 않았고, §8에 '주석 처리됨'으로만 적었습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0015 |
| 클래스 | `SSP0015_ShipmentPSI` (메인), `SSP0015_ShipmentPSICommentsPopup` (팝업) |
| 도메인 | SSP (프로젝트 경로 `06.UIL\GSCM.SSP.Forms.UIL\Plan\…`) |
| 화면명(추정 근거) | 파일명 `SSP0015_ShipmentPSI` → Shipment PSI |
| Grid 구성 방식 | **`HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)`** |
| Spread | `spdMain`(상단, 시트 2개), `spdDetail`(하단, 시트 11개) |
| 활성 엔드포인트 | 39종 (FoxQuery 33 + biz:CommonData 6코드) |
| 주석 처리된 호출 | 4건 (§8) |

### 1-1. 파일 구성

| 구분 | 파일 | 줄수 | 비고 |
|---|---|---:|---|
| current | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSI.cs` | 9922 | 메인 로직 |
| current | `…\SSP0015_ShipmentPSI.Designer.cs` | 1628 | 메인 디자이너 |
| current | `…\SSP0015_ShipmentPSICommentsPopup.cs` | 447 | Comments 팝업 로직 |
| current | `…\SSP0015_ShipmentPSICommentsPopup.Designer.cs` | 960 | 팝업 디자이너 |
| current | `…\Properties\AssemblyInfo.cs` | 37 | 어셈블리 정보 |
| shared | — | — | Fact Pack에 shared 구분 파일 없음. 프레임워크 메서드(`SpreadInfo.SetSheetHeaderColumn`, `SpreadInfo.GetSpdTitle`, `DataService.GetSSPInnerTable`, `DataService.FP_Log2`, `CString.GetCheckedListValue`, `PersonalSettingPopup.SaveData`)를 호출함(§6-2) |
| legacy | `06.UIL\GSCM.SSP.Plan.UIL\SSP0015_ShipmentPSI.cs` | 9857 | 구버전 사본(current보다 65줄 적음) |
| legacy | `06.UIL\GSCM.SSP.Plan.UIL\SSP0015_ShipmentPSI.Designer.cs` | 1624 | 구버전 사본 |
| legacy | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0015_ShipmentPSICommentsPopup.cs` | 447 | 줄수는 current와 같음. 내용 동일 여부는 확인 필요 |
| legacy | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0015_ShipmentPSICommentsPopup.Designer.cs` | 960 | 위와 같음 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

### 2-1. 화면 로드 (`Form_Load`)
| 경로 | 줄 | 엔드포인트 | SP |
|---|---:|---|---|
| Form_Load > InitControls | 568 | `biz:CommonData.CommonDataList [code=PlanDateShip]` | (BIZ) |
| Form_Load > InitControls > GetBucketType | 2162 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | DM0003_GET_BUCKET_TYPE_CODE |
| Form_Load > InitControls > SetChangedControl | 2202 / 2210 / 2218 | `biz:CommonData.CommonDataList [code=PlanDateShip]` | (BIZ) |
| Form_Load > InitControls > GetDayRange | 9289 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | SCM0001_GET_SCP_DAY_PERIOD |
| Form_Load > CreateSpread > InitSpread > GetSpdTitle | 9247 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCP0009_GET_SHEET_CALENDAR_3SPAN |

### 2-2. 조회 (`FindButton`, 프레임워크 툴바 버튼)
| 경로 | 줄 | 엔드포인트 |
|---|---:|---|
| FindButton > FindData_Main_Packer_Past | 2293 | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST` |
| FindButton > FindData_Main_Packer | 2412 | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` |
| FindButton > FindData_Main | 2536 | `SSP.SSP0015_GET_SHIPMENT_PSI` |
| FindButton > FindData_Main_Packer_Past > Re_Design > GetNERPCode | 2904 | `SSP.SSP0002_GET_NERP_CODE` |
| FindButton > FindData_Main_Packer_Past > InitSpread > GetSpdTitle | 9247 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |

> FindData_Main / _Packer / _Packer_Past 중 어느 것을 호출할지 정하는 분기 조건은 Fact Pack에 없습니다 → **확인 필요**. 시트명(`Shipment PSI(Mobility & IT)` / `Shipment PSI(Packer)`)과 과거 일자 여부가 조건일 것으로 보이지만 근거가 없습니다.

### 2-3. 저장 (`SaveButton`, 프레임워크 툴바 버튼)
| 경로 | 줄 | 엔드포인트 |
|---|---:|---|
| SaveButton > SaveData | 333 | `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` (※ 메서드명 충돌 가능성 → §9) |
| SaveButton > SaveData_Main | 5412 | `SSP.SSP0015_SAVE_SHIPMENT_PSI` |
| SaveButton > SaveData_Detail | 5841 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` |
| SaveButton > SaveData_Detail | 6011 | `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA` |
| SaveButton > SaveData_Detail | 6112 / 6219 | `SSP.SSP0015_SAVE_MES_STOCK` |
| SaveButton > SaveData_Detail > FindData_Main | 2536 | `SSP.SSP0015_GET_SHIPMENT_PSI` (저장 후 재조회) |
| SaveButton > SaveData_Detail > FindData_Main > Re_Design > GetNERPCode | 2904 | `SSP.SSP0002_GET_NERP_CODE` |
| SaveButton > SaveData_Detail > FindData_Detail | 3165 / 3303 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` |
| SaveButton > SaveData_Detail > FindData_Detail_btnSearch | 3705 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` |
| SaveButton > SaveData_Detail > FindData_mes_stock | 3966 | `SSP.SSP0015_GET_MES_STOCK` |
| SaveButton > SaveData_Detail > FindData_MesStock_btnSearch | 4528 | `SSP.SSP0015_GET_MES_STOCK` |
| SaveButton > SaveData_Detail_Packer | 5602 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` |
| SaveButton > SaveData_Detail_Packer > chkSaveYN | 9821 | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` |
| SaveButton > SaveData_Detail_Packer > EngProcessingChk | 7903 | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` |
| SaveButton > SaveData_Detail_Packer > FindData_Detail_Packer_btnSearch | 3439 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` |
| SaveButton > SaveData_Detail_Packer > FindData_Detail_Packer_btnSearch > InitSpread > GetSpdTitle | 9247 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| SaveButton > SaveData_Detail_Packer > GetERPInterface | 6665 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` |
| SaveButton > SaveData_Detail_Packer > GetERPInterface | 6706 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| … > GetERPInterface > ChkConfirmChangeTime | 9875 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` |
| … > GetERPInterface > GetErpSoNoCnt | 7185 | `SSP.SSP0015_GET_ERP_SO_NO_CNT` |
| … > GetERPInterface > GetShipmentStatusChk | 7210 | `SSP.SSP0015_GET_SHIPMENT_STATUS` |
| … > GetERPInterface > NonSoNo | 6843 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| … > GetERPInterface > NonSoNo | 6847 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` |
| … > GetERPInterface > SoNo | 7076 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| … > GetERPInterface > SoNo | 7080 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` |
| … > GetERPInterface > SoNo > GetErpIFCheckNew | 7363 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| … > GetERPInterface > SoNo > GetErpIFCheckNew | 7389 / 7419 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` |

> 저장 경로 안에서의 **호출 순서**와 **분기 조건**(SO No 유무에 따른 SoNo/NonSoNo 선택, 시트별 SaveData_Main/_Detail/_Detail_Packer 선택)은 Fact Pack에 없습니다 → **확인 필요**.

### 2-4. 편집 (`EditButton`)
| 경로 | 줄 | 엔드포인트 |
|---|---:|---|
| EditButton | 1753 / 1757 | `biz:CommonData.CommonDataList [code=PlanDateShip]` |
| EditButton > GetSSPUserCheck | 9901 | `SSP.SSP0002_GET_USER_INFO_LIST` |

### 2-5. 하단 Detail 조회 (`btnSearch` → `BtnSearch_Click`)
| 경로 | 줄 | 엔드포인트 |
|---|---:|---|
| BtnSearch_Click > FindData_Detail_Packer_btnSearch | 3439 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` |
| BtnSearch_Click > FindData_Detail_btnSearch | 3705 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` |
| BtnSearch_Click > FindData_WHstock | 3850 | `SSP.SSP0015_GET_WH_STOCK` |
| BtnSearch_Click > FindData_BolckStockDetail_btnSearch | 4193 | `SSP.SSP0015_GET_BLOCK_STOCK` |
| BtnSearch_Click > FindData_shtStockLocationDetail_btnSearch | 4337 | `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL` |
| BtnSearch_Click > FindData_shtStockLocationDetail_btnSearch > GetNERPCode | 2904 | `SSP.SSP0002_GET_NERP_CODE` |
| BtnSearch_Click > FindData_ScsStock_btnSearch | 4437 | `SSP.SSP0015_GET_SCS_STOCK` |
| BtnSearch_Click > FindData_MesStock_btnSearch | 4528 | `SSP.SSP0015_GET_MES_STOCK` |
| BtnSearch_Click > FindData_Request_Detail | 4640 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` |
| BtnSearch_Click > FindData_WHinPlanDetail_btnSearch | 4723 | `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS` |
| BtnSearch_Click > FindData_ShipmentSCSResult_btnSearch | 4832 | `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER` |
| BtnSearch_Click > FindData_ShipmentSCSResult_btnSearch > InitSpread > GetSpdTitle | 9247 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| BtnSearch_Click > FindData_ShipmentResult_btnSearch | 4944 | `SSP.SSP0015_GET_SHIPMENT_RESULT` |

### 2-6. 상단 셀 더블클릭 (`SpdMain_CellDoubleClick`)
| 경로 | 줄 | 엔드포인트 |
|---|---:|---|
| SpdMain_CellDoubleClick > FindData_Main | 2536 | `SSP.SSP0015_GET_SHIPMENT_PSI` |
| SpdMain_CellDoubleClick > FindData_Detail | 3165 / 3303 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` |
| SpdMain_CellDoubleClick > FindData_WHstock | 3850 | `SSP.SSP0015_GET_WH_STOCK` |
| SpdMain_CellDoubleClick > FindData_mes_stock | 3966 | `SSP.SSP0015_GET_MES_STOCK` |
| SpdMain_CellDoubleClick > FindData_block_stock | 4070 | `SSP.SSP0015_GET_BLOCK_STOCK` |
| SpdMain_CellDoubleClick > FindData_shtStockLocationDetail_btnSearch | 4337 | `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL` |
| SpdMain_CellDoubleClick > FindData_shtStockLocationDetail_btnSearch > GetNERPCode | 2904 | `SSP.SSP0002_GET_NERP_CODE` |
| SpdMain_CellDoubleClick > FindData_shtStockLocationDetail_btnSearch > InitSpread > GetSpdTitle | 9247 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| SpdMain_CellDoubleClick > FindData_ScsStock_btnSearch | 4437 | `SSP.SSP0015_GET_SCS_STOCK` |

> SpdMain_CellDoubleClick(8290~8306)은 `row`에서 DIVISION_ID / SITE / ITEM_ID / YYYYMMDD를, `Comments`에서 GAP / BEFORE_QTY / USER_ADD_QTY를 읽습니다. 이 값들은 Comments 팝업으로 넘어가는 것으로 보이지만, 팝업 오픈 코드는 Fact Pack에 없습니다 → **확인 필요**.

### 2-7. 기타 이벤트
| 진입점 | 경로 | 줄 | 엔드포인트 |
|---|---|---:|---|
| `SpdMain_ActiveSheetChanged` | 직접 | 1400 / 1452 | `biz:CommonData.CommonDataList [code=LookupCommon]` |
| `SpdMain_ActiveSheetChanged` | > SetChangedControl | 2202/2210/2218 | `biz:CommonData.CommonDataList [code=PlanDateShip]` |
| `SpdMain_ActiveSheetChanged` | > SetChangedControl > GetDayRange | 9289 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| `SpdMain_ActiveSheetChanged` | > InitSpread > GetSpdTitle | 9247 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| `clbDivision_SelectedIndexChanged` | > SetChangedControl | 2202/2210/2218 | `biz:CommonData.CommonDataList [code=PlanDateShip]` |
| `clbDivision_SelectedIndexChanged` | > SetChangedControl > GetDayRange | 9289 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| `CboPlanDate_SelectedIndexChanged` | > GetDayRange | 9289 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| `btnMeasure_Click` | > InitSpread > GetSpdTitle | 9247 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| `SpdDetail_CellClick` | 직접 | 8583 | `biz:CommonData.CommonDataList [code=TransMode]` |
| `SpdDetail_CellClick` | 직접 | 8604 | `biz:CommonData.CommonDataList [code=ShipToCodeByDivision]` |
| `SpdDetail_ClipboardPasted` | 직접 | 8954 | `biz:CommonData.CommonDataList [code=TransMode]` |
| `btnButtonList_UsrButtonList_Click_Detected` (팝업) | > SaveData | 333 | `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` |

### 2-8. 진입점 미연결(unreached) 메서드 — 정적 추적으로는 호출부를 찾지 못함
| 메서드 | 줄 | 엔드포인트 | 비고 |
|---|---:|---|---|
| GetErpIFCheck | 7285 | `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING` | 현행에서 호출되는지 확인 필요 |
| SCM_SYS_LOG_BATCH | 7876 | `SCP.PR_SCM_SYS_LOG_BATCH` | 확인 필요 |
| GetDivision | 9192 | `SCM.SCM0001_GET_DIVISION` | 확인 필요 |
| SetChangedPeriod | 9207 | `biz:CommonData.CommonDataList [code=PERIOD_{p:value}]` | 코드값이 런타임 결정. 확인 필요 |
| SetChangedPeriod | 9211 | `biz:CommonData.CommonDataList [code=PERIOD2_{p:value}]` | 위와 같음 |
| NewNonSoNo | 9611 / 9615 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING` / `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` | 확인 필요 |
| GetErpIFCheckNew_ | 9731 | `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING` | 이름 끝이 `_`인 사본 메서드. 확인 필요 |

> unreached는 '주석 처리'와 다릅니다. 코드는 살아 있지만 정적 분석으로는 진입점을 찾지 못한 경우입니다. 리플렉션, 동적 이벤트, 외부 호출 가능성이 있으므로 런타임 확인이 필요합니다.

## 3. 엔드포인트 전체 표 (39종)

| # | 엔드포인트 | 상태 | 호출 수 | SP | 참조 테이블(쓰기는 굵게) |
|---:|---|---|---:|---|---|
| 1 | `biz:CommonData.CommonDataList` [code=PlanDateShip] | BIZ_MATCH | 6 | UP_FX_GetCommonDataList (코드분기) | SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_SHIP_PLAN_P, SSP_PLAN_VERSION_V, REF:STRING_SPLIT |
| 1 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | 2 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| 1 | `biz:CommonData.CommonDataList` [code=TransMode] | BIZ_MATCH | 2 | UP_FX_GetCommonDataList | SCP_MST_BOD_V |
| 1 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] | BIZ_MATCH | 1 | UP_FX_GetCommonDataList | SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER, SCM_MST_SITE |
| 1 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value}] | BIZ_MATCH (unreached) | 1 | — | DB 보강 없음 → 확인 필요 |
| 1 | `biz:CommonData.CommonDataList` [code=PERIOD2_{p:value}] | BIZ_MATCH (unreached) | 1 | — | DB 보강 없음 → 확인 필요 |
| 2 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | 1 | DM0003_GET_BUCKET_TYPE_CODE | SCM_ADM_LOOKUP_MASTER_DETAIL |
| 3 | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST` | MATCH | 1 | SSP0015_GET_SHIPMENT_PSI_PACKER_PAST | SCM_MST_TITLESET_USER, SCM_DNM_SCS_STOCK, MST_STOCK, SCM_DNM_STOCK_V, SSP_ANL_SHIP_PLAN_P, SCM_MST_SHEET_MEASURE, SCM_SYS_CALENDAR_M, SCM_CODE_LOOKUP_VALUE, #임시테이블, DYNAMIC |
| 4 | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` | MATCH | 1 | SSP0015_GET_SHIPMENT_PSI_PACKER | SCM_MST_TITLESET_USER, SSP_ANL_SHIP_REQ_P, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE, SCM_DNM_SCS_PROD_PLAN, SCM_DNM_SCS_STOCK, MST_STOCK, SCM_DNM_STOCK_V, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_CODE_LOOKUP_VALUE, #임시테이블, DYNAMIC |
| 5 | `SSP.SSP0015_GET_SHIPMENT_PSI` | MATCH | 1 | SSP0015_GET_SHIPMENT_PSI | SCM_MST_TITLESET_USER, SSP_PLAN_VERSION_V, SSP_ANL_SHIP_PLAN_40, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, DM_PLN_SHIPMENT_REQ, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_ANL_MES_FCS_STOCK_40_C, SCP_MST_FINAL_ITEM, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_OWMS_STOCK_C, SSP_ANL_TCO_STOCK_C, SSP_ANL_HOLD_STOCK, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_CODE_LOOKUP_VALUE, SCM_MST_SITE; EXEC SSP0015_GET_SHIPMENT_PSI_COMMENTS |
| 6 | `SSP.SSP0002_GET_NERP_CODE` | MATCH | 1 | SSP0002_GET_NERP_CODE | SCM_CODE_LOOKUP_VALUE |
| 7 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` | MATCH | 3 | SSP0015_GET_SHIPMENT_CONFIRM_DETAIL | DYNAMIC SQL (정적 테이블 미추출), FN_GET_IN_STR, FN_SCM_SPLIT |
| 8 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` | MATCH | 1 | SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER | DYNAMIC SQL, FN_GET_IN_STR, FN_SCM_SPLIT |
| 9 | `SSP.SSP0015_GET_WH_STOCK` | MATCH | 1 | SSP0015_GET_WH_STOCK | SSP_ANL_OWMS_STOCK_C, SCM_MST_SLOC, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_ITEM_SN |
| 10 | `SSP.SSP0015_GET_MES_STOCK` | MATCH | 2 | SSP0015_GET_MES_STOCK | SSP_ANL_MES_FCS_STOCK_40_C, TB_FX_USER, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SSP_ANL_OWMS_STOCK_C, SCM_MST_SLOC, SCM_MST_ITEM_SN |
| 11 | `SSP.SSP0015_GET_BLOCK_STOCK` | MATCH | 2 | SSP0015_GET_BLOCK_STOCK | SSP_ANL_HOLD_STOCK, TB_FX_USER, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_SITE, SCM_MST_ITEM_SN |
| 12 | `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL` | MATCH | 1 | SSP0015_GET_STOCK_LOCATION_DETAIL | SSP_MST_LOCATION_V, SCM_MST_SITE, SCM_MST_SLOC, SCM_DNM_STOCK_V, SCM_MST_ITEM_SN, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_CODE_LOOKUP_VALUE |
| 13 | `SSP.SSP0015_GET_SCS_STOCK` | MATCH | 1 | SSP0015_GET_SCS_STOCK | SCM_DNM_SCS_STOCK, SCM_MST_SITE, SSP_MST_MODEL_USER, SSP_MST_DELEGATE |
| 14 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` | MATCH | 1 | SSP0026_GET_REQUEST_DETAIL_PACK | DYNAMIC SQL만 있음(정적 테이블 미추출) |
| 15 | `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS` | MATCH | 1 | SSP0015_GET_SHIPMENT_PSI_COMMENTS | DYNAMIC SQL, FN_GET_IN_STR, FN_SCM_SPLIT |
| 16 | `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER` | MATCH | 1 | SSP0015_GET_SHIPMENT_RESULT_PACKER | SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SCM_MST_CUSTOMER, SSP_MST_DELEGATE, SCM_DNM_SCS_SHIP_RESULT, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_ITEM, SSP_ANL_SHIP_PLAN_P, SCP_MST_BOD_N_V, SCM_MST_ITEM_SN (+CTE: RESULT_SCS_EXIST, RESULT_ERP_C_NON, PLAN_SSP) |
| 17 | `SSP.SSP0015_GET_SHIPMENT_RESULT` | MATCH | 1 | SSP0015_GET_SHIPMENT_RESULT | SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_SSO_DEPT_INFO, TB_FX_USER, SCM_MST_SITE_ITEM, SSP_ANL_SHIP_CONFIRM, SCM_DNM_EXFACTORY_RESULT, SCP_MST_FINAL_ITEM, SSP_ANL_SHIP_PLAN_ALL, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS, SCM_MST_ITEM_SN, SCM_CODE_LOOKUP_VALUE (+CTE) |
| 18 | `SSP.SSP0015_SAVE_SHIPMENT_PSI` | MATCH | 1 | SSP0015_SAVE_SHIPMENT_PSI | **UPDATE/INSERT SSP_ANL_SHIP_PLAN_40_WH_IN_CMT**, **INSERT _WH_IN_CMT_H**, **UPDATE SSP_ANL_SHIP_PLAN_40**, **INSERT SSP_ANL_SHIP_PLAN_40_WH_IN_H**, **INSERT SCM_SYS_LOG_BATCH** |
| 19 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` | MATCH | 1 | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER | **UPDATE/INSERT SSP_ANL_SHIP_CONFIRM**, **INSERT SSP_ANL_SHIP_CONFIRM_H**, **INSERT XIF_ERP_PACK_SHIP_PLAN_S_SN**, **INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN**, **INSERT SSP_MST_SEND_MAIL_REQ**, **INSERT SCM_SYS_LOG_BATCH**; EXEC PR_SSP_ANL_SHIP_CONFIRM_HIST |
| 20 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | MATCH | 1 | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | **UPDATE/INSERT SSP_ANL_SHIP_CONFIRM**, **INSERT _H**, **INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN**, **INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ / _DE**, **DELETE/INSERT SSP_ANL_SHIP_PLAN_40**, **INSERT SSP_MST_SEND_MAIL_REQ**, **INSERT DM_PLN_MKT_FCST_CONFIRM**; EXEC PR_DM_SSP_CONFIRM_SYNC / PR_SSP_ANL_SHIP_CONFIRM_HIST / PR_SSP_MAIL_SEND_ADJUST_MST / PR_SSP_ANL_SHIP_CONFIRM_ROUTE |
| 21 | `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA` | MATCH | 1 | SSP0015_SAVE_BLOCK_STOCK_DATA | **UPDATE/INSERT SSP_ANL_HOLD_STOCK**, **INSERT SCM_SYS_LOG_BATCH** |
| 22 | `SSP.SSP0015_SAVE_MES_STOCK` | MATCH | 2 | SSP0015_SAVE_MES_STOCK | **MERGE SSP_ANL_MES_FCS_STOCK_40_C**, **MERGE SSP_ANL_SHIP_PLAN_40**, #TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP |
| 23 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | MATCH | 1 | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | **INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM**, **UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ / _DE** |
| 24 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | MATCH | 2 | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | **UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE**, **UPDATE/DELETE SSP_ANL_SHIP_CONFIRM**, **INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN**, #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 |
| 25 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH | 3 | SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING | **INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ / _DE**, **INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN**, **UPDATE _CHG_REQ_DE**; EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| 26 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` | MATCH | 3 | SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | **INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ / _DE**, **INSERT XIF_ERP_PACK_SHIP_PLAN_S_SN**, **INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN**; EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER |
| 27 | `SSP.SSP0015_GET_ERP_SO_NO_CNT` | MATCH | 1 | SSP0015_GET_ERP_SO_NO_CNT | SSP_ANL_SHIP_CONFIRM |
| 28 | `SSP.SSP0015_GET_SHIPMENT_STATUS` | MATCH | 1 | SSP0015_GET_SHIPMENT_STATUS | SSP_ANL_SHIP_CONFIRM, REF:STRING_SPLIT |
| 29 | `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING` | MATCH (unreached) | 2 | SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING | **UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ / _DE** |
| 30 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | MATCH | 2 | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | **INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN**, **UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE** |
| 31 | `SCP.PR_SCM_SYS_LOG_BATCH` | MATCH (unreached) | 1 | PR_SCM_SYS_LOG_BATCH | **INSERT SCM_SYS_LOG_BATCH** |
| 32 | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | MATCH | 1 | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL |
| 33 | `SCM.SCM0001_GET_DIVISION` | MATCH (unreached) | 1 | SCM0001_GET_DIVISION | SCM_MST_DIVISION |
| 34 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | 1 (경유 다수) | SCP0009_GET_SHEET_CALENDAR_3SPAN | SCM_SYS_CALENDAR_M |
| 35 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH | 1 (경유 다수) | SCM0001_GET_SCP_DAY_PERIOD | SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, FN_MULTY_TIME, FN_WEEKOFDAY_DATE |
| 36 | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` | MATCH | 1 | SSP0202_GET_SCS_CONFIRM_ID_CHECK | SCM_ADM_LOOKUP_MASTER_DETAIL, DYNAMIC |
| 37 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | MATCH | 1 | SCM_SSP_CHECK_CONFIRM_CHANGETIME | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| 38 | `SSP.SSP0002_GET_USER_INFO_LIST` | MATCH | 1 | SSP0002_GET_USER_INFO_LIST | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION |
| 39 | `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` | MATCH | 1 | SSP0015_SAVE_SHIPMENT_PSI_COMMENTS | **UPDATE SSP_ANL_SHIP_PLAN_40**, **INSERT SSP_ANL_SHIP_PLAN_40_WH_IN_H**, **UPDATE/INSERT SSP_ANL_SHIP_PLAN_40_WH_IN_CMT**, **INSERT _WH_IN_CMT_H** (팝업) |

## 4. 이벤트 배선 표 (33건)

| # | 대상 | 이벤트 | 핸들러 | 위치(파일:메서드:줄) |
|---:|---|---|---|---|
| 1 | this.spdMain | TextTipFetch | `spdMain_TextTipFetch` | Designer.cs:InitializeComponent:906 |
| 2 | this | Load | `Form_Load` | SSP0015_ShipmentPSI.cs:.ctor:422 |
| 3 | this.spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | .cs:InitEvent:1159 |
| 4 | this.spdMain | TopChange | `SpdMain_TopChange` | .cs:InitEvent:1161 |
| 5 | this.spdDetail | TopChange | `SpdDetail_TopChange` | .cs:InitEvent:1162 |
| 6 | this.btnMeasure | Click | `btnMeasure_Click` | .cs:InitEvent:1164 |
| 7 | this.cboBucketType | SelectedIndexChanged | `cboBucketType_SelectedIndexChanged` | .cs:InitEvent:1165 |
| 8 | this.chkSum | CheckedChanged | `chkSum_CheckedChanged` | .cs:InitEvent:1166 |
| 9 | this.btnItemId | Click | `btnItemId_Click` | .cs:InitEvent:1167 |
| 10 | this.btnItemID2 | Click | `BtnItemID2_Click` | .cs:InitEvent:1168 |
| 11 | this.btnSearch | Click | `BtnSearch_Click` | .cs:InitEvent:1169 |
| 12 | this.btnRequestor | Click | `BtnRequestor_Click` | .cs:InitEvent:1170 |
| 13 | this.spdDetail | CellClick | `SpdDetail_CellClick` | .cs:InitEvent:1172 |
| 14 | this.spdDetail | ComboSelChange | `spdDetail_ComboSelChange` | .cs:InitEvent:1173 |
| 15 | this.spdDetail | SheetTabClick | `SpdDetail_SheetTabClick` | .cs:InitEvent:1174 |
| 16 | this.spdDetail | CellDoubleClick | `SpdDetail_CellDoubleClick` | .cs:InitEvent:1175 |
| 17 | this.spdMain | ActiveSheetChanged | `SpdMain_ActiveSheetChanged` | .cs:InitEvent:1177 |
| 18 | clbDivision | SelectedIndexChanged | `clbDivision_SelectedIndexChanged` | .cs:InitEvent:1179 |
| 19 | cboPlanDate | SelectedIndexChanged | `CboPlanDate_SelectedIndexChanged` | .cs:InitEvent:1180 |
| 20 | spdDetail | ActiveSheetChanged | `SpdDetail_ActiveSheetChanged` | .cs:InitEvent:1181 |
| 21 | spdDetail | EditChange | `SpdDetail_EditChange` | .cs:InitEvent:1182 |
| 22 | spdDetail | ClipboardPasted | `SpdDetail_ClipboardPasted` | .cs:InitEvent:1183 |
| 23 | spdMain | EditModeOn | `SpdMain_EditModeOn` | .cs:InitEvent:1186 |
| 24 | spdMain | CellClick | `SpdMain_CellClick` | .cs:InitEvent:1187 |
| 25 | dsdm | Changed | `shtDetail_Change` | .cs:InitEvent:1190 |
| 26 | this.txtGap_Qty (팝업) | TextChanged | `txtGap_Qty_TextChanged` | Popup.Designer.cs:InitializeComponent:192 |
| 27 | this.txtBefore_Qty (팝업) | TextChanged | `txtBefore_Qty_TextChanged` | Popup.Designer.cs:227 |
| 28 | this.txtProd_Qty (팝업) | TextChanged | `txtProd_Qty_TextChanged` | Popup.Designer.cs:262 |
| 29 | this.txtWHin_Qty (팝업) | TextChanged | `txtWHin_Qty_TextChanged` | Popup.Designer.cs:297 |
| 30 | this.txtCurrent_Qty (팝업) | TextChanged | `txtCurrent_Qty_TextChanged` | Popup.Designer.cs:474 |
| 31 | this.txtChange_Qty (팝업) | TextChanged | `txtChange_Qty_TextChanged` | Popup.Designer.cs:509 |
| 32 | this.txtChange_Qty (팝업) | KeyPress | `txtChange_Qty_KeyPress` | Popup.Designer.cs:510 |
| 33 | this.btnButtonList (팝업) | UsrButtonList_Click_Detected | `btnButtonList_UsrButtonList_Click_Detected` | Popup.Designer.cs:657 |
| (34) | this (팝업) | Load | `Form_Load` | Popup.cs:.ctor:207 |

> 엔드포인트 호출이 추적된 핸들러: `Form_Load`, `SpdMain_CellDoubleClick`, `btnMeasure_Click`, `BtnSearch_Click`, `SpdDetail_CellClick`, `SpdMain_ActiveSheetChanged`, `clbDivision_SelectedIndexChanged`, `CboPlanDate_SelectedIndexChanged`, `SpdDetail_ClipboardPasted`, `btnButtonList_UsrButtonList_Click_Detected`.
> 나머지 핸들러(`spdMain_TextTipFetch`, `SpdMain_TopChange`, `SpdDetail_TopChange`, `cboBucketType_SelectedIndexChanged`, `chkSum_CheckedChanged`, `btnItemId_Click`, `BtnItemID2_Click`, `BtnRequestor_Click`, `spdDetail_ComboSelChange`, `SpdDetail_SheetTabClick`, `SpdDetail_CellDoubleClick`, `SpdDetail_ActiveSheetChanged`, `SpdDetail_EditChange`, `SpdMain_EditModeOn`, `SpdMain_CellClick`, `shtDetail_Change`, 팝업 TextChanged/KeyPress 7종)는 직접 엔드포인트 호출이 추출되지 않았습니다. 내부 동작은 **확인 필요**합니다. 단, `cboBucketType`/`chkSum`은 SetSpreadColumn(2116~2148)의 D_/W_/M_ 컬럼 Visible 분기 조건에 쓰입니다.

## 5. Grid 구성 방식

**`HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)`**

1. **META(프레임워크)**: `SpreadInfo.SetSheetHeaderColumn`이 `SCM_MST_SHEET_COLUMNS`(PROGRAM_ID=SSP0015, 395행)의 COLUMN_NAME / COLUMN_LABEL_NAME / COLUMN_WIDTH / VISIBLE_FLAG / VALID_YN / FIXED_FLAG / CELL_CONTROL_OBJECT_TYPE_CODE / CELL_COMBO_DATA_TYPE / DATA_MAX_LENGTH / DATA_SCALE_NUMBER / HORIZONTAL_ALIGN_CODE / UPPERCASE_APPLY_FLAG / ATTRIBUTE1~5로 컬럼을 만듭니다. 호출 위치는 InitSpread:759(Main, 헤더 3행), 786(Packer, 헤더 3행), 811, 826, 853, 866, 879, 892, 905, 918, 941, 967, 978(Detail 시트, 헤더 1행)입니다.
2. **DB루프(코드)**: 화면 자체 메서드 `InitSpreadDateColumn`이 `SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과(`GetSpdTitle`)를 `foreach`로 돌며 일자 컬럼을 만듭니다.
   - 컬럼명에 `B_`가 있으면 → `AddTextColumn`(너비 0, 비표시) (1110)
   - 그 외 → `AddNumColumn`(너비 70, 표시) (1114)
   - DAY_CODE가 SAT면 파랑, SUN이면 빨강 ForeColor (1118)
   - LARGE_CLASS_LABEL_NAME / SMALL_CLASS_LABEL_NAME으로 `ColumnHeaderSpan` 3단 헤더를 만들고, "SUM" 소계 헤더를 붙임 (1125~1154)
3. **코드 표시/라벨 변경**
   - `SetSpreadColumn`(2116~2148): `cboBucketType.ControlValues`가 DAILY / WEEKLY / MONTHLY일 때 컬럼 Tag 접두어 `D_`/`W_`/`M_`의 Visible을 바꾸고, Sum 계열은 `chkSum.Checked`를 따름
   - `InitSpread` 776/778/803/805: `Shipment PSI(Mobility & IT)`, `Shipment PSI(Packer)`에 `MergePolicy.Always`
   - `FindData_Detail` 3218~3221, 3356~3359, `FindData_Detail_Packer_btnSearch` 3491~3493, `FindData_Detail_btnSearch` 3758~3761: Visible=false (대상 컬럼명 미추출 → 확인 필요)
   - `FindData_ShipmentResult_btnSearch` 4991/4992: SHIP_TO, SHIPTO_DESCRIPTION Visible=false
   - `SetSoNoColumnVisible` 9778~9793: `ichkbtn==1`과 시트명(`Shipment PSI(Packer)` 여부)에 따라 Width 80/0 전환 (대상 컬럼명 미추출 → 확인 필요)
   - `SpdDetail_CellClick` 8618~8657: 시트가 잠겨 있지 않으면(`IsLock==false`) 컬럼헤더 CheckBox를 토글(전체 선택/해제)
   - 메인 Measure 행: `SCM_MST_SHEET_MEASURE`(32행). SP 내부에서 SELECT로 참조

### 5-1. division별 차이
- §10 메타 규칙으로 전개하면 **14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)의 컬럼 수가 모든 시트에서 같습니다.** 메타 기준 division 차이는 없습니다.
- 최종 Grid(grid_effective) 표시 컬럼 수도 division 간에 같습니다.
- 화면 차이는 division이 아니라 **시트명 분기**(Mobility & IT vs Packer), **Bucket Type**, **chkSum**, **ichkbtn**에서 생깁니다. Packer/40 저장 SP 분기(`_PACKER` vs `_40`)가 division과 연결되는지는 **확인 필요**합니다.

## 6. 메타/데이터 컬럼 사용

### 6-1. 코드가 직접 읽는 컬럼
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InitControls | UserInfoContext.Current / c / dtCompany.Rows[0] / dtShipmentInputPeriod.Rows[0..1] | NowGroupID / CODE, NAME / COMPANY_ID / VALUE, Diff_VALUE |
| SetChangeControl | Filter, UserInfoContext.Current | GROUP_ID, USER_ID, NowGroupID |
| SetChangedControl, SpdMain_ActiveSheetChanged | UserInfoContext.Current | NowGroupID |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |
| GetNERPCode | ds.Tables[0].Rows[0] | SEGMENT2 |
| SetNote_Display / SetProdNote_Display | row, Comments, drProdQty | DIVISION_ID, SITE, ITEM_ID, YYYYMMDD / COMMENTS / PRODUCT_QTY |
| SpdMain_CellDoubleClick, TsmNotepad_Click | row, Comments | DIVISION_ID, SITE, ITEM_ID, YYYYMMDD / GAP, BEFORE_QTY, USER_ADD_QTY |
| CalculateSum, Set_SumValues | dr, dsBinding.Tables[0].Columns | measure |
| SetBalanceMinus | dr | DivisionID, FromSite, ItemID |
| Validation_Check | row, Validationdr, SONoValidationdr | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE |
| GetErpSoNoCnt / chkSaveYN | ds.Tables[n].Rows[0] | CNT |
| GetShipmentStatusChk | ds.Tables[0..2].Rows[iRow] | CONFIRM_ID |
| chkERPIFBlockYn | dtERPBlockYnIF.Rows[0] | BLOCK_YN, PERIOD (원천 엔드포인트 미추출 → 확인 필요) |
| SpdDetail_ClipboardPasted | c | CODE |
| FindData_ShipmentResult_btnSearch | sv.Columns | SHIP_TO, SHIPTO_DESCRIPTION |

### 6-2. 프레임워크 메타 소비 메서드
| 호출 메서드 | 호출 위치 | 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSSPInnerTable | SetChangeControl:456~491 (8곳) | DataService.GetSSPInnerTable | CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID |
| FP_Log2 | InitControls:534, 545 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetSpdTitle | InitSpread:753 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:759~892 외 | SpreadInfo.SetSheetHeaderColumn | §5 1번 참조 |
| InitSpreadDateColumn | InitSpread:766, 793 | 화면 자체 구현 (프레임워크와 이름만 같음) | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE/SMALL_CLASS_LABEL_NAME |
| GetCheckedListValue | SpdMain_ActiveSheetChanged:1357, EditButton:1749/1761/1805/1842, SetChangedControl:2188, FindData_Main_Packer_Past:2253/2255 | CString.GetCheckedListValue | CODE |
| SaveData | SaveButton:271, btnButtonList_UsrButtonList_Click_Detected:430 | PersonalSettingPopup.SaveData (파서 귀속) | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 7. DB 메타 데이터 (화면 ID 값 보유 행)
| 메타 테이블 | 행 수 |
|---|---:|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 249 |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 6 |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 4 |
| dbo.SCM_MST_SHEET_COLUMNS | 395 |
| dbo.SCM_MST_SHEET_MEASURE | 32 |
| dbo.SCM_MST_TITLESET_USER | 12 |
| dbo.TB_FX_Favorite | 117 |
| dbo.TB_FX_GroupMenuAuth | 14 |
| dbo.TB_FX_MenuItemInfo | 2 |
| dbo.TB_FX_ProgramInfo | 2 |
| dbo.TB_FX_SearchCondition | 766 |

## 8. 주석 처리된 호출 (활성 기능 아님)
| 줄 | 값 | 상태 |
|---:|---|---|
| 3573 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER | 주석 처리됨 (같은 SP는 3439에서 활성 호출됨) |
| 9288 | SCP.GET_DATE_RANGE_1MONTH | 주석 처리됨 |
| 9308 | SCP.GET_DATE_RANGE_1MONTH | 주석 처리됨 |
| 9309 | SCP.SCM0001_GET_SCP_PERIOD | 주석 처리됨 |

## 9. 확인 필요 항목
1. FindButton에서 FindData_Main / _Packer / _Packer_Past를 고르는 분기 조건
2. SaveButton에서 SaveData_Main / SaveData_Detail / SaveData_Detail_Packer를 고르는 분기 조건(시트 기준으로 보임)과, 각 경로 안의 호출 순서
3. `SaveButton > SaveData(333)`가 팝업 `SSP0015_ShipmentPSICommentsPopup.SaveData`로 귀속된 것은 메서드명이 같아서 생긴 오귀속일 수 있음. §6-2에서는 같은 위치(SaveButton:271)가 `PersonalSettingPopup.SaveData`로도 귀속됨. 실제 대상 확인 필요
4. SoNo / NonSoNo 선택 조건(SO No 유무로 보이나 근거 없음)
5. unreached 메서드 6종(GetErpIFCheck, SCM_SYS_LOG_BATCH, GetDivision, SetChangedPeriod, NewNonSoNo, GetErpIFCheckNew_)이 실제로 호출되는지
6. `PERIOD_{p:value}` / `PERIOD2_{p:value}` 공통코드의 실제 코드값과 원천 테이블
7. `chkERPIFBlockYn`이 읽는 dtERPBlockYnIF의 원천
8. FindData_Detail(3218~3221, 3356~3359), FindData_Detail_Packer_btnSearch(3491~3493), FindData_Detail_btnSearch(3758~3761), SetSoNoColumnVisible(9778~9793)의 대상 컬럼명
9. grid_effective의 Shipment Confirm Detail 표시 수(40)가 메타 필수+기본 수(39)보다 많은 이유
10. grid_effective에서 SHIP_TO / SHIPTO_DESCRIPTION `CODE_ONLY_CHANGE →숨김`이 거의 모든 시트에 붙어 있음. 이는 `FindData_ShipmentResult_btnSearch:4991/4992`(Shipment Result 전용)의 시트 귀속 한계로 보임
11. `SCM_MST_SHEET_COLUMNS`의 PROGRAM_ID `SSP0015_TEMP2`(Shipment Confirm Detail 31컬럼)를 현행 코드에서 쓰는지
12. 메타 정의만 있고 코드에서 참조하지 않는 시트 `Shipment PSI(IT & Mobile)`, `MES Stock Detail`이 실제로 쓰이지 않는지
13. 정적 분석으로 동작을 찾지 못한 이벤트 핸들러(§4 주석)의 내부 동작
14. legacy 사본(9857줄)과 current(9922줄)의 차이 65줄의 내용

=== FILE: source_links.md ===
# SSP0015 소스 링크 표

경로 약어:
- **M** = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSI.cs`
- **MD** = `…\SSP0015_ShipmentPSI.Designer.cs`
- **P** = `…\SSP0015_ShipmentPSICommentsPopup.cs`
- **PD** = `…\SSP0015_ShipmentPSICommentsPopup.Designer.cs`

## 1. 엔드포인트 호출 지점 (endpoints.csv 전수, current)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | InitControls | 568 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| M | SpdMain_ActiveSheetChanged | 1400 | biz:CommonData.CommonDataList [code=LookupCommon] |
| M | SpdMain_ActiveSheetChanged | 1452 | biz:CommonData.CommonDataList [code=LookupCommon] |
| M | EditButton | 1753 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| M | EditButton | 1757 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| M | GetBucketType | 2162 | DM.DM0003_GET_BUCKET_TYPE_CODE |
| M | SetChangedControl | 2202 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| M | SetChangedControl | 2210 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| M | SetChangedControl | 2218 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| M | FindData_Main_Packer_Past | 2293 | SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST |
| M | FindData_Main_Packer | 2412 | SSP.SSP0015_GET_SHIPMENT_PSI_PACKER |
| M | FindData_Main | 2536 | SSP.SSP0015_GET_SHIPMENT_PSI |
| M | GetNERPCode | 2904 | SSP.SSP0002_GET_NERP_CODE |
| M | FindData_Detail | 3165 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL |
| M | FindData_Detail | 3303 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL |
| M | FindData_Detail_Packer_btnSearch | 3439 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER |
| M | FindData_Detail_btnSearch | 3705 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL |
| M | FindData_WHstock | 3850 | SSP.SSP0015_GET_WH_STOCK |
| M | FindData_mes_stock | 3966 | SSP.SSP0015_GET_MES_STOCK |
| M | FindData_block_stock | 4070 | SSP.SSP0015_GET_BLOCK_STOCK |
| M | FindData_BolckStockDetail_btnSearch | 4193 | SSP.SSP0015_GET_BLOCK_STOCK |
| M | FindData_shtStockLocationDetail_btnSearch | 4337 | SSP.SSP0015_GET_STOCK_LOCATION_DETAIL |
| M | FindData_ScsStock_btnSearch | 4437 | SSP.SSP0015_GET_SCS_STOCK |
| M | FindData_MesStock_btnSearch | 4528 | SSP.SSP0015_GET_MES_STOCK |
| M | FindData_Request_Detail | 4640 | SSP.SSP0026_GET_REQUEST_DETAIL_PACK |
| M | FindData_WHinPlanDetail_btnSearch | 4723 | SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS |
| M | FindData_ShipmentSCSResult_btnSearch | 4832 | SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER |
| M | FindData_ShipmentResult_btnSearch | 4944 | SSP.SSP0015_GET_SHIPMENT_RESULT |
| M | SaveData_Main | 5412 | SSP.SSP0015_SAVE_SHIPMENT_PSI |
| M | SaveData_Detail_Packer | 5602 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER |
| M | SaveData_Detail | 5841 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 |
| M | SaveData_Detail | 6011 | SSP.SSP0015_SAVE_BLOCK_STOCK_DATA |
| M | SaveData_Detail | 6112 | SSP.SSP0015_SAVE_MES_STOCK |
| M | SaveData_Detail | 6219 | SSP.SSP0015_SAVE_MES_STOCK |
| M | GetERPInterface | 6665 | SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| M | GetERPInterface | 6706 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| M | NonSoNo | 6843 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING |
| M | NonSoNo | 6847 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| M | SoNo | 7076 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING |
| M | SoNo | 7080 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| M | GetErpSoNoCnt | 7185 | SSP.SSP0015_GET_ERP_SO_NO_CNT |
| M | GetShipmentStatusChk | 7210 | SSP.SSP0015_GET_SHIPMENT_STATUS |
| M | GetErpIFCheck | 7285 | SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING (진입점 미연결) |
| M | GetErpIFCheckNew | 7363 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| M | GetErpIFCheckNew | 7389 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| M | GetErpIFCheckNew | 7419 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| M | SCM_SYS_LOG_BATCH | 7876 | SCP.PR_SCM_SYS_LOG_BATCH (진입점 미연결) |
| M | EngProcessingChk | 7903 | SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK |
| M | SpdDetail_CellClick | 8583 | biz:CommonData.CommonDataList [code=TransMode] |
| M | SpdDetail_CellClick | 8604 | biz:CommonData.CommonDataList [code=ShipToCodeByDivision] |
| M | SpdDetail_ClipboardPasted | 8954 | biz:CommonData.CommonDataList [code=TransMode] |
| M | GetDivision | 9192 | SCM.SCM0001_GET_DIVISION (진입점 미연결) |
| M | SetChangedPeriod | 9207 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] (진입점 미연결) |
| M | SetChangedPeriod | 9211 | biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] (진입점 미연결) |
| M | GetSpdTitle | 9247 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN |
| M | GetDayRange | 9289 | SCP.SCM0001_GET_SCP_DAY_PERIOD |
| M | NewNonSoNo | 9611 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING (진입점 미연결) |
| M | NewNonSoNo | 9615 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER (진입점 미연결) |
| M | GetErpIFCheckNew_ | 9731 | SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING (진입점 미연결) |
| M | chkSaveYN | 9821 | SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK |
| M | ChkConfirmChangeTime | 9875 | SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME |
| M | GetSSPUserCheck | 9901 | SSP.SSP0002_GET_USER_INFO_LIST |
| P | SaveData | 333 | SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS |

## 2. 주석 처리된 호출 지점
| 파일 | 줄 | 내용 |
|---|---:|---|
| M | 3573 | 주석 처리됨: SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER |
| M | 9288 | 주석 처리됨: SCP.GET_DATE_RANGE_1MONTH |
| M | 9308 | 주석 처리됨: SCP.GET_DATE_RANGE_1MONTH |
| M | 9309 | 주석 처리됨: SCP.SCM0001_GET_SCP_PERIOD |

## 3. 이벤트 배선 지점
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| MD | InitializeComponent | 906 | spdMain.TextTipFetch += spdMain_TextTipFetch |
| M | .ctor | 422 | this.Load += Form_Load |
| M | InitEvent | 1159 | spdMain.CellDoubleClick += SpdMain_CellDoubleClick |
| M | InitEvent | 1161 | spdMain.TopChange += SpdMain_TopChange |
| M | InitEvent | 1162 | spdDetail.TopChange += SpdDetail_TopChange |
| M | InitEvent | 1164 | btnMeasure.Click += btnMeasure_Click |
| M | InitEvent | 1165 | cboBucketType.SelectedIndexChanged += cboBucketType_SelectedIndexChanged |
| M | InitEvent | 1166 | chkSum.CheckedChanged += chkSum_CheckedChanged |
| M | InitEvent | 1167 | btnItemId.Click += btnItemId_Click |
| M | InitEvent | 1168 | btnItemID2.Click += BtnItemID2_Click |
| M | InitEvent | 1169 | btnSearch.Click += BtnSearch_Click |
| M | InitEvent | 1170 | btnRequestor.Click += BtnRequestor_Click |
| M | InitEvent | 1172 | spdDetail.CellClick += SpdDetail_CellClick |
| M | InitEvent | 1173 | spdDetail.ComboSelChange += spdDetail_ComboSelChange |
| M | InitEvent | 1174 | spdDetail.SheetTabClick += SpdDetail_SheetTabClick |
| M | InitEvent | 1175 | spdDetail.CellDoubleClick += SpdDetail_CellDoubleClick |
| M | InitEvent | 1177 | spdMain.ActiveSheetChanged += SpdMain_ActiveSheetChanged |
| M | InitEvent | 1179 | clbDivision.SelectedIndexChanged += clbDivision_SelectedIndexChanged |
| M | InitEvent | 1180 | cboPlanDate.SelectedIndexChanged += CboPlanDate_SelectedIndexChanged |
| M | InitEvent | 1181 | spdDetail.ActiveSheetChanged += SpdDetail_ActiveSheetChanged |
| M | InitEvent | 1182 | spdDetail.EditChange += SpdDetail_EditChange |
| M | InitEvent | 1183 | spdDetail.ClipboardPasted += SpdDetail_ClipboardPasted |
| M | InitEvent | 1186 | spdMain.EditModeOn += SpdMain_EditModeOn |
| M | InitEvent | 1187 | spdMain.CellClick += SpdMain_CellClick |
| M | InitEvent | 1190 | dsdm.Changed += shtDetail_Change |
| PD | InitializeComponent | 192 | txtGap_Qty.TextChanged += txtGap_Qty_TextChanged |
| PD | InitializeComponent | 227 | txtBefore_Qty.TextChanged += txtBefore_Qty_TextChanged |
| PD | InitializeComponent | 262 | txtProd_Qty.TextChanged += txtProd_Qty_TextChanged |
| PD | InitializeComponent | 297 | txtWHin_Qty.TextChanged += txtWHin_Qty_TextChanged |
| PD | InitializeComponent | 474 | txtCurrent_Qty.TextChanged += txtCurrent_Qty_TextChanged |
| PD | InitializeComponent | 509 | txtChange_Qty.TextChanged += txtChange_Qty_TextChanged |
| PD | InitializeComponent | 510 | txtChange_Qty.KeyPress += txtChange_Qty_KeyPress |
| PD | InitializeComponent | 657 | btnButtonList.UsrButtonList_Click_Detected += btnButtonList_UsrButtonList_Click_Detected |
| P | .ctor | 207 | this.Load += Form_Load |

## 4. Grid 정의 지점 (주요)
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | CreateSpread | 656 / 660 | spdMain AddSheet: Shipment PSI(Mobility & IT), Shipment PSI(Packer) (헤더 3행, 고정 1, 행높이 35) |
| M | CreateSpread | 665~683 | spdDetail AddSheet 11종 (Shipment Request Detail만 행높이 60) |
| M | CreateSpread | 680 / 731 / 732 | WH In Plan Detail: `if(drPgmAuthId != null)`일 때만 생성 |
| M | InitSpread | 753 | GetSpdTitle |
| M | InitSpread | 759 / 786 | SetSheetHeaderColumn(spdInfo, 3) — Main/Packer |
| M | InitSpread | 766 / 793 | InitSpreadDateColumn |
| M | InitSpread | 770 / 797 | SetSpreadColumn |
| M | InitSpread | 776, 778, 803, 805 | MergePolicy.Always |
| M | InitSpread | 811, 826, 853, 866, 879, 892, 905, 918, 941, 967, 978 | SetSheetHeaderColumn(…, 1) — Detail 시트 |
| M | InitSpreadDateColumn | 1110 / 1114 / 1118 | B_ 텍스트(숨김) / 숫자 컬럼 / 토·일 색상 |
| M | InitSpreadDateColumn | 1125~1154 | ColumnHeaderSpan (LARGE/SMALL/SUM) |
| M | SetSpreadColumn | 2116~2148 | Bucket DAILY/WEEKLY/MONTHLY · chkSum Visible |
| M | FindData_Detail | 3218~3221, 3356~3359 | Visible=false |
| M | FindData_Detail_Packer_btnSearch | 3491~3493 | Visible=false |
| M | FindData_Detail_btnSearch | 3758~3761 | Visible=false |
| M | FindData_ShipmentResult_btnSearch | 4991 / 4992 | SHIP_TO / SHIPTO_DESCRIPTION Visible=false |
| M | SpdDetail_CellClick | 8618 / 8653 / 8657 | 헤더 CheckBox 토글 |
| M | SetSoNoColumnVisible | 9778 / 9782 / 9789 / 9793 | Width 80/0 |

## 5. 레이아웃 속성 지점
| 파일 | 줄 | 내용 |
|---|---:|---|
| MD | 178 / 181 | usrConditionPanel1 Dock Top, Size(1370, 79) |
| MD | 950 / 953 / 964 / 965 | splitContainer1 Dock Fill, Orientation Horizontal, Size(1370, 570), SplitterDistance 301 |
| MD | 897 / 902 | spdMain Dock Fill, Size(1370, 301) |
| MD | 971 / 976 | spdDetail Dock Fill, Size(1370, 225) |
| MD | 1031 / 1036 | usrLayoutControl3 Dock Top, Size(1370, 40) |

=== FILE: web_components.md ===
# SSP0015 화면 컴포넌트 매핑 (WinForms → React/Wijmo)

> 라벨은 props.csv의 LayoutControlItem.Text 또는 컨트롤 Text 원문입니다. props.csv가 잘려서 라벨을 확인하지 못한 항목은 '확인 필요'로 표기했습니다.

## 1. 화면 배치

| 영역 | As-is | 크기 근거 | TO-BE 권장 |
|---|---|---|---|
| 조회조건 | usrConditionPanel1 (Dock Top, HidePanel 타입) > usrLayoutControl2 (Dock Top) | Size(1370,79) / (1370,73) | 접이식 SearchCondition 영역 |
| 본문 | splitContainer1 (Dock Fill, **Orientation=Horizontal → 상/하 분할**) | Size(1370,570), SplitterDistance=301 | 상/하 Splitter |
| 상단 패널(Panel1) | spdMain (Dock Fill) | 301 / 570 ≈ **52.8%** | 상단 Grid (시트 탭 2개) |
| 하단 패널(Panel2) | usrLayoutControl3 (Dock Top, 높이 40) + spdDetail (Dock Fill, 높이 225) | 나머지 ≈ **47.2%** (spliter 두께 포함 정확 값 확인 필요) | 하단 Detail 조회조건 바 + 탭 Grid (시트 11개) |
| 팝업 | SSP0015_ShipmentPSICommentsPopup | 크기 확인 필요 | Modal (Comments) |

## 2. 컨트롤 → 컴포넌트 매핑

### 2-1. 상단 조회조건 (usrLayoutControl2)
| As-is 컨트롤 | 유형 | 라벨(원문) | 크기 | TO-BE 후보 | 비고 |
|---|---|---|---|---|---|
| clbDivision | UsrCombo | `Division*` (lblCombo1) | 162×20 | ComboBox (필수) | 이름은 clb지만 타입은 UsrCombo. 변경 시 PlanDate / DayRange 갱신 |
| cboPlanDate | UsrCombo | `Plan-date*` (PlanDate) | 150×20 | ComboBox (필수) | 공통코드 PlanDateShip. 변경 시 GetDayRange |
| drpPeriod | UsrDateRangePicker | `Period*` (layoutControlItem6) | 205×20 | DateRange (필수) | 기본값은 SCM0001_GET_SCP_DAY_PERIOD |
| clbPlantSite | UsrCheckedList | `From Site` (layoutControlItem7) | 189×21 | MultiSelect | 데이터 원천 확인 필요 (GetSSPInnerTable 가능성) |
| cboBucketType | UsrCombo | `Bucket` (lblBucket) | 137×20 | ComboBox | DM0003_GET_BUCKET_TYPE_CODE. DAILY/WEEKLY/MONTHLY 컬럼 전환 |
| chkSum | UsrCheckBox | `Sum` (Text) | 84×25 | CheckBox | Sum 컬럼 Visible 제어 |
| btnMeasure | UsrButton | 라벨 없음 (layoutControlItem10) | 39×25 | IconButton | 클릭 시 InitSpread 재구성. Measure 선택 팝업 여부 확인 필요 |
| txtItemId | UsrMultiLineEditor | `Model` (lblItemId) | 100×21 | MultiLine Text | |
| btnItemId | UsrButton | 라벨 없음 (layoutControlItem2) | 39×24 | 팝업 버튼 | Model 선택 팝업으로 보이나 확인 필요 |
| chkMyModel | UsrCheckBox | `My Model` / Checked=true / **Visible=false** | 110×23 | (숨김) | LayoutItem Text "layoutControlItem8" |
| chkPartLeader | UsrCheckBox | `Part Leader` / **Visible=false** | 110×23 | (숨김) | |
| chkTeamLeader | UsrCheckBox | `Team Leader` / **Visible=false** | 110×23 | (숨김) | |
| chkDelegateeModel | UsrCheckBox | `Delegatee Model` / **Visible=false** | 136×23 | (숨김) | |
| usrButton1 | UsrButton | 확인 필요 | 75×23 | — | parent 없음. 미사용 가능성 → 확인 필요 |

### 2-2. 하단 Detail 조회 바 (usrLayoutControl3, Panel2 상단)
| As-is 컨트롤 | 유형 | 라벨(원문) | 크기 | TO-BE 후보 |
|---|---|---|---|---|
| drpPeriod2 | UsrDateRangePicker | `Shipment Date` (layoutControlItem11) | 197×20 | DateRange |
| txtRequestor | UsrTextBox | LayoutItem `Requestor` (Text 원문 확인 필요) | 20×20 | Text |
| btnRequestor | UsrButton | 라벨 없음 (layoutControlItem9) | 39×24 | 사용자 선택 팝업 버튼 |
| clbResultType | UsrCheckedList | 확인 필요 | 104×21 | MultiSelect |
| txtModel2 | UsrMultiLineEditor | 확인 필요 | 264×21 | MultiLine Text |
| btnItemID2 | UsrButton | 확인 필요 | 39×25 | 팝업 버튼 |
| drpPeriod3 | UsrDateRangePicker | 확인 필요 | 197×20 | DateRange |
| txtLotID | UsrMultiLineEditor | 확인 필요 | 207×21 | MultiLine Text |
| btnSearch | SimpleButton | `Search` | 47×25 | Button (Detail 시트별 조회) |

> layoutControlItem4 / 5 / 14 / 15 / 3 / 17의 Text와 Control 매핑은 props.csv가 잘려서 확인하지 못했습니다 → 확인 필요.

### 2-3. Grid
| As-is | 유형 | TO-BE |
|---|---|---|
| spdMain (+spdMain_Sheet1) | FpSpread, 시트 2 | Wijmo FlexGrid + 시트 탭, 3단 컬럼헤더, MergePolicy Always → allowMerging |
| spdDetail (+spdDetail_Sheet1) | FpSpread, 시트 11 | Wijmo FlexGrid + 시트 탭 (탭별 Grid) |

### 2-4. Comments 팝업 (SSP0015_ShipmentPSICommentsPopup)
| As-is 컨트롤 | 유형 | TO-BE 후보 | 비고 |
|---|---|---|---|
| txtDivision_ID, txtFrom_Site, txtItem_ID, txtPlan_Date, txtDate, txtMeasure | UsrTextBox | ReadOnly Text (추정) | 라벨 원문 확인 필요 |
| txtGap_Qty, txtBefore_Qty, txtProd_Qty, txtWHin_Qty, txtCurrent_Qty | UsrTextBox | Number Text | TextChanged 핸들러 있음 |
| txtChange_Qty | UsrTextBox | Number Input | TextChanged + KeyPress(입력 제한으로 보이나 확인 필요) |
| rtxComments | RichTextBox | TextArea | |
| usrLabel1 | UsrLabel | Label | Text 확인 필요 |
| btnButtonList | UsrButtonList | 버튼 그룹 (저장) | → SSP0015_SAVE_SHIPMENT_PSI_COMMENTS |

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

규칙: 메타 `DIVISION_ID` 빈값 = 전체, VISIBLE_FLAG/VALID_YN='Y', USER_SELECTABLE_FLAG='N' = 필수, DEFAULT_FLAG='Y' = 기본. **14개 division 모두 같은 결과**이므로 division 열은 생략했습니다.

### 3-1. `Shipment PSI(Mobility & IT)` — spdMain 시트 0 / META+코드연결 / 표시 10
- 표시(기본): DIVISION_ID `Div`, FIGURE `Figure`, FROM_SITE_NM `From Site`, ITEM_ID `Model`, LT_DAY `Aging L/T`, MEASURE_NAME `Measure`, NICK_NAME `Nick Name`, PSI_NAME `PSI`, TYPE `TYPE`, YEILD `Yield(%)`
- 숨김: FROM_SITE `Site`, LT_UPDATE_YN, MEASURE, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SHIP_FROZEN
- 코드: SetSheetHeaderColumn(헤더 3행), InitSpreadDateColumn(일자 컬럼 DB루프), SetSpreadColumn(Bucket/Sum), MergePolicy.Always
- Measure 메타(SCM_MST_SHEET_MEASURE): 필수+기본 12 / 선택 1

### 3-2. `Shipment PSI(Packer)` — spdMain 시트 1 / META+코드연결 / 표시 8
- 표시: DIVISION_ID `Div`, FIGURE `Figure`, FROM_SITE_NM `From Site`, ITEM_ID `Model`, MEASURE `Measure`, NICK_NAME `Nick Name`, PSI_NAME `PSI`, TYPE `TYPE`
- 숨김: FROM_SITE, LT_DAY, LT_UPDATE_YN, MEASURE_NAME, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SHIP_FROZEN, YEILD
- Mobility 시트와 다른 점: MEASURE를 표시하고 MEASURE_NAME은 숨김. LT_DAY / YEILD 숨김
- Measure 메타: 6 / 0
- SetSoNoColumnVisible: ichkbtn==1이면 Packer 시트 Width 80, 다른 시트 0 (반대 조건에서는 반대). 대상 컬럼명 확인 필요

### 3-3. `Shipment PSI(IT & Mobile)` — 메타 정의만 있고 코드 미참조(미사용 가능) / 표시 10
- 표시: DIVISION_ID, FIGURE, FROM_SITE_NM, ITEM_ID, LT_DAY, MEASURE_NAME, NICK_NAME, PSI_NAME, TYPE, YEILD `Yeild(%)`
- CreateSpread에서 생성되지 않습니다. TO-BE 이관 대상인지 확인 필요

### 3-4. `Shipment Confirm Detail` — spdDetail / META+코드연결 / 표시 40 (메타 필수+기본 39 — 차이 확인 필요)
- 표시(기본): ATTRIBUTE10, attribute3 `PLM status`, attribute6 `OQC Result`, CHANGE_REASON_CODE `Change Reason`, CHANGE_REASON_DETAIL `Reason Detail`, CHANGE_REQ_NO `Change Request No`, CONFIRM_ID `Confirm/Plan ID`, DIVISION_ID `Division`, END_CUSTOMER, ERP_SO_NO `SO No`, ETA, ETD, Expected_Shipping_Date, FCST_TYPE, FROM_SITE_DESCRIPTION `From Site`, INCOTERMS, ITEM_ID `Model`, LT_DAY `L/T(Day)`, MODEL_USER `Model PIC`, MTK_OWNER `MKT Owner`, NICK_NAME, REMARKS, REMARKS2 `Building`, REMARKS3 `Customer Requirement`, REQUESTOR `Shipment Requestor`, RTF3 `RTF`, RTF4 `RTF ETD`, RTF5 `RTF QTY`, RTF6 `RTF Detail`, SHIPMENT_CONFIRM_QTY `Shipment Qty`, SHIPMENT_DATE, SHIPMENT_STATUS `Status`, SOLDTO_DESCRIPTION `Sold To Party`, TEAM, TO_SITE_DESCRIPTION `To Site`, TO_SITE_SHIPTO_CODE `Ship to`, TO_SITE_SOLDTO_CODE `Sold to`, TRANSPORT_MODE `Trans Mode`, UPDATED_BY, UPDATED_DATE
- 기본 → 코드에서 숨김: SHIPTO_DESCRIPTION `Ship To Party`
- 숨김(메타): BEFORE_QTY, BOD_ID, CHANGE_TYPE, CHECK_NEED_YN, CHK `ALL`, EDIT_MAIN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE `Shipment Date*`, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, PROJECT_CODE, PROJECT_NAME, TO_SITE
- 코드: FindData_Detail / _btnSearch / _Packer_btnSearch에서 Visible=false 다수(대상 확인 필요). SpdDetail_CellClick 헤더 CheckBox 토글. TransMode / ShipToCodeByDivision 셀 콤보
- 메타 별도 프로그램: `SSP0015_TEMP2`의 Shipment Confirm Detail 31컬럼(사용 여부 확인 필요)

### 3-5. `Shipment Request Detail` — META+코드연결 / 표시 34 / 행높이 60
- 표시: ATTRIBUTE3 `RTF`, ATTRIBUTE4 `RTF ETD`, ATTRIBUTE5 `RTF QTY`, ATTRIBUTE6 `RTF Detail`, BOD_ID, CHANGE_REQUEST_NO, DIVISION_ID `Div*`, EDIT_FLAG, END_CUSTOMER, ETA_DATE `ETA`, ETD_DATE `ETD`, EXPECTED_SHIP_DATE, FCST_TYPE `FCST Type*`, FROM_SITE `From Site*`, INCOTERMS `Incoterms*`, LAST_UPDATED_BY `Requestor`, LAST_UPDATED_DATE `Request Date`, LT_TOTAL `L/T(Day)`, MKT_OWMER `MKT Owner`, MODEL_ID `Model*`, MODEL_PIC, NICK_NAME, ORDER_TYPE_DETAIL, QTY `Qty*`, REMARK, REQUEST_ID `Confrim/Plan ID`, SHIPTO_CODE `Ship to*`, SHIPTO_NAME, SITE_DESCRIPTION `Plant Site`, SOLDTO_CODE `Sold to`, STATUS, TO_SITE `To Site*`, TR_MODE `Trans Mode*`, YYYYMMDD `Shipment Date*`
- 원천: SSP0026_GET_REQUEST_DETAIL_PACK

### 3-6. `W/H stock` — META+코드연결 / 메타 필수+기본 19
- 원천: SSP0015_GET_WH_STOCK. 컬럼 상세는 grid_effective.csv가 잘려 있음 → CSV 원문 확인 필요

### 3-7. `W/H stock Detail` — META+코드연결 / 메타 25
- 컬럼 상세 확인 필요 (CSV 잘림). 원천 SP도 Fact Pack 흐름에 따로 표시되지 않음 → 확인 필요

### 3-8. `Hold stock` — META+코드연결 / 표시 10
- 표시: DIVISION_ID `Div`, FROM_SITE_NM `From Site`, HOLD_QTY `Amend Qty*`, HOLD_YYYYMMDD `Start Date`, ITEM_ID `Model`, LAST_UPDATE_DATE, LAST_UPDATED_BY, NICK_NAME, RELEASE_YYYYMMDD `End Date*`, REMARKS
- 숨김: FROM_SITE, HOLD_ID
- 원천 SSP0015_GET_BLOCK_STOCK, 저장 SSP0015_SAVE_BLOCK_STOCK_DATA

### 3-9. `Hold stock Detail` — META+코드연결 / 표시 10
- Hold stock과 같은 컬럼이며, 라벨만 다름: `Amend Qty`, `End Date` (필수 `*` 없음 → 조회 전용으로 보이나 확인 필요)

### 3-10. `Stock Detail` — META+코드연결 / 표시 26 (sheet 변수 shtMesStock)
- 표시: AVAILABLE_YN, DIVISION_ID, FCS_HOLD_YN, FCS_SPECIAL_QTY, FROM_SITE `Site`, ITEM_ID, JUDG_VLD_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY, LONGTERM_HOLD_YN, LOT_ID, LOT_QTY_FCS, LOT_QTY_MES, LOT_QTY_MES_NG, LOT_QTY_TOT, LOT_TYPE, MES_CHANGE_STATUS, MES_HOLD_RELEASE, MES_HOLD_YN, NICK_NAME, OWMS_STOCK_QTY, QMS_HOLD_RELEASE, QMS_HOLD_YN, REMARKS, USER_MOD_RELEASE_DATE `User Modified Release Date*`, YYYYMMDD_LOT_ID_APPLIED_LT `D Day(Expected)`
- 원천 SSP0015_GET_MES_STOCK, 저장 SSP0015_SAVE_MES_STOCK

### 3-11. `MES Stock Detail` — 메타 정의만 있고 코드 미참조(미사용 가능) / 표시 24
- Stock Detail에서 LONGTERM_HOLD_YN, LOT_QTY_MES_NG를 뺀 24컬럼. TO-BE 이관 대상인지 확인 필요

### 3-12. `SCS Stock Detail` — META+코드연결 / 표시 9
- 표시: CUTOFF_DATE, DIVISION_ID, HOLD_YN `Hold Y/N`, LAST_UPDATE_DATE `Update Date`, MODEL_ID `Model`, PLANT_ID, PLANT_NAME, PROD_DATE `Production Date`, QTY
- 원천 SSP0015_GET_SCS_STOCK

### 3-13. `Stock Location Detail` — META+코드연결 / 메타 20
- 일부 확인: AVAILABLE_DATE, AVAILABLE_QTY, COMPANY_ID, CUTOFF_DATE, DEFECT_QTY `Deffect Qty`, DIVISION_ID … 나머지는 CSV 잘림 → 확인 필요
- 원천 SSP0015_GET_STOCK_LOCATION_DETAIL (+ SSP0002_GET_NERP_CODE)

### 3-14. `WH In Plan Detail` — META+코드연결 / 메타 11
- **`drPgmAuthId != null`일 때만 시트를 생성**(권한 의존). 컬럼 상세는 확인 필요
- 원천 SSP0015_GET_SHIPMENT_PSI_COMMENTS

### 3-15. `Shipment Result` — META+코드연결 / 메타 19 → 표시 17
- 표시: CONFIRM_ID, DIVISION_ID, END_CUSTOMER, ERP_SO_NO `SO No`, ETA_DATE, ETD_DATE, FROM_SITE, INCOTERMS, ITEM_ID, NICK_NAME, QTY `Shipment Qty`, SHIP_TYPE, TEAM, TO_SITE, TRANSPORT_MODE, TYPE `Status`, YYYYMMDD `Shipment Date`
- 코드 숨김(4991/4992): SHIP_TO `Ship to`, SHIPTO_DESCRIPTION `Ship to Name`
- 원천 SSP0015_GET_SHIPMENT_RESULT / SSP0015_GET_SHIPMENT_RESULT_PACKER(SCS)

> 참고: grid_effective에서 SHIP_TO / SHIPTO_DESCRIPTION `CODE_ONLY_CHANGE →숨김`이 Hold stock, Hold stock Detail, SCS Stock Detail, Shipment Confirm Detail, Shipment PSI(Mobility & IT), Shipment PSI(Packer), Shipment Request Detail, Stock Detail, Stock Location Detail에도 붙어 있습니다. 근거 코드는 Shipment Result 전용 메서드(4991/4992)이므로 정적 분석의 시트 귀속 한계로 보입니다 → 확인 필요.

## 4. 시트 연결 규칙

| 시트 | Spread | 연결 규칙 | 생성 조건 |
|---|---|---|---|
| Shipment PSI(Mobility & IT) | spdMain | META+코드연결 | 항상 (CreateSpread:656) |
| Shipment PSI(Packer) | spdMain | META+코드연결 | 항상 (660) |
| Shipment Confirm Detail | spdDetail | META+코드연결 | 항상 (665) |
| Shipment Request Detail | spdDetail | META+코드연결 | 항상 (666) |
| W/H stock | spdDetail | META+코드연결 | 항상 (668) |
| W/H stock Detail | spdDetail | META+코드연결 | 항상 (669) |
| Hold stock | spdDetail | META+코드연결 | 항상 (670) |
| Hold stock Detail | spdDetail | META+코드연결 | 항상 (671) |
| Stock Detail | spdDetail | META+코드연결 | 항상 (672) |
| SCS Stock Detail | spdDetail | META+코드연결 | 항상 (673) |
| Stock Location Detail | spdDetail | META+코드연결 | 항상 (674) |
| WH In Plan Detail | spdDetail | META+코드연결 | `drPgmAuthId != null` (680) |
| Shipment Result | spdDetail | META+코드연결 | 항상 (683) |
| Shipment PSI(IT & Mobile) | — | 메타 정의만, 코드 미참조(미사용 가능) | 생성 안 함 |
| MES Stock Detail | — | 메타 정의만, 코드 미참조(미사용 가능) | 생성 안 함 |

- 상단 → 하단 연결: SpdMain_CellDoubleClick이 클릭한 셀의 row(DIVISION_ID / SITE / ITEM_ID / YYYYMMDD)로 하단 시트를 조회합니다(Confirm Detail, W/H stock, Stock Detail, Hold stock, Stock Location Detail, SCS Stock Detail). 셀/Measure별로 어느 시트를 고르는지는 확인 필요합니다.
- 상단 시트 전환(SpdMain_ActiveSheetChanged) 시 LookupCommon 공통코드, PlanDateShip, DayRange, 시트 재구성(GetSpdTitle)을 다시 호출합니다.
- CreateSpread 마지막 ChangeSheet 순서: W/H stock(740) → Shipment Confirm Detail(741) → Shipment PSI(Mobility & IT)(746). 따라서 초기 활성 시트는 Shipment Confirm Detail / Shipment PSI(Mobility & IT)로 보입니다(확인 필요).

=== FILE: oracle_migration.md ===
# SSP0015 Oracle 전환 분석

## 1. 호출 SP 인벤토리 (38종)

| # | SP | 스키마 키 | 구분 | 진입 | 참조/DML (요약) | EXEC 체인 |
|---:|---|---|---|---|---|---|
| 1 | DM0003_GET_BUCKET_TYPE_CODE | DM | 조회 | Form_Load | SCM_ADM_LOOKUP_MASTER_DETAIL | — |
| 2 | SSP0015_GET_SHIPMENT_PSI_PACKER_PAST | SSP | 조회 | FindButton | SCM_MST_TITLESET_USER, SCM_DNM_SCS_STOCK, MST_STOCK, SCM_DNM_STOCK_V, SSP_ANL_SHIP_PLAN_P, SCM_MST_SHEET_MEASURE, SCM_SYS_CALENDAR_M, SCM_CODE_LOOKUP_VALUE, #TBLDYNAMICTITLEST_SSP0015, #TMP_RESULT_TABLE, #TMP_WH_STOCK, #TMP_ERP_STOCK, #TMP_ROWDATA, #TMP_RESULT_PIVOT_TABLE, DYNAMIC | — |
| 3 | SSP0015_GET_SHIPMENT_PSI_PACKER | SSP | 조회 | FindButton | 위 + SSP_ANL_SHIP_REQ_P, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE, SCM_DNM_SCS_PROD_PLAN, #TMP_PROD_PLAN, #TMP_SHIP_REQ, #TMP_PACK_RTF, #TMP_SHIP_CONFIRM | — |
| 4 | SSP0015_GET_SHIPMENT_PSI | SSP | 조회 | FindButton / 더블클릭 / 저장 후 | SCM_MST_TITLESET_USER, SSP_PLAN_VERSION_V, SSP_ANL_SHIP_PLAN_40, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, DM_PLN_SHIPMENT_REQ, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_ANL_MES_FCS_STOCK_40_C, SCP_MST_FINAL_ITEM, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_OWMS_STOCK_C, SSP_ANL_TCO_STOCK_C, SSP_ANL_HOLD_STOCK, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_CODE_LOOKUP_VALUE, SCM_MST_SITE, #TMP_ROWDATA, #TBLDYNAMICTITLEST_SSP0015, DYNAMIC | EXEC SSP0015_GET_SHIPMENT_PSI_COMMENTS |
| 5 | SSP0002_GET_NERP_CODE | SSP | 조회 | Re_Design / StockLocation | SCM_CODE_LOOKUP_VALUE | — |
| 6 | SSP0015_GET_SHIPMENT_CONFIRM_DETAIL | SSP | 조회 | 더블클릭 / btnSearch / 저장 후 | DYNAMIC (테이블 미추출), FN_GET_IN_STR, FN_SCM_SPLIT | — |
| 7 | SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER | SSP | 조회 | btnSearch / 저장 후 | DYNAMIC, FN_GET_IN_STR, FN_SCM_SPLIT | — |
| 8 | SSP0015_GET_WH_STOCK | SSP | 조회 | btnSearch / 더블클릭 | SSP_ANL_OWMS_STOCK_C, SCM_MST_SLOC, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_ITEM_SN, STRING_SPLIT | — |
| 9 | SSP0015_GET_MES_STOCK | SSP | 조회 | btnSearch / 더블클릭 / 저장 후 | SSP_ANL_MES_FCS_STOCK_40_C, TB_FX_USER, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SSP_ANL_OWMS_STOCK_C, SCM_MST_SLOC, SCM_MST_ITEM_SN, STRING_SPLIT | — |
| 10 | SSP0015_GET_BLOCK_STOCK | SSP | 조회 | btnSearch / 더블클릭 | SSP_ANL_HOLD_STOCK, TB_FX_USER, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_SITE, SCM_MST_ITEM_SN, FN_CHAR_TO_DATE, STRING_SPLIT | — |
| 11 | SSP0015_GET_STOCK_LOCATION_DETAIL | SSP | 조회 | btnSearch / 더블클릭 | SSP_MST_LOCATION_V, SCM_MST_SITE, SCM_MST_SLOC, SCM_DNM_STOCK_V, SCM_MST_ITEM_SN, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_CODE_LOOKUP_VALUE, STRING_SPLIT | — |
| 12 | SSP0015_GET_SCS_STOCK | SSP | 조회 | btnSearch / 더블클릭 | SCM_DNM_SCS_STOCK, SCM_MST_SITE, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, STRING_SPLIT | — |
| 13 | SSP0026_GET_REQUEST_DETAIL_PACK | SSP | 조회 | btnSearch | DYNAMIC만 있음 | — |
| 14 | SSP0015_GET_SHIPMENT_PSI_COMMENTS | SSP | 조회 | btnSearch (WH In Plan Detail) | DYNAMIC, FN_GET_IN_STR, FN_SCM_SPLIT | — |
| 15 | SSP0015_GET_SHIPMENT_RESULT_PACKER | SSP | 조회 | btnSearch | SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SCM_MST_CUSTOMER, SSP_MST_DELEGATE, SCM_DNM_SCS_SHIP_RESULT, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_ITEM, SSP_ANL_SHIP_PLAN_P, SCP_MST_BOD_N_V, SCM_MST_ITEM_SN, STRING_SPLIT | — |
| 16 | SSP0015_GET_SHIPMENT_RESULT | SSP | 조회 | btnSearch | SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_SSO_DEPT_INFO, TB_FX_USER, SCM_MST_SITE_ITEM, SSP_ANL_SHIP_CONFIRM, SCM_DNM_EXFACTORY_RESULT, SCP_MST_FINAL_ITEM, SSP_ANL_SHIP_PLAN_ALL, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS, SCM_MST_ITEM_SN, SCM_CODE_LOOKUP_VALUE, STRING_SPLIT | — |
| 17 | SSP0015_SAVE_SHIPMENT_PSI | SSP | 저장 | SaveData_Main | U/I SSP_ANL_SHIP_PLAN_40_WH_IN_CMT, I _WH_IN_CMT_H, U SSP_ANL_SHIP_PLAN_40, I SSP_ANL_SHIP_PLAN_40_WH_IN_H, I SCM_SYS_LOG_BATCH | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 18 | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER | SSP | 저장 | SaveData_Detail_Packer | U/I SSP_ANL_SHIP_CONFIRM, I _H, I XIF_ERP_PACK_SHIP_PLAN_S_SN, I XIF_SCS_PACK_SHIP_PLAN_S_SN, I SSP_MST_SEND_MAIL_REQ, I SCM_SYS_LOG_BATCH | PR_SCM_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_HIST |
| 19 | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | SSP | 저장 | SaveData_Detail | U/I SSP_ANL_SHIP_CONFIRM, I _H, I XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, I SSP_ANL_SHIP_CONFIRM_CHG_REQ/_DE, D/I SSP_ANL_SHIP_PLAN_40, I SSP_MST_SEND_MAIL_REQ, I DM_PLN_MKT_FCST_CONFIRM, DELETE:A / UPDATE:A(별칭), #TBLDYNAMIC_SSP0015_40_STD, #T_CONFIRM_ID, #T_SSP, #T_SSP_SUM, #T_MKT_RESULT, #T_MKT_RESULT_SUM, #TEMP_SALES_RESULT, #TEMP_SHIP_RESULT | PR_SCM_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_DM_SSP_CONFIRM_SYNC, PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_SSP_MAIL_SEND_ADJUST_MST, PR_SSP_ANL_SHIP_CONFIRM_ROUTE |
| 20 | SSP0015_SAVE_BLOCK_STOCK_DATA | SSP | 저장 | SaveData_Detail | S/U/I SSP_ANL_HOLD_STOCK, I SCM_SYS_LOG_BATCH | PR_SCM_SYS_LOG_BATCH |
| 21 | SSP0015_SAVE_MES_STOCK | SSP | 저장 | SaveData_Detail (2곳) | MERGE SSP_ANL_MES_FCS_STOCK_40_C, MERGE SSP_ANL_SHIP_PLAN_40, #TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP | PR_SCM_SYS_LOG_BATCH |
| 22 | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | SSP | 저장 | GetERPInterface | I SSP_ANL_SHIP_ERP_ERROR_CONFIRM, U SSP_ANL_SHIP_CONFIRM_CHG_REQ/_DE | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 23 | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | SSP | 저장 | GetERPInterface / GetErpIFCheckNew | U SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, U/D SSP_ANL_SHIP_CONFIRM, I XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 24 | SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING | SSP | 저장 | SoNo / NonSoNo / NewNonSoNo | I SSP_ANL_SHIP_CONFIRM_CHG_REQ/_DE, I XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, U _CHG_REQ_DE | PR_SCM_SYS_LOG_BATCH, **PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH**, PR_SCP_SYS_LOG_BATCH |
| 25 | SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | SSP | 저장 | SoNo / NonSoNo / NewNonSoNo | I SSP_ANL_SHIP_CONFIRM_CHG_REQ/_DE, I XIF_ERP_PACK_SHIP_PLAN_S_SN, I XIF_SCS_PACK_SHIP_PLAN_S_SN, U _CHG_REQ_DE | PR_SCM_SYS_LOG_BATCH, **PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER**, PR_SCP_SYS_LOG_BATCH |
| 26 | SSP0015_GET_ERP_SO_NO_CNT | SSP | 검증 | GetErpSoNoCnt | SSP_ANL_SHIP_CONFIRM | — |
| 27 | SSP0015_GET_SHIPMENT_STATUS | SSP | 검증 | GetShipmentStatusChk | SSP_ANL_SHIP_CONFIRM, STRING_SPLIT | — |
| 28 | SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING | SSP | 저장 | (진입점 미연결) GetErpIFCheck / GetErpIFCheckNew_ | U SSP_ANL_SHIP_CONFIRM_CHG_REQ/_DE | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 29 | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | SSP | 배치성 저장 | GetErpIFCheckNew (화면 직접호출) + DRAFTING SP 내부 EXEC | I XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, U SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, NERP_CONV_MASTER, DM_PLN_MKT_FCST | PR_SCP_SYS_LOG_BATCH |
| 30 | PR_SCM_SYS_LOG_BATCH | SCP | 로그 | (진입점 미연결) | I SCM_SYS_LOG_BATCH | — |
| 31 | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | SSP | 검증 | EngProcessingChk | SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL | — |
| 32 | SCM0001_GET_DIVISION | SCM | 조회 | (진입점 미연결) | SCM_MST_DIVISION | — |
| 33 | SCP0009_GET_SHEET_CALENDAR_3SPAN | SCP | 조회(Grid 헤더) | InitSpread > GetSpdTitle | SCM_SYS_CALENDAR_M | — |
| 34 | SCM0001_GET_SCP_DAY_PERIOD | SCP | 조회(기간 기본값) | GetDayRange | SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, FN_MULTY_TIME, FN_WEEKOFDAY_DATE, CTE_DATE | — |
| 35 | SSP0202_GET_SCS_CONFIRM_ID_CHECK | SSP | 검증 | chkSaveYN | SCM_ADM_LOOKUP_MASTER_DETAIL, DYNAMIC | — |
| 36 | SCM_SSP_CHECK_CONFIRM_CHANGETIME | SSP | 검증 | ChkConfirmChangeTime | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | PR_SCM_SYS_LOG_BATCH |
| 37 | SSP0002_GET_USER_INFO_LIST | SSP | 조회(권한) | EditButton > GetSSPUserCheck | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | — |
| 38 | SSP0015_SAVE_SHIPMENT_PSI_COMMENTS | SSP | 저장 | 팝업 SaveData | U SSP_ANL_SHIP_PLAN_40, I SSP_ANL_SHIP_PLAN_40_WH_IN_H, U/I SSP_ANL_SHIP_PLAN_40_WH_IN_CMT, I _WH_IN_CMT_H | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |

> 주석 처리된 호출(SCP.GET_DATE_RANGE_1MONTH, SCP.SCM0001_GET_SCP_PERIOD, 3573줄의 SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER)은 '주석 처리됨'이므로 전환 대상에서 뺍니다. 단, SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER는 3439줄에서 활성 호출되므로 전환 대상입니다.

### 1-1. 공통 함수/유틸 의존 (전환 동반 대상)
FN_GET_IN_STR, FN_SCM_SPLIT, FN_GET_LOOKUP_VALUE, FN_LIST_LOOKUP_VALUE, FN_GET_ITEM_NICKNAME, FN_GET_SCM_SITE_DESCRIPTION, FN_CHAR_TO_DATE, FN_GET_SSP_ANL_SHIP_FROZEN, FN_GET_SSP_ETA_DATE, FN_ZERO_LPAD, FN_MULTY_TIME, FN_WEEKOFDAY_DATE, FN_NEXT_DAY, FN_GET_SSP_SITE_INFO, FN_GET_SSP_SITE_INFO_EXCEPTION, FN_GET_SSP_VMI_YN, FN_GET_SSP_MKT_FCST_INCOTERMS, FN_GET_SSP_MKT_OWNER_NAME, FN_GET_SITE_CUSTOMER_INFO, FN_SPLITSTRING, UF_FX_STRING_SPLIT, SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, STRING_SPLIT(MSSQL 내장)

### 1-2. 외부 I/F 테이블 (쓰기)
| I/F 테이블 | 쓰는 SP |
|---|---|
| XIF_ERP_SHIP_PLAN_CONFIRM_S_SN | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40, SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING, SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| XIF_ERP_PACK_SHIP_PLAN_S_SN | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER, SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| XIF_SCS_PACK_SHIP_PLAN_S_SN | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER, SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |

## 2. 공통코드 분기 (biz:CommonData.CommonDataList → UP_FX_GetCommonDataList)

| code | 호출 지점 | 원천 테이블 | 비고 |
|---|---|---|---|
| PlanDateShip | InitControls:568, EditButton:1753/1757, SetChangedControl:2202/2210/2218 | SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_SHIP_PLAN_P, SSP_PLAN_VERSION_V | 분기 안에서 STRING_SPLIT 사용 |
| LookupCommon | SpdMain_ActiveSheetChanged:1400/1452 | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | LOOKUP 타입 파라미터 확인 필요 |
| TransMode | SpdDetail_CellClick:8583, SpdDetail_ClipboardPasted:8954 | SCP_MST_BOD_V | 셀 콤보 + 붙여넣기 시 CODE 검증 |
| ShipToCodeByDivision | SpdDetail_CellClick:8604 | SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER, SCM_MST_SITE | 셀 콤보 |
| PERIOD_{p:value} | SetChangedPeriod:9207 (진입점 미연결) | DB 보강 없음 → 확인 필요 | 런타임 코드 |
| PERIOD2_{p:value} | SetChangedPeriod:9211 (진입점 미연결) | DB 보강 없음 → 확인 필요 | 런타임 코드 |

## 3. FoxQuery 미등록 / 직접 호출 SP
- Fact Pack '확인 필요(미등록)' 항목은 **0건**입니다. FoxQuery 엔드포인트 33종은 모두 `MATCH`입니다.
- 직접 호출은 아니지만, **화면에서 직접 부르는 배치성 SP**는 따로 관리해야 합니다.
  - `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`: 화면(GetErpIFCheckNew 7389/7419)이 직접 호출하고, `SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING` 내부에서도 EXEC합니다. 호출처가 둘이므로 UI PKG에 합치지 말고 standalone으로 유지할지 검토가 필요합니다(확인 필요).
  - `PR_SCM_SYS_LOG_BATCH`: 화면 엔드포인트로는 진입점 미연결이지만, 여러 저장 SP 내부에서 EXEC합니다.
- SP 내부에서만 EXEC되고 화면 엔드포인트가 아닌 SP(전환 범위 확인 필요): PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SCP_SYS_LOG_BATCH, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER, PR_DM_SSP_CONFIRM_SYNC, PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_SSP_MAIL_SEND_ADJUST_MST, PR_SSP_ANL_SHIP_CONFIRM_ROUTE
- 스키마 키와 SP 접두어가 맞지 않는 경우: `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `SCP.PR_SCM_SYS_LOG_BATCH`(SCP 키로 SCM 접두 SP 호출). TO-BE 매핑 키를 정할 때 주의하세요.

## 4. Oracle 전환 시 확인 포인트 (사실 근거)

| # | 항목 | 해당 SP | 근거 |
|---:|---|---|---|
| 1 | `STRING_SPLIT` 내장 함수 대체 | UP_FX_GetCommonDataList(PlanDateShip), SSP0015_GET_SHIPMENT_PSI_PACKER(_PAST), GET_WH_STOCK, GET_MES_STOCK, GET_BLOCK_STOCK, GET_STOCK_LOCATION_DETAIL, GET_SCS_STOCK, GET_SHIPMENT_RESULT(_PACKER), GET_SHIPMENT_STATUS | REF:STRING_SPLIT |
| 2 | `#임시테이블` → GTT 또는 컬렉션 | GET_SHIPMENT_PSI, _PACKER, _PACKER_PAST, SAVE_MES_STOCK, SAVE_SHIPMENT_REQUEST_CONFIRM_40, SCM_SSP_DELETE_…_BY_CONFIRM | CREATE/INSERT:#… |
| 3 | 동적 SQL(DYNAMIC@) → EXECUTE IMMEDIATE / OPEN FOR | GET_SHIPMENT_PSI, _PACKER, _PACKER_PAST, GET_SHIPMENT_CONFIRM_DETAIL(_PACKER), GET_SHIPMENT_PSI_COMMENTS, SSP0026_GET_REQUEST_DETAIL_PACK, SSP0202_GET_SCS_CONFIRM_ID_CHECK | DYNAMIC@ |
| 4 | 동적 PIVOT (#TMP_RESULT_PIVOT_TABLE, 컬럼 = 캘린더/Measure) | GET_SHIPMENT_PSI_PACKER, _PACKER_PAST | INSERT:#TMP_RESULT_PIVOT_TABLE, SCM_MST_SHEET_MEASURE, SCM_SYS_CALENDAR_M |
| 5 | 동적 타이틀셋 | GET_SHIPMENT_PSI 계열 3종 | SCM_MST_TITLESET_USER (메타 12행), #TBLDYNAMICTITLEST_SSP0015 |
| 6 | 정적 테이블 추출 불가(DYNAMIC 본문) → 원문 정독 필요 | GET_SHIPMENT_CONFIRM_DETAIL(_PACKER), GET_SHIPMENT_PSI_COMMENTS, SSP0026_GET_REQUEST_DETAIL_PACK | 참조 객체가 DYNAMIC과 FN뿐 |
| 7 | MERGE 문 변환 | SAVE_MES_STOCK (2건) | MERGE:SSP_ANL_MES_FCS_STOCK_40_C, SSP_ANL_SHIP_PLAN_40 |
| 8 | 별칭 대상 UPDATE/DELETE(`UPDATE:A`, `DELETE:A`) | SAVE_SHIPMENT_REQUEST_CONFIRM_40 | MSSQL `UPDATE A … FROM` 형식으로 보임 → MERGE/서브쿼리로 변환 필요(원문 확인 필요) |
| 9 | 배열 파라미터 분해(SCM_ARR_SPL_CNT/VAL) | 저장 SP 전반 | REF:SCM_ARR_SPL_* |
| 10 | 트랜잭션 / 로그 래퍼 | 저장 SP 전반 | PR_SCM_SYS_LOG_BATCH(_CALL_TRAN) EXEC. 내부 COMMIT 여부 확인 필요 |
| 11 | CTE 이름이 테이블로 추출됨 | GET_SHIPMENT_RESULT(_PACKER), SCM0001_GET_SCP_DAY_PERIOD, SAVE_…CONFIRM_PACKER | RESULT_ERP_C_EXIST, PLAN_SSP, CTE_DATE 등은 실제 테이블이 아님 |
| 12 | 외부 I/F 테이블 쓰기 | §1-2 | 사내/클라우드에 XIF_* 존재 여부와 권한 확인 필요 |
| 13 | 메일 요청 / 이력 / 라우팅 / DM 동기화 하위 SP | CONFIRM_40, CONFIRM_PACKER | EXEC 체인 6종. 같이 전환해야 함 |

### 난이도 (사실 기반)
| 등급 | SP | 근거 |
|---|---|---|
| 높음 | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | 참조 객체 60개 이상, #임시테이블 8종, EXEC 6종, 별칭 UPDATE/DELETE, I/F 쓰기 |
| 높음 | SSP0015_GET_SHIPMENT_PSI_PACKER / _PACKER_PAST / SSP0015_GET_SHIPMENT_PSI | 동적 SQL + PIVOT + 타이틀셋 + #임시테이블 다수 |
| 높음 | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER, SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING(_PACKER), SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | I/F 쓰기 + EXEC 체인 |
| 중간 | GET_SHIPMENT_CONFIRM_DETAIL(_PACKER), GET_SHIPMENT_PSI_COMMENTS, SSP0026_GET_REQUEST_DETAIL_PACK, SSP0202_GET_SCS_CONFIRM_ID_CHECK | 동적 SQL (본문 미추출) |
| 중간 | SAVE_MES_STOCK, SAVE_BLOCK_STOCK_DATA, SAVE_SHIPMENT_PSI, SAVE_SHIPMENT_PSI_COMMENTS, SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM, SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING | MERGE, 배열 분해, 이력 INSERT |
| 중간 | GET_WH_STOCK, GET_MES_STOCK, GET_BLOCK_STOCK, GET_STOCK_LOCATION_DETAIL, GET_SCS_STOCK, GET_SHIPMENT_RESULT(_PACKER), GET_SHIPMENT_STATUS | STRING_SPLIT 대체 + 다중 조인 |
| 낮음 | DM0003_GET_BUCKET_TYPE_CODE, SSP0002_GET_NERP_CODE, SSP0015_GET_ERP_SO_NO_CNT, SSP0003_GET_SSP_PLAN_PROCESSING_CHECK, SCM0001_GET_DIVISION, SCP0009_GET_SHEET_CALENDAR_3SPAN, SCM0001_GET_SCP_DAY_PERIOD, SCM_SSP_CHECK_CONFIRM_CHANGETIME, SSP0002_GET_USER_INFO_LIST, PR_SCM_SYS_LOG_BATCH | 단일/소수 테이블 SELECT 또는 로그 INSERT |

> 난이도는 참조 객체 수와 MSSQL 고유 구문 유무로만 판단했습니다. SP 본문 원문은 Fact Pack에 없으므로, 실제 전환 전에 원문을 정독해야 합니다(확인 필요).

=== FILE: tobe_design.md ===
# SSP0015 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

### 1-1. 상단(메인) 조회조건
| 순서 | 라벨(원문) | As-is 컨트롤 | 필수 | 데이터/기본값 원천 | 연동 |
|---:|---|---|:---:|---|---|
| 1 | Division* | clbDivision (UsrCombo) | Y | 원천 확인 필요 (GetDivision / SCM0001_GET_DIVISION은 진입점 미연결) | 변경 → SetChangedControl → PlanDateShip 재조회 + GetDayRange |
| 2 | Plan-date* | cboPlanDate (UsrCombo) | Y | `biz:CommonData.CommonDataList [code=PlanDateShip]` | 변경 → GetDayRange(SCM0001_GET_SCP_DAY_PERIOD) |
| 3 | Period* | drpPeriod | Y | SCM0001_GET_SCP_DAY_PERIOD. InitControls의 dtShipmentInputPeriod(VALUE / Diff_VALUE) 사용 | — |
| 4 | From Site | clbPlantSite (CheckedList) | N | 확인 필요 (GetSSPInnerTable: PLANT_ID / SCM_SITE_ID 컬럼 가능성) | — |
| 5 | Bucket | cboBucketType | N | DM0003_GET_BUCKET_TYPE_CODE | DAILY / WEEKLY / MONTHLY → D_/W_/M_ 컬럼 표시 |
| 6 | Sum | chkSum | N | — | Sum 계열 컬럼 표시 |
| 7 | (Measure 버튼) | btnMeasure | — | — | 클릭 → InitSpread 재구성 |
| 8 | Model | txtItemId + btnItemId | N | 선택 팝업 내용 확인 필요 | — |
| — | My Model / Part Leader / Team Leader / Delegatee Model | chk* 4종 | — | **Visible=false** (My Model은 Checked=true) | 화면에 표시하지 않음. 값은 SP 파라미터로 쓰일 수 있음(확인 필요) |

### 1-2. 하단(Detail) 조회 바
| 라벨(원문) | 컨트롤 | 비고 |
|---|---|---|
| Shipment Date | drpPeriod2 | |
| Requestor | txtRequestor + btnRequestor | 사용자 선택 팝업(확인 필요) |
| 확인 필요 | clbResultType, txtModel2 + btnItemID2, drpPeriod3, txtLotID | 라벨 원문 미확보 |
| Search | btnSearch | 활성 Detail 시트별 조회 |

## 2. 액션별 호출 API 후보

| 액션 | As-is 진입 | 호출 API 후보 (순서는 확인 필요) |
|---|---|---|
| 화면 진입 | Form_Load | CommonData PlanDateShip → DM0003_GET_BUCKET_TYPE_CODE → SCM0001_GET_SCP_DAY_PERIOD → SCP0009_GET_SHEET_CALENDAR_3SPAN(헤더) |
| Division 변경 | clbDivision_SelectedIndexChanged | CommonData PlanDateShip, SCM0001_GET_SCP_DAY_PERIOD |
| Plan-date 변경 | CboPlanDate_SelectedIndexChanged | SCM0001_GET_SCP_DAY_PERIOD |
| 상단 시트 전환 | SpdMain_ActiveSheetChanged | CommonData LookupCommon, PlanDateShip, SCM0001_GET_SCP_DAY_PERIOD, SCP0009_GET_SHEET_CALENDAR_3SPAN |
| Measure | btnMeasure_Click | SCP0009_GET_SHEET_CALENDAR_3SPAN (Grid 재구성) |
| 조회 | FindButton | 시트/조건에 따라 SSP0015_GET_SHIPMENT_PSI \| SSP0015_GET_SHIPMENT_PSI_PACKER \| SSP0015_GET_SHIPMENT_PSI_PACKER_PAST (+ SSP0002_GET_NERP_CODE, SCP0009_GET_SHEET_CALENDAR_3SPAN) |
| 상단 셀 더블클릭 | SpdMain_CellDoubleClick | SSP0015_GET_SHIPMENT_CONFIRM_DETAIL, SSP0015_GET_WH_STOCK, SSP0015_GET_MES_STOCK, SSP0015_GET_BLOCK_STOCK, SSP0015_GET_STOCK_LOCATION_DETAIL(+NERP), SSP0015_GET_SCS_STOCK, SSP0015_GET_SHIPMENT_PSI. Comments 팝업 데이터(GAP / BEFORE_QTY / USER_ADD_QTY) 전달 |
| Detail Search | BtnSearch_Click | 시트별: Confirm Detail → SSP0015_GET_SHIPMENT_CONFIRM_DETAIL(_PACKER) / Request Detail → SSP0026_GET_REQUEST_DETAIL_PACK / W/H stock → SSP0015_GET_WH_STOCK / Hold stock Detail → SSP0015_GET_BLOCK_STOCK / Stock Detail → SSP0015_GET_MES_STOCK / SCS Stock Detail → SSP0015_GET_SCS_STOCK / Stock Location Detail → SSP0015_GET_STOCK_LOCATION_DETAIL / WH In Plan Detail → SSP0015_GET_SHIPMENT_PSI_COMMENTS / Shipment Result → SSP0015_GET_SHIPMENT_RESULT 또는 _PACKER |
| Detail 셀 클릭 | SpdDetail_CellClick | CommonData TransMode, ShipToCodeByDivision (셀 콤보). 헤더 CheckBox 전체 토글 |
| Detail 붙여넣기 | SpdDetail_ClipboardPasted | CommonData TransMode (CODE 검증) |
| 편집 | EditButton | CommonData PlanDateShip, SSP0002_GET_USER_INFO_LIST(사용자 권한 확인) |
| 저장 — 메인 | SaveButton > SaveData_Main | SSP0015_SAVE_SHIPMENT_PSI |
| 저장 — Detail(40) | SaveButton > SaveData_Detail | Validation_Check → SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 / SSP0015_SAVE_BLOCK_STOCK_DATA / SSP0015_SAVE_MES_STOCK → 재조회(GET_SHIPMENT_PSI, GET_SHIPMENT_CONFIRM_DETAIL, GET_MES_STOCK) |
| 저장 — Detail(Packer) | SaveButton > SaveData_Detail_Packer | SSP0202_GET_SCS_CONFIRM_ID_CHECK, SSP0003_GET_SSP_PLAN_PROCESSING_CHECK, SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER, GetERPInterface{SCM_SSP_CHECK_CONFIRM_CHANGETIME, SSP0015_GET_ERP_SO_NO_CNT, SSP0015_GET_SHIPMENT_STATUS, SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM, SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, SoNo/NonSoNo → SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING(_PACKER), GetErpIFCheckNew → PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH} → SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER 재조회 |
| Comments 저장 | 팝업 btnButtonList | SSP0015_SAVE_SHIPMENT_PSI_COMMENTS |

> 검증 순서와 메시지는 Fact Pack에 없습니다. TO-BE 구현 전에 As-is 원문과 SP 내부 검증을 먼저 대조해야 합니다(확인 필요). Validation_Check 검증 대상 필드: shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE (confirm_id 기준).

## 3. division별 Grid 변형 요약
- 메타(SCM_MST_SHEET_COLUMNS / SCM_MST_SHEET_MEASURE)와 최종 Grid 모두 **14개 division에서 차이가 없습니다.**
- 변형 요인은 division이 아니라 다음과 같습니다.
  1. 상단 시트: `Shipment PSI(Mobility & IT)`(10컬럼, Measure 12/1) vs `Shipment PSI(Packer)`(8컬럼, Measure 6/0)
  2. Bucket Type(DAILY / WEEKLY / MONTHLY)과 Sum 체크에 따른 일자 컬럼 표시
  3. `ichkbtn` 상태에 따른 SetSoNoColumnVisible 폭 전환
  4. Packer / 40 저장 SP 분기(division 연관성 확인 필요)
- TO-BE에서는 메타 + 동적 일자 컬럼(SCP0009_GET_SHEET_CALENDAR_3SPAN, 3단 헤더 + SUM)을 결합하고, 토요일 파랑 / 일요일 빨강 헤더 색상을 재현해야 합니다.

## 4. 권한(C/R/U/D) 관련 사실
| 항목 | 사실 |
|---|---|
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 14행, TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행 |
| R (조회) | FindButton, btnSearch, 더블클릭 조회 |
| U/C (저장) | SaveButton(SaveData_Main / _Detail / _Detail_Packer), 팝업 저장. DML 대상은 oracle_migration.md §1 |
| D (삭제성) | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM(DELETE SSP_ANL_SHIP_CONFIRM), SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING(진입점 미연결). 별도 Delete 버튼 진입점은 Fact Pack에 없음 |
| 편집 진입 | EditButton > GetSSPUserCheck → SSP0002_GET_USER_INFO_LIST (TB_FX_USERGROUPINFO, TB_FX_USERGROUPAUTHEXTENTION 참조) |
| 시트 권한 | `WH In Plan Detail` 시트는 `drPgmAuthId != null`일 때만 생성 |
| 그룹/사용자 필터 | SetChangeControl이 GROUP_ID / USER_ID / UserInfoContext.Current.NowGroupID 사용. GetSSPInnerTable(DEPT_ID, COMPANY_ID, PLANT_ID 등) |
| 잠금 | SpdDetail_CellClick에서 `siDetail.IsLock(SheetName)==false`일 때만 헤더 체크 토글 |
| 담당 모델 필터 | 조회 SP 다수가 SSP_MST_MODEL_USER / SSP_MST_DELEGATE 참조. 숨김 체크박스(My Model 등)와 연관된 것으로 보이나 확인 필요 |
| 버튼 권한 메타(MNU / BTN) | Fact Pack에 없음 → 확인 필요 |

## 5. 미확정 사항
1. FindButton / SaveButton 내부 분기 조건과 호출 순서
2. Detail 조회 바 6개 컨트롤 라벨 원문, 팝업 컨트롤 라벨 원문(props.csv 잘림)
3. W/H stock, W/H stock Detail, Stock Location Detail, WH In Plan Detail 시트 컬럼 전체 목록(grid_effective.csv 잘림)
4. W/H stock Detail 시트의 조회 SP
5. Shipment Confirm Detail 표시 40 vs 메타 39의 차이
6. 메타 전용 시트(`Shipment PSI(IT & Mobile)`, `MES Stock Detail`)와 `SSP0015_TEMP2` 메타의 이관 여부
7. 진입점 미연결 메서드 6종의 실제 사용 여부
8. SaveButton > SaveData 귀속(팝업 SaveData vs PersonalSettingPopup.SaveData)
9. chkERPIFBlockYn(BLOCK_YN / PERIOD) 데이터 원천과 저장 차단 로직
10. 숨김 체크박스 4종의 SP 파라미터 반영 여부
11. Packer / 40 분기와 division의 관계
12. 동적 SQL SP 4종(GET_SHIPMENT_CONFIRM_DETAIL(_PACKER), GET_SHIPMENT_PSI_COMMENTS, SSP0026_GET_REQUEST_DETAIL_PACK)의 실제 참조 테이블
