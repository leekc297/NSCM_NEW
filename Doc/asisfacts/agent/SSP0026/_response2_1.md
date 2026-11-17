=== FILE: business_analysis.md ===
# SSP0026 Shipment Request Pack — 업무분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0026)과 1차 분석서(analysis.md · web_components.md · tobe_design.md)에 있는 사실만 사용했습니다. Fact Pack에서 확인되지 않은 내용은 **확인 필요**로 적었습니다.
> 분석 대상은 현행(current) 파일과 공용(shared) 팝업 파일입니다. 구버전 사본(legacy) `06.UIL\GSCM.SSP.Plan.UIL\SSP0026_ShipmentRequestPack.cs`는 분석에서 뺐습니다.
> 화면설계서 §5 액션 명세와 단위테스트의 근거 열은 이 문서 §5의 엔드포인트 이름을 그대로 씁니다.

## 1. 업무 목적·범위

### 1-1. 목적 (사실 근거로 한정)
| 항목 | 사실 | 출처 |
|---|---|---|
| 화면 ID / 클래스 | SSP0026 / `SSP0026_ShipmentRequestPack` | Fact Pack §1 |
| 도메인 | SSP | 1차 분석서 §1 |
| 처리 대상 | 출하 요청(Shipment Request)을 조회하고 저장합니다. 메인은 Pack Biz와 Cell Biz 두 시트, 상세는 Request Detail과 Result Detail 두 시트입니다. | 시트 생성 CreateSpread:331/340/351/358/363 |
| 저장 대상 테이블 | Pack: `SSP_ANL_SHIP_PLAN_PACK_REQ`, `SSP_ANL_SHIP_REQ_P`, `SSP_ANL_SHIP_REQ_P_H`, `XIF_SCS_PACK_SHIP_PLAN_S_SN` / Cell: `DM_PLN_SHIPMENT_REQ`, `DM_PLN_SHIPMENT_REQ_H` / 공통 로그: `SCM_SYS_LOG_BATCH` | 엔드포인트 objects |
| 업무 목적 문구 | 업무 목적을 설명하는 원문(메뉴 설명, 업무 정의서)은 Fact Pack에 없습니다. | **확인 필요** |

### 1-2. 범위
| 범위 | 포함 내용 |
|---|---|
| 메인 화면 | 조회조건 패널(usrConditionPanel1), 메인 그리드 spdMain(Pack Biz / Cell Biz), 하단 상세 조회조건(usrLayoutControl3), 상세 그리드 spdDetail(Shipment Request Detail / Shipment Result Detail), Excel 양식 그리드 spdSub(Shipment Request Detail Excel) |
| 공용 팝업 | `SSP0026_BodItemPopup`(BOD Item), `SSP0026_ItembyDivisionPopup`(Division별 Item, 시트 Project) |
| 범위 밖 | legacy 사본, 주석 처리된 Division 조회 호출 2건(팝업 389·375줄, FoxQuery 미등록), 메타에만 있고 코드가 참조하지 않는 시트 `Shipment Request Detail_BACKUP` |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 (핸들러 > 메서드 > 엔드포인트) | 결과 |
|---:|---|---|---|
| S1 | 화면을 엽니다 | Form_Load > InitControls: `biz:CommonData.CommonDataList`[MyDivision](231), [Measure](306), GetBucketType > `DM.DM0003_GET_BUCKET_TYPE_CODE`(3044) / Form_Load > CreateSpread > InitSpread > GetSpdTitle > `SSP.SSP0026_GET_SPREAD_TITLE`(3027) | Division·Bucket 콤보 값이 채워지고 시트가 생성됩니다. Pack Biz는 조건 없이 생성되고, Cell Biz는 `drPgmAuthId != null`일 때만 생성됩니다. |
| S2 | 조회조건을 입력하고 조회 버튼(FindButton)을 누릅니다 | FindButton > FindData: `biz:CommonData.CommonDataList`[Measure](755), 활성 시트에 따라 `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK`(787) 또는 `SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL`(848), InitSpread > `SSP.SSP0026_GET_SPREAD_TITLE` | spdMain에 Measure별 행과 날짜 버킷(D_/W_/M_) 컬럼이 표시됩니다. |
| S3 | Division을 바꿉니다 | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle > `SSP.SSP0026_GET_SPREAD_TITLE` | 그리드 헤더를 다시 구성합니다. |
| S4 | Bucket, Sum, 과거기간 표시를 바꿉니다 | cboBucketType_SelectedIndexChanged / chkSum_CheckedChanged / chkPastPeriod_CheckedChanged > SetSpreadColumn(2124 / 2893 / 3776) | 엔드포인트를 호출하지 않고 컬럼 표시만 바꿉니다(§4 R-B). |
| S5 | Measure 버튼을 누릅니다 | btnMeasure_Click > InitSpread > GetSpdTitle > `SSP.SSP0026_GET_SPREAD_TITLE` | 그리드를 다시 구성합니다. Measure 선택 UI가 있는지는 **확인 필요**입니다. |
| S6 | 메인 그리드 행을 더블클릭합니다 | SpdMain_CellDoubleClick > FindData_Detail_DblClick: `SSP.SSP0026_GET_REQUEST_DETAIL_PACK`(1232) 또는 `SSP.SSP0026_GET_REQUEST_DETAIL_CELL`(1274), InitSpread > `SSP.SSP0026_GET_SPREAD_TITLE` | 선택한 행 기준으로 spdDetail의 Shipment Request Detail을 조회합니다. |
| S7 | 하단 조건을 입력하고 btnSearch를 누릅니다 | BtnSearch_Click: spdDetail 활성 시트가 0이면 FindData_Detail > `SSP.SSP0026_GET_REQUEST_DETAIL_PACK`(1071) / `SSP.SSP0026_GET_REQUEST_DETAIL_CELL`(1115), 1이면 FindData_Result_Detail > `SSP.SSP0026_GET_RESULT_DETAIL`(969) + `SSP.SSP0026_GET_SPREAD_TITLE` | Request Detail 또는 Result Detail이 조회됩니다(3112 / 3120). |
| S8 | 그리드에서 콤보를 고르거나 붙여넣습니다(메인) | SpdMain_ComboSelChange / SpdMain_ClipboardPasted > FindData_BOD_Main: `SSP.SSP0026_GET_BOD_ITEM`(3930), `biz:CommonData.CommonDataList`[TransMode](3951) | BOD Item과 Trans Mode 값이 반영됩니다. 반영 대상 컬럼은 **확인 필요**입니다. |
| S9 | 그리드에서 콤보를 고르거나 붙여넣습니다(상세) | SpdDetail_ComboSelChange: `biz:CommonData.CommonDataList`[ShipToCodeByDivision](3191) / SpdDetail_ClipboardPasted: [ShipToCodeByDivision](3464, 3482) / 두 핸들러 모두 FindData_BOD를 거쳐 `SSP.SSP0026_GET_BOD_ITEM`(3982), [TransMode](4003) 호출 | TO_SITE를 바꾸면 SHIPTO_CODE 콤보를 다시 채웁니다. BOD와 TransMode도 다시 조회합니다. |
| S10 | 저장 버튼(SaveButton)을 누릅니다(메인) | SaveButton > SaveData: `SSP.SSP0026_SAVE_SHIP_REQ_PACK`(1508) 또는 `SSP.SSP0026_SAVE_SHIP_REQ_CELL`(1580), 이어서 FindData로 재조회 | 저장 후 메인 그리드를 다시 조회합니다. |
| S11 | 저장 버튼(SaveButton)을 누릅니다(상세) | SaveButton > SaveData_Detail: `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK`(1783) 또는 `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_CELL`(1860), 이어서 FindData_Detail로 재조회 | 저장 후 상세 그리드를 다시 조회합니다. 메인 저장(S10)과 상세 저장(S11)을 가르는 조건은 **확인 필요**입니다(bEdit_Mode_Detail 플래그, EditButton:675·714). |
| S12 | Excel Form 버튼(formDown)을 누릅니다 | btnExcelFormDownload_Click > FindData_Request_Detail_DownLoad > `SSP.SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN`(4309) | Shipment Request Detail Excel(spdSub) 기준으로 양식을 내려받습니다. |
| S13 | Upload 버튼(btnExcelUpload)을 누릅니다 | btnExcelUpload_Click: MSG00265 확인 → FindData(755/787/848/3027) · FindData_Detail(1071/1115) | 업로드 결과를 반영하고 다시 조회합니다. 파일을 파싱하는 로직은 **확인 필요**입니다. |
| S14 | BOD Item 팝업을 사용합니다 | SSP0026_BodItemPopup Form_Load > FindData > `SSP.SSP0026_GET_BOD_ITEM`(254), InitControls > GetDivision > `SCM.SCM0001_GET_DIVISION`(388), GetDivisionbyScmSite > `SCM.SCM0001_GET_SITE_BY_DIVISION`(402). btnButtonList_UsrButtonList_Click_Detected 또는 FindButton을 누르면 재조회 | BOD Item 목록이 표시됩니다. 어느 메인 버튼이 이 팝업을 여는지는 **확인 필요**입니다. |
| S15 | Item by Division 팝업을 사용합니다 | SSP0026_ItembyDivisionPopup Form_Load > FindData > `SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP`(242), GetDivision > `SCM.SCM0001_GET_DIVISION`(374) | Project 시트 목록이 표시됩니다. 어느 메인 버튼이 이 팝업을 여는지는 **확인 필요**입니다. |

## 3. 업무 흐름도 (텍스트 단계)

```
[1] 화면 진입 (Form_Load)
     ├─ Division 콤보 ← biz:CommonData.CommonDataList [MyDivision]
     ├─ Measure ← biz:CommonData.CommonDataList [Measure]
     ├─ Bucket 콤보 ← DM.DM0003_GET_BUCKET_TYPE_CODE
     └─ 시트 생성 ← SSP.SSP0026_GET_SPREAD_TITLE
           spdMain: Pack Biz (항상) / Cell Biz (drPgmAuthId != null)
           spdDetail: Shipment Request Detail / Shipment Result Detail
           spdSub: Shipment Request Detail Excel
        ↓
[2] 조회조건 입력 → FindButton
     ├─ 활성 시트 0 (Pack Biz) → SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK
     └─ 활성 시트 1 (Cell Biz) → SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL
        ↓  (헤더 SSP.SSP0026_GET_SPREAD_TITLE, 표시 규칙은 SetSpreadHeaderSpan / SetSpreadColumn)
[3] 표시 전환 (Bucket / Sum / Past Period, 서버 호출 없음)
        ↓
[4] 상세 확인
     ├─ 메인 행 더블클릭 → SSP.SSP0026_GET_REQUEST_DETAIL_PACK / _CELL
     └─ btnSearch
          ├─ 상세 시트 0 → SSP.SSP0026_GET_REQUEST_DETAIL_PACK / _CELL
          └─ 상세 시트 1 → SSP.SSP0026_GET_RESULT_DETAIL
        ↓
[5] 편집 (그리드 콤보·붙여넣기)
     ├─ 메인 → SSP.SSP0026_GET_BOD_ITEM + TransMode
     └─ 상세 → ShipToCodeByDivision + SSP.SSP0026_GET_BOD_ITEM + TransMode
     (선택) Excel Form → SSP.SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN
     (선택) Upload → MSG00265 확인 → 재조회
        ↓
[6] 저장 (SaveButton)
     ├─ SaveData        → SSP.SSP0026_SAVE_SHIP_REQ_PACK / SSP.SSP0026_SAVE_SHIP_REQ_CELL → FindData 재조회
     └─ SaveData_Detail → SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK / SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_CELL → FindData_Detail 재조회
```

## 4. 업무 규칙 (사실 근거)

