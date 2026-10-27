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
