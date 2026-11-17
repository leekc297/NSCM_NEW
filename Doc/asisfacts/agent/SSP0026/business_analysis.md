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