| ID | 규칙 | 근거 |
|---|---|---|
| R-S1 | 메인 조회 SP는 spdMain 활성 시트로 정해집니다. ActiveSheetIndex 0이면 `SSP0026_GET_SHIPMENT_REQUEST_PACK`, 1이면 `SSP0026_GET_SHIPMENT_REQUEST_CELL`입니다. | FindData:787 / 848 |
| R-S2 | 메인 저장 SP도 활성 시트로 정해집니다. Pack이면 `SSP0026_SAVE_SHIP_REQ_PACK`, Cell이면 `SSP0026_SAVE_SHIP_REQ_CELL`입니다. | SaveData:1508 / 1580 |
| R-S3 | 상세 저장 SP는 `SSP0026_SAVE_SHIP_REQ_DETAIL_PACK`(1783)과 `SSP0026_SAVE_SHIP_REQ_DETAIL_CELL`(1860)입니다. 분기 조건은 **확인 필요**입니다. | SaveData_Detail |
| R-S4 | 상세 조회 SP는 `SSP0026_GET_REQUEST_DETAIL_PACK`과 `SSP0026_GET_REQUEST_DETAIL_CELL`입니다. 분기 조건은 **확인 필요**이며, Pack/Cell 활성 시트에 따른 것으로 보이지만 확인되지 않았습니다. | FindData_Detail:1071/1115, FindData_Detail_DblClick:1232/1274 |
| R-S5 | btnSearch는 spdDetail.ActiveSheetIndex가 0이면 Request Detail을, 1이면 Result Detail(`SSP0026_GET_RESULT_DETAIL`)을 조회합니다. | BtnSearch_Click 3112 / 3120 |
| R-S6 | 메인과 상세를 저장한 뒤에는 각각 FindData와 FindData_Detail로 재조회합니다. | flow.csv SaveButton 경로 |
| R-B1 | Bucket이 DAILY이면 `D_`·`W_` 컬럼을 표시하고, `M_`·`W_` 컬럼은 chkSum.Checked를 따릅니다. `W_`는 두 조건에 모두 걸리며, 이는 원문 그대로입니다. | SetSpreadColumn 2909 / 2914 |
| R-B2 | Bucket이 WEEKLY이면 `D_`는 숨기고, `W_`는 표시하고, `M_`은 chkSum.Checked를 따릅니다. | 2921 / 2925 / 2930 |
| R-B3 | Bucket이 MONTHLY이면 `D_`·`W_`는 숨기고 `M_`은 표시합니다. | 2937 / 2941 |
| R-B4 | chkPastPeriod가 해제되어 있고, SUM 헤더 컬럼이 아니며, `date > colDate`이면 컬럼의 Visible을 chkPastPeriod.Checked로 둡니다. Designer에서는 chkPastPeriod가 Checked=true, Visible=false입니다. | 2960 |
| R-B5 | 헤더는 3행이며 대분류(LARGE_CLASS_LABEL_NAME)와 소분류(SMALL_CLASS_LABEL_NAME)로 Span합니다. SUM 헤더를 붙입니다. | SetSpreadHeaderSpan 523~577 |
| R-B6 | COLUMN_NAME에 `B_`가 들어 있으면 컬럼을 숨깁니다. | 531 |
| R-B7 | DAY_CODE가 SAT이면 파랑, SUN이면 빨강 글자색입니다. | 542 |
| R-B8 | 날짜 버킷 컬럼은 `SSP0026_GET_SPREAD_TITLE`(SCM_MST_SHEET_COLUMNS + SCM_SYS_CALENDAR_M) 결과로 동적으로 만듭니다. | GetSpdTitle:3027 |
| R-G1 | 활성 시트가 Pack Biz로 바뀌면 SHIPTO_CODE와 ORDER_TYPE_DETAIL을 표시하고 FCST_TYPE을 숨깁니다. | SpdMain_ActiveSheetChanged 3592~3595 |
| R-G2 | Pack Biz로 바뀌었는데 spdDetail에 Shipment Result Detail 시트가 없으면 AddSheet합니다. Cell Biz이면 ChangeSheet만 합니다. | 3604 / 3629 |
| R-G3 | Shipment Request Detail 시트는 MergePolicy.None입니다. | InitSpread:392 |
| R-G4 | Cell Biz 시트는 `drPgmAuthId != null`일 때만 생성됩니다. dtPgmAuthId 필드는 `biz:CommonData.CommonDataList`[LookupCommon]으로 초기화됩니다. | CreateSpread:340, 필드:60 |
| R-V1 | 업로드 전에 MSG00265로 확인을 받습니다. | btnExcelUpload_Click |
| R-V2 | 필수 표시: 메타 라벨에 `*`가 붙은 컬럼이 있습니다(Division*, From ( Plant )*, To ( Sales-Site )*, Incoterms*, Trans Mode*, Model*, Measure*, FCST Type*, Qty*, Shipment Date* 등). 실제로 필수값을 검사하는 코드는 **확인 필요**입니다. | SCM_MST_SHEET_COLUMNS |
| R-V3 | 상세 편집 모드 플래그 bEdit_Mode_Detail이 있고, 시트 잠금 IsLock을 검사합니다. | EditButton:675·714, InsertRow:2049, SpdDetail_ClipboardPasted:3466 |
| R-V4 | SHIP_FROZEN과 CONFIRM_DAY 값을 읽어 셀을 처리합니다. 구체 동작은 **확인 필요**입니다. | Re_Design:4076·4088, ShowCell:4236 |
| R-V5 | BOD 유효성 검사 `SSP0002_GET_BOD_VALID_CHECK`(BodValidChk_Main:3794, BodValidChk:3862)는 진입점이 연결되어 있지 않아 현행에서 실행되지 않는 것으로 판단됩니다. 실제로 쓰이는지는 **확인 필요**입니다. | flow.csv unreached |
| R-D1 | 저장 SP 3종(PACK, CELL, DETAIL_PACK)은 공통으로 `#TBLDYNAMIC_SSP0026_SHPIMENTREQ` 임시테이블, `SCM_ARR_SPL_CNT`/`SCM_ARR_SPL_VAL`(배열 분해), `FN_NEXT_DAY`, `SCM_SYS_CALENDAR_M`, BOD 조회(SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM)를 사용하고 PR_SCP_SYS_LOG_BATCH / PR_SCM_SYS_LOG_BATCH를 EXEC합니다. | 엔드포인트 objects |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| # | 엔드포인트 | SP | 호출 위치 | 읽기 | 쓰기 |
|---:|---|---|---|---|---|
| 1 | `biz:CommonData.CommonDataList` | UP_FX_GetCommonDataList(코드 분기) | MyDivision 231, Measure 306/755, ShipToCodeByDivision 3191/3464/3482, TransMode 3951/4003, LookupCommon 60(필드), MktFcstEditMeasure 2182(미연결), DefaultBucketDay 2499/2561(미연결) | MyDivision: SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION / Measure: SCM_MST_SHEET_MEASURE, DM_MST_CUSTOMER_FCST / ShipToCodeByDivision: SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER, SCM_MST_SITE / TransMode: SCP_MST_BOD_V / LookupCommon: SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL / MktFcstEditMeasure: SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, DM_MST_CUSTOMER_FCST / DefaultBucketDay: SCM_ADM_LOOKUP_MASTER_DETAIL | — |
| 2 | `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` | `SSP0026_GET_SHIPMENT_REQUEST_PACK` | FindData:787 | SCM_MST_TITLESET_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_PLAN_VERSION_V, SCP_PLN_SHIPMENT_PLAN, SCP_PLN_SHIPMENT_PLAN_PEGGING, SCM_MST_SITE, SCP_MST_BOD_N_V, SSP_ANL_SHIP_REQ_P, SCM_DNM_SCS_SHIP_RESULT, SSP_ANL_SHIP_CONFIRM, SCM_DNM_SCS_PROD_PLAN, SCM_MST_SITE_CUSTOMER, SCM_SYS_CALENDAR_M, SCM_DNM_SCS_STOCK, SCM_MST_SHEET_MEASURE, SCM_MST_SITE_ITEM, SCM_MST_PROJECT, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO, STRING_SPLIT, 동적 SQL | #임시테이블만 (#TBLDYNAMICTITLEST_SSP0026, #TMP_RESULT_TABLE, #TMP_ROWDATA, #Z, #QTY, #BOH, #TMP_SCP_ANL_SHIPMENT_PLAN_FG, #TMP_ROWDATA_RN, #TBLDYNAMIC_REQUESTOR, #TMP_RESULT_PIVOT_TABLE(_TEMP)) |
| 3 | `SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL` | `SSP0026_GET_SHIPMENT_REQUEST_CELL` | FindData:848 | SCM_MST_TITLESET_USER, SCP_PLAN_VERSION_V, SSP_PLAN_VERSION_V, SSP_ANL_SHIP_PLAN_40, SCP_PLN_SHIPMENT_PLAN, SCP_PLN_SHIPMENT_PLAN_PEGGING, SCM_MST_SITE, SCP_MST_BOD_N_V, DM_PLN_SHIPMENT_REQ, SSP_ANL_SHIP_CONFIRM, SCM_MST_ITEM_SN, SSP_DNM_FORMATION_POST_CELL, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_MST_SITE_ITEM, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO, STRING_SPLIT, 동적 SQL | #임시테이블만 (#TBLDYNAMIC_SSP0026_40_STD 포함) |
| 4 | `SSP.SSP0026_GET_RESULT_DETAIL` | `SSP0026_GET_RESULT_DETAIL` | FindData_Result_Detail:969 | FN_NEXT_DAY, SCM_SYS_CALENDAR_M, 동적 SQL(대상 테이블 **확인 필요**) | — |
| 5 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` | `SSP0026_GET_REQUEST_DETAIL_PACK` | FindData_Detail:1071, FindData_Detail_DblClick:1232 | 동적 SQL만 추출됨. 대상 테이블 **확인 필요** | — |
| 6 | `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` | `SSP0026_GET_REQUEST_DETAIL_CELL` | FindData_Detail:1115, FindData_Detail_DblClick:1274 | ⚠ **DB에 SP 없음** | — |
| 7 | `SSP.SSP0026_SAVE_SHIP_REQ_PACK` | `SSP0026_SAVE_SHIP_REQ_PACK` | SaveData:1508 | SCM_SYS_CALENDAR_M, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SSP_ANL_SHIP_PLAN_PACK_REQ, SCM_MST_SITE_CUSTOMER, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER, TB_FX_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, NERP_CONV_MASTER, SCM_MST_CUSTOMER, SCM_MST_SITE, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO, FN_GET_SITE_CUSTOMER_INFO, FN_ZERO_LPAD, FN_GET_ITEM_NICKNAME, FN_GET_SSP_MKT_OWNER_NAME | **INSERT** SSP_ANL_SHIP_PLAN_PACK_REQ, SSP_ANL_SHIP_REQ_P_H, XIF_SCS_PACK_SHIP_PLAN_S_SN, SCM_SYS_LOG_BATCH / **UPDATE** A(별칭, 대상 테이블 **확인 필요**) / EXEC PR_SCP_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH |
| 8 | `SSP.SSP0026_SAVE_SHIP_REQ_CELL` | `SSP0026_SAVE_SHIP_REQ_CELL` | SaveData:1580 | SCM_SYS_CALENDAR_M, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, DM_PLN_SHIPMENT_REQ | **INSERT** DM_PLN_SHIPMENT_REQ, DM_PLN_SHIPMENT_REQ_H, SCM_SYS_LOG_BATCH / **UPDATE** A(**확인 필요**) / EXEC PR_SCP_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH |
| 9 | `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK` | `SSP0026_SAVE_SHIP_REQ_DETAIL_PACK` | SaveData_Detail:1783 | SCM_SYS_CALENDAR_M, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SSP_ANL_SHIP_REQ_P, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER, TB_FX_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, NERP_CONV_MASTER, SCM_MST_ITEM_SN, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER, SCM_MST_SSO_USER_INFO | **INSERT** SSP_ANL_SHIP_REQ_P, SSP_ANL_SHIP_REQ_P_H, XIF_SCS_PACK_SHIP_PLAN_S_SN, SCM_SYS_LOG_BATCH / **UPDATE** A(**확인 필요**) / EXEC PR_SCP_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH |
| 10 | `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_CELL` | `SSP0026_SAVE_SHIP_REQ_DETAIL_CELL` | SaveData_Detail:1860 | ⚠ **DB에 SP 없음** | ⚠ **DB에 SP 없음** |
| 11 | `SSP.SSP0026_GET_SPREAD_TITLE` | `SSP0026_GET_SPREAD_TITLE` | GetSpdTitle:3027 | SCM_MST_SHEET_COLUMNS, SCM_SYS_CALENDAR_M, STRING_SPLIT | — |
| 12 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | `DM0003_GET_BUCKET_TYPE_CODE` | GetBucketType:3044 | SCM_ADM_LOOKUP_MASTER_DETAIL | — |
| 13 | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` | `SCM0001_GET_BIZ_TYPE_BY_DIVISION` | GetBizTypebyDivision:3056 (**진입점 미연결**) | SCM_MST_PROJECT, REF:VALUE/NODES | — |
| 14 | `SSP.SSP0002_GET_BOD_VALID_CHECK` | `SSP0002_GET_BOD_VALID_CHECK` | BodValidChk_Main:3794, BodValidChk:3862 (**진입점 미연결**) | SCP_MST_BOD_N_V | — |
| 15 | `SSP.SSP0026_GET_BOD_ITEM` | `SSP0026_GET_BOD_ITEM` | FindData_BOD_Main:3930, FindData_BOD:3982, BodItemPopup.FindData:254 | SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, STRING_SPLIT | — |
| 16 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN` | `SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN` | FindData_Request_Detail_DownLoad:4309 | FN_GET_LOOKUP_VALUE, SSP_MST_SHIP_CALENDAR, SSP_ANL_SHIP_REQ_P, SCP_MST_BOD_N_V, SCM_MST_SITE, SCM_CODE_LOOKUP_VALUE, STRING_SPLIT | — |
| 17 | `SCM.SCM0001_GET_DIVISION` | `SCM0001_GET_DIVISION` | BodItemPopup.GetDivision:388, ItembyDivisionPopup.GetDivision:374 | SCM_MST_DIVISION | — |
| 18 | `SCM.SCM0001_GET_SITE_BY_DIVISION` | `SCM0001_GET_SITE_BY_DIVISION` | BodItemPopup.GetDivisionbyScmSite:402 / ItembyDivisionPopup.GetDivisionbyScmSite:388(**미연결**) | SCM_MST_SITE, REF:VALUE/NODES | — |
| 19 | `SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP` | `SSP0026_GET_ITEM_BY_DIVISION_POPUP` | ItembyDivisionPopup.FindData:242 | SCM_MST_SITE_ITEM, SCM_MST_DIVISION, SCM_MST_SITE, SCM_MST_ITEM_SN, SCM_MST_PROJECT, STRING_SPLIT | — |

SP 18종: `SSP0026_GET_SHIPMENT_REQUEST_PACK`, `SSP0026_GET_SHIPMENT_REQUEST_CELL`, `SSP0026_GET_RESULT_DETAIL`, `SSP0026_GET_REQUEST_DETAIL_PACK`, `SSP0026_GET_REQUEST_DETAIL_CELL`, `SSP0026_SAVE_SHIP_REQ_PACK`, `SSP0026_SAVE_SHIP_REQ_CELL`, `SSP0026_SAVE_SHIP_REQ_DETAIL_PACK`, `SSP0026_SAVE_SHIP_REQ_DETAIL_CELL`, `SSP0026_GET_SPREAD_TITLE`, `DM0003_GET_BUCKET_TYPE_CODE`, `SCM0001_GET_BIZ_TYPE_BY_DIVISION`, `SSP0002_GET_BOD_VALID_CHECK`, `SSP0026_GET_BOD_ITEM`, `SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN`, `SCM0001_GET_DIVISION`, `SCM0001_GET_SITE_BY_DIVISION`, `SSP0026_GET_ITEM_BY_DIVISION_POPUP`. 여기에 공통코드용 UP_FX_GetCommonDataList(`biz:CommonData.CommonDataList`)가 더해집니다.

## 6. Division·권한별 변형

### 6-1. Division
| 시트 | Division 40 | 81 / 81_HD / 81_HG / 81_HM / 81_ST / 81_UC / 82 / EE / EE_HD / EE_HG / EE_HM / EE_ST / EE_UC | 근거 |
|---|---|---|---|
| Pack Biz | 표시 컬럼 16개(메타 15 + 코드 표시), Measure 8건 | 메타 없음. 코드가 표시하는 SHIPTO_CODE와 ORDER_TYPE_DETAIL 2컬럼만 남습니다. 실제 화면은 **확인 필요**입니다. | grid_effective, Fact Pack §10·§12 |
| Cell Biz | 13컬럼, Measure 10건 | 메타 없음 | 같음 |
| Shipment Request Detail / Shipment Result Detail / Shipment Request Detail Excel | 35 / 12 / 10 | 35 / 12 / 10 (Division 40과 같음) | 같음 |
| Project(팝업) | 14 (하드코딩) | 14 | grid_code InitSpread 189~210 |

- Division 콤보 값은 `biz:CommonData.CommonDataList`[MyDivision]로 가져옵니다(SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION). 사용자 권한에 따른 Division 목록으로 보이며, 판정 기준은 **확인 필요**입니다.
- 화면 코드에서 Division 값을 직접 비교하는 분기는 정적으로 발견되지 않았습니다(Fact Pack §12 "분기 조건 판단불가 적용 0건"). Division별 차이는 메타 행에서만 나옵니다.

### 6-2. 권한
| 사실 | 근거 |
|---|---|
| TB_FX_GroupMenuAuth에 SSP0026 행 12건이 있습니다. C/R/U/D 값은 **확인 필요**입니다. | DB 메타 |
| Cell Biz 시트 노출 조건은 `drPgmAuthId != null`이며, LookupCommon(SCM_ADM_LOOKUP_MASTER_DETAIL 7행) 값에 달려 있습니다. 권한 그룹과의 관계는 **확인 필요**입니다. | CreateSpread:340 |
| 다음 메서드가 `UserInfoContext.Current["NowGroupID"]`를 읽습니다: cboDivision_SelectedIndexChanged, clbCustomer_SelectedIndexChanged, clbTeam_SelectedIndexChanged, clbDivision_SelectedIndexChanged, InitControls, InsertRow, SpdMain_ActiveSheetChanged, spdMain_ComboSelChange | Fact Pack §4 |
| FROM_SITE와 TO_SITE 콤보는 사용자 기준으로 필터링됩니다(UserPlantSiteByDivisionOspPack, UserSiteByEndCustomerAuth). 내부 SP는 **확인 필요**입니다. | InsertRow:1965·1966·2049·2050 |

## 7. 외부 인터페이스 (사실에 있는 것만)

| 객체 | 동작 | 엔드포인트 | 비고 |
|---|---|---|---|
| XIF_SCS_PACK_SHIP_PLAN_S_SN | INSERT | `SSP.SSP0026_SAVE_SHIP_REQ_PACK`, `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK` | XIF_ 접두 테이블입니다. 이 테이블을 받아 가는 시스템과 전송 방식은 **확인 필요**입니다. |
| NERP_CONV_MASTER | SELECT | 저장 SP 2종(PACK, DETAIL_PACK) | 용도는 **확인 필요**입니다. |
| SCM_DNM_SCS_SHIP_RESULT, SCM_DNM_SCS_PROD_PLAN, SCM_DNM_SCS_STOCK | SELECT | `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` | 출처 시스템은 **확인 필요**입니다. |

## 8. 미확정·확인 필요

1. `SSP0026_GET_REQUEST_DETAIL_CELL`과 `SSP0026_SAVE_SHIP_REQ_DETAIL_CELL`은 FoxQuery에서는 MATCH이지만 **DB에 SP가 없습니다**. Cell 상세 조회와 저장이 실제로 동작하는지 확인해야 합니다.
2. `SSP0026_GET_REQUEST_DETAIL_PACK`과 `SSP0026_GET_RESULT_DETAIL`은 동적 SQL이라 대상 테이블을 정적으로 알 수 없습니다. SP 원문을 확인해야 합니다.
3. 저장 SP에 있는 `UPDATE:A`의 실제 대상 테이블을 확인해야 합니다.
4. SaveButton에서 SaveData(메인)와 SaveData_Detail(상세) 중 무엇을 실행하는지 정하는 조건을 확인해야 합니다. 상세 PACK과 CELL의 분기 조건도 확인해야 합니다.
5. 진입점이 연결되지 않은 호출이 현행에서 정말 쓰이지 않는지 확인해야 합니다: GetBizTypebyDivision(`SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION`), BodValidChk_Main·BodValidChk(`SSP.SSP0002_GET_BOD_VALID_CHECK`), 소문자 spdMain_ComboSelChange(MktFcstEditMeasure), spdMain_Changed(DefaultBucketDay), ItembyDivisionPopup.GetDivisionbyScmSite.
6. Fact Pack §4-2에 SaveButton:739 → PersonalSettingPopup.SaveData 매핑이 있습니다. 화면 자체 SaveData와 이름이 겹친 것인지 확인해야 합니다.
7. 콤보 데이터 소스 `Data.UserPlantSiteByDivisionOspPack`, `Data_SCP.Common(ShipmentRequestPlantSite, …)`, `Data.UserSiteByEndCustomer(Auth)`가 호출하는 SP를 확인해야 합니다.
8. 업로드 파일을 파싱하고 검증하는 로직을 확인해야 합니다(MSG00265 외).
9. 메뉴 위치와 업무 목적 문구를 확인해야 합니다.
10. SCM_MST_SHEET_MEASURE는 19행인데 유효 전개는 18건(10+8)입니다. 차이 1건이 무엇인지 확인해야 합니다.
11. 주석 처리된 Division 조회 호출 2건(팝업 389·375줄)은 현행 기능에서 뺐습니다.

=== FILE: screen_design.md ===
# SSP0026 Shipment Request Pack — 화면설계서

> 근거: Fact Pack(controls.csv · props.csv · events.csv · flow.csv · grid_effective)과 1차 분석서. props.csv가 잘려 있어 확인하지 못한 속성은 **확인 필요**로 적었습니다.
> §5 액션 명세의 엔드포인트 이름은 업무분석서 §5와 같습니다. §3의 컨트롤명은 단위테스트 절차 열에서 그대로 씁니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0026 |
| 화면 명칭 | Shipment Request Pack (클래스 `SSP0026_ShipmentRequestPack`) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행. 값은 Fact Pack에 없음) |
| 프로젝트 | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0026_ShipmentRequestPack.UIL\SSP0026_ShipmentRequestPack.UIL.csproj` |
| 공용 팝업 | `SSP0026_BodItemPopup`, `SSP0026_ItembyDivisionPopup` (`06.UIL\GSCM.SSP.Plan.UIL\Popup\`) |
| Grid 구성 | HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경) |
| 시트 | `Pack Biz`, `Cell Biz`, `Shipment Request Detail`, `Shipment Result Detail`, `Shipment Request Detail Excel`, `Project`, `Shipment Request Detail_BACKUP`(코드 미참조) |

## 2. 화면 레이아웃

### 2-1. 분할 트리 (controls.csv parent 체인 + props.csv)

```
SSP0026_ShipmentRequestPack (this)
├─ usrConditionPanel1   [Dock=Top · Size=1284×94 · UsrPanelType=HidePanel]  ← 조회조건 (접기 가능)
│   └─ usrLayoutControl2 [Dock=Fill · Size=1284×94]
│        ├─ cboDivision · clbPlantSite · clbSalesSite · clbCustomer · clbTeam
│        ├─ txtItemId + btnItemId · txtProject + btnProject
│        ├─ cboBucketType · drpPeriod · btnMeasure · chkSum · chkPastPeriod(Visible=false)
│        └─ formDown(Excel Form) · btnExcelUpload(Upload) · btnColumn(Visible=false)
└─ splitContainer1      [Dock=Fill · Orientation=Horizontal → 상/하 분할 · SplitterDistance=확인 필요]
    ├─ Panel1 (상)  ── spdMain (spdMain_Sheet1)            ← 메인 그리드: 시트 Pack Biz / Cell Biz
    └─ Panel2 (하)
         ├─ usrLayoutControl3                              ← 상세 조회조건
         │    drpPeriod2 · txtRequestor + btnRequestor · txtItemld2 + btnItemID2 · txtLotID · textNickName2 · btnSearch
         ├─ spdDetail (spdDetail_Sheet1)                   ← 상세 그리드: Shipment Request Detail / Shipment Result Detail
         └─ spdSub (spdSub_Sheet1)                         ← Excel 양식 그리드: Shipment Request Detail Excel (화면 표시 여부 확인 필요)

(부모 미기재) usrLayoutControl1 [Dock=Fill · Size=657×184] / layoutControlGroup1 [657×184]
   → controls.csv parent 값이 비어 있어 배치 위치를 알 수 없음. 확인 필요
```

| 영역 | 비율 | 근거 |
|---|---|---|
| 조회조건 : 그리드 영역 (세로) | 조회조건은 고정 높이 94px. 폼 전체 높이를 알 수 없어 %는 **확인 필요** | usrConditionPanel1 Size |
| splitContainer1 상(Panel1) : 하(Panel2) | **확인 필요** (SplitterDistance가 props.csv 절단 구간에 있음) | Orientation=Horizontal |
| Panel2 안의 usrLayoutControl3, spdDetail, spdSub 배치(Dock) | **확인 필요** | props.csv 절단 |

### 2-2. 팝업 레이아웃

```
SSP0026_BodItemPopup (this)
├─ usrConditionPanel1
│   └─ usrLayoutControl2: clbDivision(lblDivision) · clbFromSite(lblFromSite) · clbToSite(lblToSite)
│                         · txtItemID(lblItemID) · txtToSite(lbl_ToSiteText) · btnButtonList
└─ spdMain (spdMain_Sheet1)   ← 시트 Project(하드코딩 InitSpread 204~210, 소속 파일 확인 필요)

SSP0026_ItembyDivisionPopup (this)
├─ usrConditionPanel1
│   └─ usrLayoutControl2: clbDivision · clbScmSite · txtItemID · txtProject · btnButtonList
└─ spdMain (spdMain_Sheet1)   ← 시트 Project(하드코딩 InitSpread 189~199, 소속 파일 확인 필요)
```
팝업 컨트롤의 Dock과 Size는 **확인 필요**입니다(props.csv 절단).

## 3. 컨트롤 명세

라벨은 props.csv의 Text 원문(LayoutControlItem 포함)입니다. 원문을 확인하지 못한 것은 '확인 필요'로 적었습니다. 필수 여부를 표시한 원문은 없으므로 모두 **확인 필요**입니다.

### 3-1. 메인 화면

| 컨트롤명 | 타입 | 라벨(원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrLayoutControl1 | UsrLayoutControl | — | Dock=Fill, 657×184 | — | — | 레이아웃 컨테이너 (사용처 확인 필요) |
| usrConditionPanel1 | UsrConditionPanel | — | Dock=Top, 1284×94, HidePanel | — | — | 공통 조회조건 패널(접기) |
| usrLayoutControl2 | UsrLayoutControl | — | Dock=Fill, 1284×94 | — | — | 조회조건 레이아웃 |
| cboDivision | UsrCombo | Division (LCI `clbDivision`) | MyDivision 목록. 기본 선택값 **확인 필요** | 확인 필요 | cboDivision_SelectedIndexChanged | 단일선택 ComboBox |
| clbPlantSite | UsrCheckedList | Plant Site (lblPlantSite) | 확인 필요 | 확인 필요 | — | MultiSelect |
| clbSalesSite | UsrCheckedList | Sales Site (lblSalesSite) | 확인 필요 | 확인 필요 | — | MultiSelect |
| clbCustomer | UsrCheckedList | End Customer (lblCustomer) | 확인 필요 | 확인 필요 | clbCustomer_SelectedIndexChanged | MultiSelect |
| clbTeam | UsrCheckedList | Team (lblTeam) | 확인 필요 | 확인 필요 | clbTeam_SelectedIndexChanged | MultiSelect |
| txtItemId | UsrMultiLineEditor | Model (lblModel) | 확인 필요 | 확인 필요 | — | 다중 입력 텍스트 |
| btnItemId | UsrButton | 확인 필요 | — | — | BtnItemID_Click | 팝업 아이콘 버튼 |
| txtProject | UsrMultiLineEditor | Project (lblProject) | 확인 필요 | 확인 필요 | — | 다중 입력 텍스트 |
| btnProject | UsrButton | 확인 필요 | — | — | btnProject_Click | 팝업 아이콘 버튼 |
| cboBucketType | UsrCombo | Bucket (lblBucket) | `DM.DM0003_GET_BUCKET_TYPE_CODE` 목록(DAILY/WEEKLY/MONTHLY). 기본값 **확인 필요** | 확인 필요 | cboBucketType_SelectedIndexChanged | ComboBox |
| drpPeriod | UsrDateRangePicker | 확인 필요 (LCI `Period`) | 확인 필요 (InitControls가 FROM_DATE, TO_DATE, FIRST_DATE, CONFIRM_DAY를 읽음) | 확인 필요 | — | DateRange |
| btnMeasure | UsrButton | 확인 필요 | — | — | btnMeasure_Click | 버튼 |
| chkSum | UsrCheckBox | Sum | 확인 필요 | — | chkSum_CheckedChanged | CheckBox |
| chkPastPeriod | UsrCheckBox | Including Past Period | Checked=true, **Visible=false** | — | chkPastPeriod_CheckedChanged | CheckBox(숨김) |
| btnColumn | UsrButton | 확인 필요 | **Visible=false** | — | btnColumn_Click | (비노출) |
| formDown | UsrButton | Excel Form | — | — | btnExcelFormDownload_Click | 버튼 |
| btnExcelUpload | UsrButton | Upload | — | — | btnExcelUpload_Click | 버튼(파일 업로드) |
| spdMain | FpSpread | — | 시트 Pack Biz(+Cell Biz) | — | SpdMain_TopChange, SpdMain_CellDoubleClick, SpdMain_ComboSelChange, SpdMain_ClipboardPasted, SpdMain_ActiveSheetChanged | Wijmo FlexGrid + 시트 탭 |
| spdMain_Sheet1 | SheetView | — | Designer 기본 시트 | — | — | (FlexGrid 시트) |
| usrLayoutControl3 | UsrLayoutControl | — | Panel2 | — | — | 상세 조회조건 레이아웃 |
| drpPeriod2 | UsrDateRangePicker | 확인 필요 | 확인 필요 | 확인 필요 | — | DateRange |
| txtRequestor | UsrMultiLineEditor | 확인 필요 | 확인 필요 | 확인 필요 | — | 다중 입력 텍스트 |
| btnRequestor | UsrButton | 확인 필요 | — | — | BtnRequestor_Click | 팝업 아이콘 버튼 |
| txtItemld2 | UsrMultiLineEditor | 확인 필요 | 확인 필요 | 확인 필요 | — | 다중 입력 텍스트 |
| btnItemID2 | UsrButton | 확인 필요 | — | — | BtnItemID2_Click | 팝업 아이콘 버튼 |
| txtLotID | UsrMultiLineEditor | 확인 필요 | 확인 필요 | 확인 필요 | — | 다중 입력 텍스트 |
| textNickName2 | TextBox | 확인 필요 | 확인 필요 | 확인 필요 | — | Input |
| btnSearch | SimpleButton | 확인 필요 | — | — | BtnSearch_Click | 버튼(상세 조회) |
| spdDetail | FpSpread | — | 시트 Shipment Request Detail / Shipment Result Detail | — | SpdDetail_TopChange, SpdDetail_ComboSelChange, SpdDetail_CellDoubleClick, SpdDetail_ClipboardPasted, SpdDetail_ActiveSheetChanged | Wijmo FlexGrid + 시트 탭 |
| spdDetail_Sheet1 | SheetView | — | Designer 기본 시트 | — | — | (FlexGrid 시트) |
| spdSub | FpSpread | — | 시트 Shipment Request Detail Excel | — | — | 화면 비표시 양식 정의(표시 여부 확인 필요) |
| spdSub_Sheet1 | SheetView | — | Designer 기본 시트 | — | — | — |

### 3-2. 공용 팝업

| 컨트롤명 | 타입 | 팝업 | 라벨(원문) | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|
| clbDivision | UsrCheckedList | BodItemPopup, ItembyDivisionPopup | lblDivision (Text 확인 필요) | clbDivision_SelectedIndexChanged | MultiSelect |
| clbFromSite | UsrCheckedList | BodItemPopup | lblFromSite (Text 확인 필요) | — | MultiSelect |
| clbToSite | UsrCheckedList | BodItemPopup | lblToSite (Text 확인 필요) | — | MultiSelect |
| txtToSite | UsrMultiLineEditor | BodItemPopup | lbl_ToSiteText (Text 확인 필요) | — | 텍스트 |
| txtItemID | UsrMultiLineEditor | BodItemPopup, ItembyDivisionPopup | lblItemID (Text 확인 필요) | — | 다중 입력 텍스트 |
| clbScmSite | UsrCheckedList | ItembyDivisionPopup | 확인 필요 | — | MultiSelect |
| btnButtonList | UsrButtonList | BodItemPopup, ItembyDivisionPopup | — | btnButtonList_UsrButtonList_Click_Detected | 팝업 버튼바(조회/선택 등, 구성 확인 필요) |
| spdMain (팝업) | FpSpread | 두 팝업 | — | spdMain_CellDoubleClick, (Form_Load) | Wijmo FlexGrid |
| txtProject (팝업) | UsrMultiLineEditor | ItembyDivisionPopup | 확인 필요 | — | 텍스트 |

> 메인 화면의 `clbDivision`은 컨트롤이 아니라 LayoutControlItem(cboDivision의 라벨)입니다. 팝업의 `clbDivision`은 UsrCheckedList입니다.

## 4. 그리드 명세

공통: 출처 META = SCM_MST_SHEET_COLUMNS(SetSheetHeaderColumn / CreateSheetHeaderColumn), HARDCODED = AddTextColumn. 셀 타입은 메타의 CELL_CONTROL_OBJECT_TYPE_CODE / CELL_COMBO_DATA_TYPE 값으로 정해지는데, 그 값이 Fact Pack에 없어 **확인 필요**입니다. 편집 가능 여부도 같은 이유로 **확인 필요**이며, 콤보 이벤트 근거가 있는 컬럼만 '콤보 편집'으로 적었습니다.
표기: 필수 = USER_SELECTABLE_FLAG='N', 기본 = DEFAULT_FLAG='Y', →표시/→숨김 = 코드에서 변경.

### 4-1. `Pack Biz` (spdMain, 3행 헤더, CreateSheetHeaderColumn@InitSpread:413)

| 컬럼 | 헤더 | 출처 | Div 40 | 그 외 Division | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Division* | META | 필수 | — | 확인 필요 |
| END_CUSTOMER | End Customer | META | 필수 | — | 확인 필요 |
| TEAM_NAME_KO | Team | META | 필수 | — | 확인 필요 |
| LAST_UPDATED_BY | Requestor | META | 필수 | — | 확인 필요 |
| REMARK | Customer Requirement | META | 필수 | — | 확인 필요 |
| CONFIRM_DAY | CONFIRM_DAY | META | 기본 | — | 확인 필요 |
| FROM_SITE | From ( Plant )* | META | 기본 | — | 콤보(InsertRow 사용자 기준 필터) |
| SITE_DESCRIPTION | Plant site | META | 기본 | — | 확인 필요 |
| TO_SITE | To ( Sales-Site )* | META | 기본 | — | 콤보(InsertRow) |
| INCOTERMS | Incoterms* | META | 기본 | — | 확인 필요 |
| TR_MODE | Trans Mode* | META | 기본 | — | TransMode 반영(FindData_BOD_Main) |
| MODEL_ID | Model* | META | 기본 | — | 확인 필요 |
| NICK_NAME | Nick Name | META | 기본 | — | 확인 필요 |
| MEASURE | Measure* | META | 기본 | — | 확인 필요 |
| FCST_TYPE | FCST Type* | META | 기본 → **숨김**(3595) | →숨김 | — |
| SHIPTO_CODE | (메타 라벨 없음) | 코드 표시 | →표시(3592·3593) | →표시 | 확인 필요 |
| ORDER_TYPE_DETAIL | (메타 라벨 없음) | 코드 표시 | →표시(3594) | →표시 | 확인 필요 |
| BOD_ID / MEASURE_COLOR / PROJECT_CODE / SHIP_FROZEN | BOD ID* / MEASUR_COLOR / Project Code* / DMF0045 | META | 숨김 | — | — |
| D_* / W_* / M_* / SUM | GET_SPREAD_TITLE 결과(날짜) | 동적(SP) | Bucket·chkSum·chkPastPeriod 규칙 | 같음 | 확인 필요 |

최종 표시 컬럼 수: 40 = 16, 그 외 = 2. 그 외 Division의 실제 화면은 **확인 필요**입니다. Measure는 8건(Div 40)입니다.

### 4-2. `Cell Biz` (spdMain, 3행 헤더, `drPgmAuthId != null`일 때만 생성)

| 컬럼 | 헤더 | 출처 | Div 40 | 그 외 |
|---|---|---|---|---|
| DIVISION_ID | Division* | META | 필수 | 메타 없음 |
| END_CUSTOMER | End Customer | META | 필수 | 〃 |
| TEAM_NAME_KO | Team | META | 필수 | 〃 |
| LAST_UPDATED_BY | Requestor | META | 필수 | 〃 |
| REMARK | Customer Requirement | META | 필수 | 〃 |
| FCST_TYPE | FCST Type* | META | 기본 | 〃 |
| FROM_SITE | Frorm ( Plant )* | META | 기본 | 〃 |
| TO_SITE | To ( Sales-Site )* | META | 기본 | 〃 |
| INCOTERMS | Incoterms* | META | 기본 | 〃 |
| TR_MODE | Trans Mode* | META | 기본 | 〃 |
| MODEL_ID | Model* | META | 기본 | 〃 |
| NICK_NAME | Nick Name | META | 기본 | 〃 |
| MEASURE | Measure* | META | 기본 | 〃 |
| BOD_ID / MEASURE_COLOR / SHIP_FROZEN / SITE_DESCRIPTION | BOD ID* / MEASUR_COLOR / Confirm day / Plant site | META | 숨김 | 〃 |
| D_* / W_* / M_* / SUM | GET_SPREAD_TITLE 결과 | 동적 | 버킷 규칙 | — |

합계: 40 = 13, Measure 10건. 편집 가능 여부는 **확인 필요**입니다.

### 4-3. `Shipment Request Detail` (spdDetail, SetSheetHeaderColumn@InitSpread:386, MergePolicy.None) — 모든 Division 35컬럼, 출처 META

| 컬럼 | 헤더 | 컬럼 | 헤더 |
|---|---|---|---|
| DIVISION_ID | Div* | MODEL_ID | Model* |
| FROM_SITE | From Site* | NICK_NAME | Nick Name |
| SITE_DESCRIPTION | Plant Site | QTY | Qty* |
| TO_SITE | To Site* (콤보, 변경 시 SHIPTO_CODE 재설정) | YYYYMMDD | Shipment Date* |
| SHIPTO_CODE | Ship to* (콤보, ShipToCodeByDivision) | EXPECTED_SHIP_DATE | Expected Shipping Date |
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

컬럼 순서(SORT_ORDER_NO)와 다른 컬럼의 편집 여부는 **확인 필요**입니다.

### 4-4. `Shipment Result Detail` (spdDetail, InitSpread:398) — 모든 Division 12컬럼, 출처 META

DIVISION_ID(Division*), FROM_SITE(From ( Plant )*), SITE_DESCRIPTION(Plant site), TO_SITE(To ( Sales-Site )*), SHIP_TO(Ship to), SHIPTO_DESCRIPTION(Ship to Name), MODEL_ID(Model*), QTY(Qty*), YYYYMMDD(Shipment Date), LAST_UPDATED_BY(Last Updated by), LAST_UPDATED_DATE(Last Update Date), TEMP(TEMP). 숨김: SCM_SITE_ID. 조회 전용 여부는 **확인 필요**입니다.

### 4-5. `Shipment Request Detail Excel` (spdSub, InitSpread:407) — 모든 Division 10컬럼, 출처 META

DIVISION_ID(Div*), FROM_SITE(FromSite*), TO_SITE(ToSite*), SHIPTO_CODE(ShipTo*), ITEM_ID(Model*), QTY(Qty*), YYYYMMDD(yyyyMMdd*), INCOTERMS(Incoterms*), TRANSPORT_MODE(Trans Mode*), FCST_TYPE(FCST Type*). Excel Form과 Upload의 양식 기준입니다. SCM_ADM_EXCEL_COLUMNS 2행과의 관계는 **확인 필요**입니다.

### 4-6. `Project` (팝업 spdMain, HARDCODED AddTextColumn, 메타 없음) — 14컬럼

| 줄 | 헤더 | 필드 | 줄 | 헤더 | 필드 |
|---:|---|---|---:|---|---|
| 189/204 | Division | DIVISION_ID | 196 | Model | ITEM_NAME |
| 190/205 | Division | DIVISION_NAME | 197 | Type | ITEM_TYPE |
| 191 | Project Code | PROJECT_CODE | 198 | Nick Name | NICK_NAME |
| 192 | Project | PROJECT_NAME | 199 | Class Name | ITEM_CLASS_NAME |
| 193 | SCM Site | SCM_SITE_ID | 208 | Incoterms | INCOTERMS |
| 194 | Site | SITE_DESCRIPTION | 209 | Transport Mode | TRANSPORT_MODE |
| 195/207 | Model Code / Material | ITEM_ID | 210 | BOD ID | BOD_ID |

189~199줄과 204~210줄은 서로 다른 팝업 그리드 정의입니다. 각각 어느 팝업 파일에 속하는지는 **확인 필요**입니다. 편집 여부는 확인되지 않았고, 선택은 spdMain_CellDoubleClick으로 합니다.

### 4-7. `Shipment Request Detail_BACKUP` — 메타 정의만 있고 코드 미참조, 19컬럼

BOD_ID, DIVISION_ID, EDIT_FLAG, FCST_TYPE, FROM_SITE, INCOTERMS, LAST_UPDATED_BY, LAST_UPDATED_DATE, MODEL_ID, NICK_NAME, ORDER_TYPE_DETAIL, QTY, REMARK, SHIPTO_CODE, SHIPTO_NAME, SITE_DESCRIPTION, TO_SITE, TR_MODE, YYYYMMDD (숨김 FCST_TYPE2). 화면에 생성되지 않으며, TO-BE에서 구현하지 않는 후보입니다.

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A01 | 화면 Load | `Form_Load` | InitControls, GetBucketType, CreateSpread > InitSpread > GetSpdTitle | `biz:CommonData.CommonDataList`[MyDivision, Measure], `DM.DM0003_GET_BUCKET_TYPE_CODE`, `SSP.SSP0026_GET_SPREAD_TITLE` | cboDivision, cboBucketType, 시트 생성 |
| A02 | 조회(FindButton) | FindButton(프레임워크) | FindData | `biz:CommonData.CommonDataList`[Measure], `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` / `SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL`, `SSP.SSP0026_GET_SPREAD_TITLE` | spdMain(Pack Biz / Cell Biz) |
| A03 | 저장(SaveButton) 메인 | SaveButton(프레임워크) | SaveData → FindData | `SSP.SSP0026_SAVE_SHIP_REQ_PACK` / `SSP.SSP0026_SAVE_SHIP_REQ_CELL` → 재조회(A02) | spdMain 재조회 |
| A04 | 저장(SaveButton) 상세 | SaveButton(프레임워크) | SaveData_Detail → FindData_Detail | `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK` / `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_CELL`(⚠ DB 없음) → `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` | spdDetail 재조회 |
| A05 | btnSearch Click | `BtnSearch_Click` | 상세 시트 0 → FindData_Detail, 1 → FindData_Result_Detail | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` / `SSP.SSP0026_GET_RESULT_DETAIL` + `SSP.SSP0026_GET_SPREAD_TITLE` | spdDetail |
| A06 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | FindData_Detail_DblClick | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / `SSP.SSP0026_GET_REQUEST_DETAIL_CELL`, `SSP.SSP0026_GET_SPREAD_TITLE` | spdDetail(Shipment Request Detail) |
| A07 | formDown Click | `btnExcelFormDownload_Click` | FindData_Request_Detail_DownLoad | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN` | Excel 양식 파일(spdSub 기준) |
| A08 | btnExcelUpload Click | `btnExcelUpload_Click` | MSG00265 확인 → FindData, FindData_Detail | `biz:CommonData.CommonDataList`[Measure], `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` / `_CELL`, `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / `_CELL`, `SSP.SSP0026_GET_SPREAD_TITLE` | spdMain, spdDetail |
| A09 | btnMeasure Click | `btnMeasure_Click` | InitSpread | `SSP.SSP0026_GET_SPREAD_TITLE` | spdMain 헤더 재구성 |
| A10 | btnColumn Click (Visible=false) | `btnColumn_Click` | InitSpread | `SSP.SSP0026_GET_SPREAD_TITLE` | 헤더 재구성 |
| A11 | cboDivision 변경 | `cboDivision_SelectedIndexChanged` | InitSpread (NowGroupID 사용) | `SSP.SSP0026_GET_SPREAD_TITLE` | 헤더 재구성 |
| A12 | chkSum 변경 | `chkSum_CheckedChanged` | SetSpreadColumn(2893) | 없음 | M_/W_ 컬럼 표시 전환 |
| A13 | cboBucketType 변경 | `cboBucketType_SelectedIndexChanged` | SetSpreadColumn(2124) | 없음 | D_/W_/M_ 표시 전환 |
| A14 | chkPastPeriod 변경 | `chkPastPeriod_CheckedChanged` | SetSpreadColumn(3776) | 없음 | 과거 날짜 컬럼 표시 전환 |
| A15 | btnProject Click | `btnProject_Click` | 확인 필요(팝업 연결 미확인) | 확인 필요 | txtProject (추정 금지, 확인 필요) |
| A16 | btnItemId Click | `BtnItemID_Click` | 확인 필요 | 확인 필요 | 확인 필요 |
| A17 | btnItemID2 Click | `BtnItemID2_Click` | 확인 필요 | 확인 필요 | 확인 필요 |
| A18 | btnRequestor Click | `BtnRequestor_Click` | 확인 필요 | 확인 필요 | 확인 필요 |
| A19 | clbCustomer 변경 | `clbCustomer_SelectedIndexChanged` | NowGroupID 사용. 내부 동작 확인 필요 | 확인 필요 | 확인 필요 |
| A20 | clbTeam 변경 | `clbTeam_SelectedIndexChanged` | NowGroupID 사용. 내부 동작 확인 필요 | 확인 필요 | 확인 필요 |
| A21 | spdMain 스크롤 | `SpdMain_TopChange` | 확인 필요(spdDetail 동기화 여부 미확인) | 없음 | 확인 필요 |
| A22 | spdDetail 스크롤 | `SpdDetail_TopChange` | 확인 필요 | 없음 | 확인 필요 |
| A23 | spdMain 콤보 선택 | `SpdMain_ComboSelChange` | FindData_BOD_Main | `SSP.SSP0026_GET_BOD_ITEM`, `biz:CommonData.CommonDataList`[TransMode] | spdMain 행 |
| A24 | spdMain 붙여넣기 | `SpdMain_ClipboardPasted` | FindData_BOD_Main | `SSP.SSP0026_GET_BOD_ITEM`, `biz:CommonData.CommonDataList`[TransMode] | spdMain 행 |
| A25 | spdDetail 콤보 선택 | `SpdDetail_ComboSelChange` | ShipTo 콤보 재설정 → FindData_BOD | `biz:CommonData.CommonDataList`[ShipToCodeByDivision], `SSP.SSP0026_GET_BOD_ITEM`, [TransMode] | spdDetail 행 |
| A26 | spdDetail 붙여넣기 | `SpdDetail_ClipboardPasted` | IsLock 확인(3466) → ShipTo → FindData_BOD | `biz:CommonData.CommonDataList`[ShipToCodeByDivision], `SSP.SSP0026_GET_BOD_ITEM`, [TransMode] | spdDetail 행 |
| A27 | spdDetail 더블클릭 | `SpdDetail_CellDoubleClick` | 확인 필요 | 없음 | 확인 필요 |
| A28 | spdDetail 시트 전환 | `SpdDetail_ActiveSheetChanged` | 확인 필요 | 없음 | 확인 필요 |
| A29 | spdMain 시트 전환 | `SpdMain_ActiveSheetChanged` | Pack Biz: SHIPTO_CODE·ORDER_TYPE_DETAIL 표시, FCST_TYPE 숨김, Result Detail 시트 AddSheet(3604) / Cell Biz: ChangeSheet(3629) / InitSpread | `SSP.SSP0026_GET_SPREAD_TITLE` | spdMain, spdDetail 시트 |
| P01 | BodItemPopup Load | `Form_Load` (팝업) | FindData, InitControls > GetDivision, GetDivisionbyScmSite | `SSP.SSP0026_GET_BOD_ITEM`, `SCM.SCM0001_GET_DIVISION`, `SCM.SCM0001_GET_SITE_BY_DIVISION` | 팝업 spdMain, clbDivision, clbFromSite/clbToSite(확인 필요) |
| P02 | ItembyDivisionPopup Load | `Form_Load` (팝업) | FindData, InitControls > GetDivision | `SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP`, `SCM.SCM0001_GET_DIVISION` | 팝업 spdMain(Project), clbDivision |
| P03 | 팝업 버튼바 | `btnButtonList_UsrButtonList_Click_Detected` | FindData | BodItemPopup: `SSP.SSP0026_GET_BOD_ITEM` / ItembyDivisionPopup: `SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP` | 팝업 spdMain |
| P04 | 팝업 Division 변경 | `clbDivision_SelectedIndexChanged` | NowGroupID 사용. 하위 콤보 갱신 여부 확인 필요 | 확인 필요 | 확인 필요 |
| P05 | 팝업 그리드 더블클릭 | `spdMain_CellDoubleClick` | 선택 행 반환(구체 동작 확인 필요) | 없음 | 호출 화면 |
| X01 | (진입점 미연결) | GetBizTypebyDivision | 호출처 없음 | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` | — |
| X02 | (진입점 미연결) | BodValidChk_Main / BodValidChk | 호출처 없음 | `SSP.SSP0002_GET_BOD_VALID_CHECK` | — |
| X03 | (진입점 미연결) | ItembyDivisionPopup.GetDivisionbyScmSite | 호출처 없음 | `SCM.SCM0001_GET_SITE_BY_DIVISION` | — |

## 6. 검증·메시지

| 구분 | 내용 | 근거 |
|---|---|---|
| 업로드 확인 | MSG00265 (문구 원문은 **확인 필요**) | btnExcelUpload_Click |
| 편집 잠금 | IsLock 검사, bEdit_Mode_Detail 플래그 | SpdDetail_ClipboardPasted:3466, InsertRow:2049, EditButton:675·714 |
| Frozen/확정일 | SHIP_FROZEN, CONFIRM_DAY에 따른 셀 처리 (구체 동작 **확인 필요**) | Re_Design:4076·4088, ShowCell:4236 |
| 필수 표시 | 헤더 라벨의 `*`. 저장 전에 필수값을 검사하는 코드와 메시지는 **확인 필요** | SCM_MST_SHEET_COLUMNS |
| BOD 유효성 | `SSP.SSP0002_GET_BOD_VALID_CHECK`는 진입점이 미연결이라 현행 검증으로 보지 않습니다 | flow.csv |
| 그 밖의 메시지 코드 | Fact Pack에 없음 | **확인 필요** |

## 7. 권한 (C/R/U/D) 사실

| 항목 | 사실 |
|---|---|
| C/R/U/D 값 | TB_FX_GroupMenuAuth 12행이 있으나 값은 Fact Pack에 없음 → **확인 필요** |
| R (조회) | Division 목록이 MyDivision(TB_FX_USERGROUPAUTHEXTENTION)으로 제한됩니다 |
| 시트 노출 | Cell Biz는 `drPgmAuthId != null`일 때만 생성됩니다(LookupCommon) |
| C/U (행 입력) | InsertRow의 FROM_SITE/TO_SITE 콤보가 NowGroupID와 UserId 기준으로 필터링됩니다 |
| D (삭제) | 삭제 버튼이나 처리 사실이 Fact Pack에 없습니다 → **확인 필요** |

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| 영역 | As-is | To-Be |
|---|---|---|
| 메인 그리드 | FpSpread 3행 헤더, LARGE/SMALL Span, SUM 헤더 | Wijmo FlexGrid 다단 헤더(columnGroups 또는 columnHeaders 행 병합), SUM 컬럼 |
| 시트 | spdMain 시트 2개, spdDetail 시트 2개 | 탭 + FlexGrid. 활성 탭에 따라 조회/저장 API를 고릅니다(R-S1·R-S2·R-S5) |
| 버킷 표시 | SetSpreadColumn (D_/W_/M_ 태그) | FE 컬럼 visible 계산. 서버 재호출 없음 |
| 헤더 색 | SAT 파랑 / SUN 빨강 | FlexGrid formatItem으로 헤더 셀 스타일 지정(inline style 금지, class 사용) |
| 숨김 규칙 | 컬럼명에 `B_` 포함 → 숨김 | FE 컬럼 정의 필터 |
| Request Detail | MergePolicy.None | allowMerging 없음 |
| Excel | spdSub 양식 + EXCEL_DOWN SP / Upload MSG00265 | 공통 Excel 다운로드·업로드 컴포넌트 |
| SP | MSSQL: STRING_SPLIT, #임시테이블, 동적 SQL PIVOT, SCM_ARR_SPL_CNT/VAL | Oracle 19c PKG: 문자열 분해 함수, GTT(세션 시작 시 비우기), 동적 SQL은 EXECUTE IMMEDIATE / SYS_REFCURSOR. MSSQL 키워드가 남지 않게 합니다 |
| 미존재 SP | GET_REQUEST_DETAIL_CELL, SAVE_SHIP_REQ_DETAIL_CELL | 범위 결정 전까지는 구현 **보류(확인 필요)** |
| 미연결 호출 | X01~X03 | 구현 대상에서 빼는 후보입니다(업무 확인 후 확정) |
| 메타 라벨 오타 | Frorm, MEASUR_COLOR, Confrim, MKT_OWMER, MOEL_USER, "DMF0045" | 유지 여부를 결정해야 합니다(확인 필요) |

## 9. 미확정

1. SplitContainer의 SplitterDistance(상/하 비율)와 Panel2 내부 Dock 구성
2. usrLayoutControl1(부모 미기재)의 배치 위치
3. 하단 조회조건(drpPeriod2, txtRequestor, txtItemld2, txtLotID, textNickName2, btnSearch)의 라벨과 SP 파라미터 매핑
4. btnItemId, btnItemID2, btnProject, btnRequestor가 각각 여는 팝업
5. lblItemType(Item Type)에 연결된 컨트롤
6. 각 시트 컬럼의 셀 타입, 편집 가능 여부, 정렬 순서
7. 40 이외 Division에서 Pack Biz가 실제로 어떻게 보이는지
8. MSG00265와 그 밖의 메시지 원문
9. C/R/U/D 권한 값
10. Shipment Request Detail_BACKUP 시트 폐기 여부

=== FILE: unit_test.md ===
# SSP0026 Shipment Request Pack — 단위테스트

> 근거 열의 이름은 업무분석서 §5 엔드포인트, 화면설계서 §5 핸들러, §4 시트 이름 원문과 같습니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 주석 처리된 호출은 테스트 대상이 아닙니다. 기대결과 중 Fact Pack으로 확정할 수 없는 부분은 '확인 필요'로 적었습니다. 이런 항목은 AS-IS를 실행해 기대값을 확정한 뒤 판정합니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0026-001 | 초기화 | Division 권한이 있는 사용자로 로그인 | 화면을 연다 | — | cboDivision에 MyDivision 목록이 채워진다 | `Form_Load` > InitControls:231 / `biz:CommonData.CommonDataList`[MyDivision] |
| TC-SSP0026-002 | 초기화 | 001과 같음 | 화면을 연다 | — | Measure 목록을 조회한다(InitControls:306) | `Form_Load` / `biz:CommonData.CommonDataList`[Measure] |
| TC-SSP0026-003 | 초기화 | 001과 같음 | 화면을 열고 cboBucketType 목록을 확인한다 | — | DAILY, WEEKLY, MONTHLY 코드가 표시된다(값과 기본 선택은 SCM_ADM_LOOKUP_MASTER_DETAIL 기준으로 확인) | `Form_Load` > GetBucketType / `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SSP0026-004 | 초기화 | 001과 같음 | 화면을 열고 spdMain 시트 탭을 확인한다 | — | `Pack Biz` 시트가 생성되고 헤더 3행이 구성된다 | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle / `SSP.SSP0026_GET_SPREAD_TITLE` / `Pack Biz` |
| TC-SSP0026-005 | 권한 | LookupCommon 값으로 drPgmAuthId가 존재하는 사용자 | 화면을 열고 spdMain 시트 탭을 확인한다 | — | `Cell Biz` 시트가 생성된다 | CreateSpread:340 / `biz:CommonData.CommonDataList`[LookupCommon] / `Cell Biz` |
| TC-SSP0026-006 | 권한 | drPgmAuthId가 null인 사용자 | 화면을 열고 spdMain 시트 탭을 확인한다 | — | `Cell Biz` 시트가 생성되지 않는다 | CreateSpread:340 / `Cell Biz` |
| TC-SSP0026-007 | 초기화 | 001과 같음 | spdDetail 시트 탭을 확인한다 | — | `Shipment Request Detail` 시트와 `Shipment Result Detail` 시트가 있다 | CreateSpread:351/358 / `Shipment Request Detail` / `Shipment Result Detail` |
| TC-SSP0026-008 | 조회 | spdMain 활성 시트 = Pack Biz | cboDivision=40, 조회조건을 입력하고 조회(FindButton)를 누른다 | Division 40, cboBucketType=DAILY | spdMain에 Measure별 행과 날짜 컬럼이 표시된다 | FindButton > FindData:787 / `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` / `SSP.SSP0026_GET_SPREAD_TITLE` / `biz:CommonData.CommonDataList`[Measure] |
| TC-SSP0026-009 | 조회 | spdMain 활성 시트 = Cell Biz (005 조건) | 조회(FindButton)를 누른다 | Division 40 | Cell SP로 조회되어 Cell Biz에 표시된다 | FindData:848 / `SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL` / `Cell Biz` |
| TC-SSP0026-010 | 조회 | Pack Biz | 데이터가 없는 조건으로 조회한다 | clbPlantSite에 데이터 없는 Site만 선택 | 0행이 표시된다. 헤더는 유지되고 오류는 없다(안내 메시지 여부는 확인 필요) | `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` |
| TC-SSP0026-011 | 조회 | Pack Biz, SP 오류가 나도록 만든 환경 | 조회한다 | — | 오류 메시지를 표시하고 그리드는 갱신하지 않는다(메시지 원문 확인 필요) | `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` |
| TC-SSP0026-012 | 저장 | Pack Biz 조회 후 행 수정 | 저장(SaveButton)을 누른다 | 수량 셀 변경 | SSP_ANL_SHIP_PLAN_PACK_REQ, SSP_ANL_SHIP_REQ_P_H, XIF_SCS_PACK_SHIP_PLAN_S_SN, SCM_SYS_LOG_BATCH에 반영되고 재조회된다 | SaveButton > SaveData:1508 / `SSP.SSP0026_SAVE_SHIP_REQ_PACK` |
| TC-SSP0026-013 | 저장 | Cell Biz 조회 후 행 수정 | 저장(SaveButton)을 누른다 | 수량 셀 변경 | DM_PLN_SHIPMENT_REQ와 DM_PLN_SHIPMENT_REQ_H에 반영되고 재조회된다 | SaveData:1580 / `SSP.SSP0026_SAVE_SHIP_REQ_CELL` |
| TC-SSP0026-014 | 저장 | 상세 편집 모드(bEdit_Mode_Detail), Shipment Request Detail 행 수정 | 저장(SaveButton)을 누른다 | Qty, Shipment Date 변경 | SSP_ANL_SHIP_REQ_P, SSP_ANL_SHIP_REQ_P_H, XIF_SCS_PACK_SHIP_PLAN_S_SN에 반영되고 상세가 재조회된다 | SaveData_Detail:1783 / `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK` / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` |
| TC-SSP0026-015 | 저장 | Cell 상세 저장 경로 | 저장(SaveButton)을 누른다 | — | DB에 SP가 없으므로 오류 응답 처리를 확인한다(AS-IS 실행 결과 확인 필요) | SaveData_Detail:1860 / `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_CELL` |
| TC-SSP0026-016 | 저장 | 필수 컬럼(`*`)을 비운 행 | 저장(SaveButton)을 누른다 | Model* 빈값 | 검증 메시지가 나오거나 SP 오류가 난다(어느 쪽인지 확인 필요). 데이터는 반영되지 않는다 | `SSP.SSP0026_SAVE_SHIP_REQ_PACK` / `Pack Biz` |
| TC-SSP0026-017 | 이벤트 | spdDetail 활성 시트 = Shipment Request Detail (Pack) | 하단 조건을 입력하고 btnSearch를 누른다 | drpPeriod2 기간, txtItemld2 | Request Detail이 조회된다 | `BtnSearch_Click` > FindData_Detail:1071 / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / `Shipment Request Detail` |
| TC-SSP0026-018 | 이벤트 | Cell 상세 조회 경로 | btnSearch를 누른다 | — | DB에 SP가 없으므로 오류 응답 처리를 확인한다(확인 필요) | `BtnSearch_Click` > FindData_Detail:1115 / `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` |
| TC-SSP0026-019 | 이벤트 | spdDetail 활성 시트 = Shipment Result Detail | btnSearch를 누른다 | drpPeriod2 기간 | Result Detail 12컬럼으로 조회된다 | `BtnSearch_Click` > FindData_Result_Detail:969 / `SSP.SSP0026_GET_RESULT_DETAIL` / `SSP.SSP0026_GET_SPREAD_TITLE` / `Shipment Result Detail` |
| TC-SSP0026-020 | 조회 | 017과 같음 | 데이터가 없는 조건으로 btnSearch를 누른다 | 데이터 없는 txtLotID | 0행이 표시되고 오류는 없다 | `BtnSearch_Click` / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` |
| TC-SSP0026-021 | 이벤트 | Pack Biz 조회 결과 있음 | spdMain 행을 더블클릭한다 | 1행 | 해당 행 기준으로 Shipment Request Detail이 조회된다 | `SpdMain_CellDoubleClick` > FindData_Detail_DblClick:1232 / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` |
| TC-SSP0026-022 | 이벤트 | Cell Biz 조회 결과 있음 | spdMain 행을 더블클릭한다 | 1행 | Cell 상세 조회를 시도한다(SP 미존재에 따른 결과는 확인 필요) | `SpdMain_CellDoubleClick` > 1274 / `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` |
| TC-SSP0026-023 | 이벤트 | 001과 같음 | formDown(Excel Form)을 누른다 | — | Shipment Request Detail Excel 10컬럼 양식 파일을 내려받는다 | `btnExcelFormDownload_Click` / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN` / `Shipment Request Detail Excel` |
| TC-SSP0026-024 | 이벤트 | 양식에 맞게 작성한 Excel 파일 | btnExcelUpload(Upload)를 누르고 MSG00265에서 확인을 누른다 | 양식 파일 | 업로드 후 메인과 상세가 재조회된다 | `btnExcelUpload_Click` / `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / `SSP.SSP0026_GET_SPREAD_TITLE` |
| TC-SSP0026-025 | 이벤트 | 024와 같음 | btnExcelUpload를 누르고 MSG00265에서 취소를 누른다 | — | 업로드하지 않는다(확인 필요) | `btnExcelUpload_Click` |
| TC-SSP0026-026 | 이벤트 | 조회 완료 | btnMeasure를 누른다 | — | 그리드 헤더를 다시 구성한다 | `btnMeasure_Click` / `SSP.SSP0026_GET_SPREAD_TITLE` |
| TC-SSP0026-027 | 이벤트 | 001과 같음 | 화면에서 btnColumn이 보이는지 확인한다 | — | Visible=false라 화면에 노출되지 않는다. 핸들러는 배선되어 있다 | `btnColumn_Click` / `SSP.SSP0026_GET_SPREAD_TITLE` |
| TC-SSP0026-028 | division | 2개 이상 Division 권한 | cboDivision을 40에서 81로 바꾼다 | 40 → 81 | 헤더를 다시 구성한다. Pack Biz의 메타 컬럼이 사라진다(→TC-058) | `cboDivision_SelectedIndexChanged` / `SSP.SSP0026_GET_SPREAD_TITLE` |
| TC-SSP0026-029 | 이벤트 | DAILY 조회 완료 | chkSum을 체크하고 해제한다 | Checked true/false | M_·W_ 컬럼 Visible이 chkSum.Checked를 따른다 | `chkSum_CheckedChanged` > SetSpreadColumn 2914 |
| TC-SSP0026-030 | 이벤트 | 조회 완료 | cboBucketType을 DAILY로 바꾼다 | DAILY | D_·W_ 컬럼 표시, M_은 chkSum을 따른다 | `cboBucketType_SelectedIndexChanged` > 2909/2914 |
| TC-SSP0026-031 | 이벤트 | 조회 완료 | cboBucketType을 WEEKLY로 바꾼다 | WEEKLY | D_ 숨김, W_ 표시, M_은 chkSum을 따른다 | `cboBucketType_SelectedIndexChanged` > 2921/2925/2930 |
| TC-SSP0026-032 | 이벤트 | 조회 완료 | cboBucketType을 MONTHLY로 바꾼다 | MONTHLY | D_·W_ 숨김, M_ 표시 | `cboBucketType_SelectedIndexChanged` > 2937/2941 |
| TC-SSP0026-033 | 이벤트 | chkPastPeriod를 노출한 시험 환경(Designer Visible=false) | chkPastPeriod를 해제한다 | false | SUM이 아닌 과거 날짜(date > colDate) 컬럼이 숨겨진다 | `chkPastPeriod_CheckedChanged` > SetSpreadColumn 2960 |
| TC-SSP0026-034 | 이벤트 | 001과 같음 | btnProject를 누른다 | — | 동작(팝업 종류, txtProject 반영)은 확인 필요. 오류 없이 반응하는지 확인한다 | `btnProject_Click` |
| TC-SSP0026-035 | 이벤트 | 001과 같음 | btnItemId를 누른다 | — | 동작은 확인 필요(txtItemId 반영 여부) | `BtnItemID_Click` |
| TC-SSP0026-036 | 이벤트 | 001과 같음 | btnItemID2를 누른다 | — | 동작은 확인 필요(txtItemld2 반영 여부) | `BtnItemID2_Click` |
| TC-SSP0026-037 | 이벤트 | 001과 같음 | btnRequestor를 누른다 | — | 동작은 확인 필요(txtRequestor 반영 여부) | `BtnRequestor_Click` |
| TC-SSP0026-038 | 이벤트 | 001과 같음 | clbCustomer 선택을 바꾼다 | End Customer 1건 | NowGroupID를 사용하는 후속 처리가 있다. 연동되는 컨트롤은 확인 필요 | `clbCustomer_SelectedIndexChanged` |
| TC-SSP0026-039 | 이벤트 | 001과 같음 | clbTeam 선택을 바꾼다 | Team 1건 | 후속 처리는 확인 필요 | `clbTeam_SelectedIndexChanged` |
| TC-SSP0026-040 | 그리드 | 조회 결과 다건 | spdMain을 세로 스크롤한다 | — | 동작(spdDetail 동기화 여부)은 확인 필요. 오류가 없어야 한다 | `SpdMain_TopChange` |
| TC-SSP0026-041 | 그리드 | 상세 결과 다건 | spdDetail을 세로 스크롤한다 | — | 동작은 확인 필요. 오류가 없어야 한다 | `SpdDetail_TopChange` |
| TC-SSP0026-042 | 그리드 | Pack Biz 편집 가능 행 | spdMain의 콤보 셀을 선택해 바꾼다 | FROM_SITE/TO_SITE 값 | BOD Item과 Trans Mode가 재조회되어 반영된다 | `SpdMain_ComboSelChange` > FindData_BOD_Main / `SSP.SSP0026_GET_BOD_ITEM` / `biz:CommonData.CommonDataList`[TransMode] |
| TC-SSP0026-043 | 그리드 | 042와 같음 | spdMain에 여러 행을 붙여넣는다 | 3행 | 붙여넣은 행마다 BOD와 TransMode가 반영된다 | `SpdMain_ClipboardPasted` / `SSP.SSP0026_GET_BOD_ITEM` / `biz:CommonData.CommonDataList`[TransMode] |
| TC-SSP0026-044 | 그리드 | Shipment Request Detail 편집 모드 | spdDetail의 TO_SITE 콤보를 바꾼다 | TO_SITE 변경 | SHIPTO_CODE 콤보가 ShipToCodeByDivision으로 다시 채워지고 BOD와 TransMode가 재조회된다 | `SpdDetail_ComboSelChange` / `biz:CommonData.CommonDataList`[ShipToCodeByDivision] / `SSP.SSP0026_GET_BOD_ITEM` / `Shipment Request Detail` |
| TC-SSP0026-045 | 그리드 | 044와 같음, 시트 잠금 아님 | spdDetail에 붙여넣는다 | 2행 | ShipTo, BOD, TransMode가 반영된다 | `SpdDetail_ClipboardPasted` 3464/3482 / `biz:CommonData.CommonDataList`[ShipToCodeByDivision] / `SSP.SSP0026_GET_BOD_ITEM` |
| TC-SSP0026-046 | 그리드 | 시트 IsLock 상태 | spdDetail에 붙여넣는다 | 1행 | 잠금 상태에서의 처리(차단 여부)는 확인 필요 | `SpdDetail_ClipboardPasted`:3466 |
| TC-SSP0026-047 | 그리드 | 상세 결과 있음 | spdDetail 행을 더블클릭한다 | 1행 | 동작은 확인 필요 | `SpdDetail_CellDoubleClick` |
| TC-SSP0026-048 | 그리드 | 001과 같음 | spdDetail 시트를 Request에서 Result로 전환한다 | — | 동작은 확인 필요. 이후 btnSearch를 누르면 Result Detail 조회로 분기하는지 확인한다(TC-019) | `SpdDetail_ActiveSheetChanged` / `Shipment Result Detail` |
| TC-SSP0026-049 | 그리드 | Cell Biz 존재(005) | spdMain 시트를 Cell Biz에서 Pack Biz로 전환한다 | — | SHIPTO_CODE·ORDER_TYPE_DETAIL 표시, FCST_TYPE 숨김. Result Detail 시트가 없으면 추가된다 | `SpdMain_ActiveSheetChanged` 3592~3595/3604 / `SSP.SSP0026_GET_SPREAD_TITLE` / `Pack Biz` |
| TC-SSP0026-050 | 그리드 | Cell Biz 존재 | spdMain 시트를 Pack Biz에서 Cell Biz로 전환한다 | — | spdDetail은 ChangeSheet만 한다(3629) | `SpdMain_ActiveSheetChanged` / `Cell Biz` |
| TC-SSP0026-051 | 초기화 | BodItemPopup을 연다(여는 버튼은 확인 필요) | 팝업이 열리면 목록과 조건을 확인한다 | — | clbDivision 목록, Site 목록, BOD Item 목록이 표시된다 | 팝업 `Form_Load` / `SSP.SSP0026_GET_BOD_ITEM` / `SCM.SCM0001_GET_DIVISION` / `SCM.SCM0001_GET_SITE_BY_DIVISION` |
| TC-SSP0026-052 | 초기화 | ItembyDivisionPopup을 연다 | 팝업이 열리면 목록을 확인한다 | — | clbDivision 목록과 Project 시트 목록이 표시된다 | 팝업 `Form_Load` / `SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP` / `SCM.SCM0001_GET_DIVISION` / `Project` |
| TC-SSP0026-053 | 조회 | BodItemPopup | clbDivision, clbFromSite, clbToSite, txtItemID를 입력하고 btnButtonList 조회를 누른다 | Division 40 | 조건에 맞는 BOD Item이 조회된다 | `btnButtonList_UsrButtonList_Click_Detected` / `SSP.SSP0026_GET_BOD_ITEM` |
| TC-SSP0026-054 | 조회 | ItembyDivisionPopup | clbDivision, clbScmSite, txtItemID, txtProject를 입력하고 btnButtonList 조회를 누른다 | Division 40 | Item 목록이 조회된다 | `btnButtonList_UsrButtonList_Click_Detected` / `SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP` |
| TC-SSP0026-055 | 조회 | 053과 같음 | 데이터가 없는 조건으로 조회한다 | 없는 txtItemID | 0행, 오류 없음 | `SSP.SSP0026_GET_BOD_ITEM` |
| TC-SSP0026-056 | 이벤트 | 두 팝업 | clbDivision 선택을 바꾼다 | Division 변경 | NowGroupID를 사용하는 후속 처리가 있다. 하위 Site 목록 갱신 여부는 확인 필요 | `clbDivision_SelectedIndexChanged` |
| TC-SSP0026-057 | 이벤트 | 팝업 조회 결과 있음 | 팝업 spdMain 행을 더블클릭한다 | 1행 | 선택값을 호출 화면에 반환하고 팝업을 닫는다(반환 필드는 확인 필요) | `spdMain_CellDoubleClick` / `Project` |
| TC-SSP0026-058 | division | Division 81 | 조회한 뒤 Pack Biz 컬럼을 확인한다 | Division 81 | 메타 컬럼 없이 SHIPTO_CODE와 ORDER_TYPE_DETAIL 2컬럼만 남는다(실제 화면 확인 필요) | `Pack Biz` / grid_effective |
| TC-SSP0026-059 | division | Division 40 | 조회한 뒤 Pack Biz 컬럼을 확인한다 | Division 40 | 16컬럼(DIVISION_ID~MEASURE, SHIPTO_CODE, ORDER_TYPE_DETAIL)이 표시되고 FCST_TYPE은 숨겨진다. Measure 8건 | `Pack Biz` / `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` |
| TC-SSP0026-060 | division | Division 40, Cell Biz 존재 | 조회한 뒤 Cell Biz 컬럼을 확인한다 | Division 40 | 13컬럼, Measure 10건. BOD_ID, MEASURE_COLOR, SHIP_FROZEN, SITE_DESCRIPTION은 숨겨진다 | `Cell Biz` / `SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL` |
| TC-SSP0026-061 | division | Division 81, Cell Biz 존재 | Cell Biz 컬럼을 확인한다 | Division 81 | 메타가 없어 기본 컬럼이 없다(실제 화면 확인 필요) | `Cell Biz` |
| TC-SSP0026-062 | 그리드 | 상세 조회 완료 | Shipment Request Detail 컬럼을 확인한다 | 임의 Division | 35컬럼이 표시되고 MODEL_PIC, MOEL_USER는 숨겨진다. 병합하지 않는다(MergePolicy.None) | `Shipment Request Detail` / InitSpread:386/392 |
| TC-SSP0026-063 | 그리드 | Result 조회 완료 | Shipment Result Detail 컬럼을 확인한다 | — | 12컬럼이 표시되고 SCM_SITE_ID는 숨겨진다 | `Shipment Result Detail` |
| TC-SSP0026-064 | 그리드 | Excel Form 다운로드 완료(TC-023) | 내려받은 양식의 컬럼을 확인한다 | — | DIVISION_ID~FCST_TYPE 10컬럼(Div*, FromSite*, ToSite*, ShipTo*, Model*, Qty*, yyyyMMdd*, Incoterms*, Trans Mode*, FCST Type*) | `Shipment Request Detail Excel` |
| TC-SSP0026-065 | 그리드 | 팝업 조회 완료 | Project 시트 헤더를 확인한다 | — | 하드코딩 헤더 14종(Division, Project Code, Project, SCM Site, Site, Model Code/Material, Model, Type, Nick Name, Class Name, Incoterms, Transport Mode, BOD ID)이 팝업별 정의대로 나온다 | `Project` / InitSpread 189~210 |
| TC-SSP0026-066 | 그리드 | 001과 같음 | spdMain, spdDetail, spdSub의 모든 시트 탭을 확인한다 | — | `Shipment Request Detail_BACKUP` 시트가 생성되지 않는다(메타만 있고 코드 미참조) | `Shipment Request Detail_BACKUP` |
| TC-SSP0026-067 | 그리드 | DAILY 조회 완료 | 헤더를 확인한다 | 토요일·일요일이 포함된 기간 | SAT 헤더는 파랑, SUN 헤더는 빨강이다. COLUMN_NAME에 `B_`가 있는 컬럼은 숨겨지고 SUM 헤더가 있다 | SetSpreadHeaderSpan 531/542 / `SSP.SSP0026_GET_SPREAD_TITLE` / `Pack Biz` |
| TC-SSP0026-068 | 권한 | 권한 그룹별 사용자 | 저장 버튼 활성 여부를 확인한다 | — | TB_FX_GroupMenuAuth(12행) 값에 따른다(C/R/U/D 값 확인 필요) | TB_FX_GroupMenuAuth / `SSP.SSP0026_SAVE_SHIP_REQ_PACK` |
| TC-SSP0026-069 | 권한 | Division 권한이 제한된 사용자 | cboDivision 목록을 확인한다 | — | 권한이 있는 Division만 표시된다(TB_FX_USERGROUPAUTHEXTENTION) | `Form_Load` / `biz:CommonData.CommonDataList`[MyDivision] |
| TC-SSP0026-070 | 초기화 | 정적 분석 확인 | 모든 버튼과 이벤트를 실행하면서 SQL 추적을 켠다 | — | 현행 화면 동작 중에 이 엔드포인트가 호출되지 않는다(진입점 미연결 GetBizTypebyDivision) | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` |
| TC-SSP0026-071 | 초기화 | 070과 같음 | 저장과 업로드를 포함해 모든 동작을 실행하면서 SQL 추적을 켠다 | — | 이 엔드포인트가 호출되지 않는다(BodValidChk_Main/BodValidChk 미연결). 호출되면 분석서를 정정한다 | `SSP.SSP0002_GET_BOD_VALID_CHECK` |
| TC-SSP0026-072 | 저장 | Pack 저장 중 SP 오류(예: BOD 미존재 데이터) | 저장(SaveButton)을 누른다 | 존재하지 않는 BOD 조합 | 오류 메시지를 표시하고 롤백한다. 그리드는 변경 전 상태를 유지한다(메시지 원문 확인 필요) | `SSP.SSP0026_SAVE_SHIP_REQ_PACK` |

### 커버리지 점검

| 대상 | 전체 | TC 존재 |
|---|---:|---:|
| 이벤트 핸들러 | 29 | 29 (Form_Load 001·051·052 / btnExcelFormDownload_Click 023 / btnExcelUpload_Click 024·025 / btnMeasure_Click 026 / cboDivision_SelectedIndexChanged 028 / btnColumn_Click 027 / chkSum_CheckedChanged 029 / btnProject_Click 034 / cboBucketType_SelectedIndexChanged 030~032 / clbCustomer_SelectedIndexChanged 038 / clbTeam_SelectedIndexChanged 039 / SpdMain_TopChange 040 / SpdMain_CellDoubleClick 021·022 / SpdDetail_TopChange 041 / BtnSearch_Click 017~020 / SpdMain_ComboSelChange 042 / SpdDetail_ComboSelChange 044 / SpdDetail_CellDoubleClick 047 / SpdDetail_ClipboardPasted 045·046 / SpdMain_ClipboardPasted 043 / BtnItemID_Click 035 / BtnItemID2_Click 036 / BtnRequestor_Click 037 / chkPastPeriod_CheckedChanged 033 / SpdDetail_ActiveSheetChanged 048 / SpdMain_ActiveSheetChanged 049·050 / clbDivision_SelectedIndexChanged 056 / btnButtonList_UsrButtonList_Click_Detected 053·054 / spdMain_CellDoubleClick 057) |
| 엔드포인트 | 19 | 19 (`biz:CommonData.CommonDataList` 001·002·005·042·044·069 / `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` 008·010·011 / `SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL` 009 / `SSP.SSP0026_GET_RESULT_DETAIL` 019 / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` 017·021 / `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` 018·022 / `SSP.SSP0026_SAVE_SHIP_REQ_PACK` 012·072 / `SSP.SSP0026_SAVE_SHIP_REQ_CELL` 013 / `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK` 014 / `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_CELL` 015 / `SSP.SSP0026_GET_SPREAD_TITLE` 004·026 / `DM.DM0003_GET_BUCKET_TYPE_CODE` 003 / `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` 070 / `SSP.SSP0002_GET_BOD_VALID_CHECK` 071 / `SSP.SSP0026_GET_BOD_ITEM` 042·053 / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN` 023 / `SCM.SCM0001_GET_DIVISION` 051·052 / `SCM.SCM0001_GET_SITE_BY_DIVISION` 051 / `SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP` 052·054) |
| 시트 | 7 | 7 (`Pack Biz` 059 / `Cell Biz` 060 / `Shipment Request Detail` 062 / `Shipment Result Detail` 063 / `Shipment Request Detail Excel` 064 / `Project` 065 / `Shipment Request Detail_BACKUP` 066) |
| Division 변형 | 40 / 그 외 | 058·059·060·061·028 |
| 빈 결과 / 오류 응답 | — | 010·020·055 / 011·015·016·018·072 |
