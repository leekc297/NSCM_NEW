# SHEET_MEASURE 지식사전 + AS-IS↔TO-BE 대사
> **스냅샷** 2026-08-21 · **AS-IS 원천** DEV / LGCE_SCMDEV
> **재생성** `_artifacts/_diagnostics/ui_meta_dictionary_20260821/` (01~05 실행 후 07_build_outputs.py)
> ⚠ 이 파일은 생성물이다. 직접 수정하지 말고 파이프라인을 고쳐 재생성한다.
>
> AS-IS 를 정본으로 두고 TO-BE 를 전수 대사한다. 차이는 누락(MISSING)/확장(EXTRA)/속성불일치(DIFF)로 나뉜다.

## 0. 대사 규약

- **키**: PROGRAM_ID + SHEET_NAME + COLUMN_NAME — PK_SCM_MST_SHEET_MEASURE = UNIQUE INDEX(PROGRAM_ID,SHEET_NAME,COLUMN_NAME) 실측. 제약 아님. 양측 3부 키 중복 0건.
- **division 비교**: 토큰 집합 비교 ('40,82,81' == '81,82,40'). ''==NULL
- **대사 속성**: COLUMN_LABEL_NAME, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, INPUT_TP_CD, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, SORT_ORDER_NO, DIVISION_ID
- **범위**: DM 25 PROGRAM_ID
- ATTRIBUTE3 = MEASURE_COLOR. SHEET_MEASURE 에는 width/align/scale/cell control 이 없다 — PIVOT 값 슬롯이다.

## 1. 대사 결과

| 구분 | DM 범위 | 전 도메인 |
|---|---:|---:|
| SAME | 329 | 1084 |
| DIFF | 118 | 366 |
| MISSING | 1 | 55 |
| EXTRA | 17 | 261 |

### 1.1 DIFF 계통 (DM 범위)

| 계통 | 건수 | 뜻 |
|---|---:|---|
| DIV_SCOPE_ADDED | 87 | AS-IS division 을 유지한 채 TO-BE 가 division 만 추가 — 적용범위 확장 |
| EMPTY_TO_DEFAULT | 25 | AS-IS 공란 → Oracle NOT NULL DEFAULT 로 채워짐. ⚠ DEFAULT_FLAG ''→'Y' 는 기본 미표시 measure 가 기본 표시로 바뀌는 의미 변경 |
| REAL | 6 | 위 둘로 설명되지 않는 실차이 — 확인 대상 |

⇒ **설명되지 않는 실차이(REAL) 6건** 이 확인 대상이다.

### 1.2 속성별 DIFF 분포

| 속성 | 건수 |
|---|---:|
| COLUMN_LABEL_NAME | 1 |
| DEFAULT_FLAG | 14 |
| DIVISION_ID | 87 |
| SMALL_CLASS_LABEL_NAME | 1 |
| SORT_ORDER_NO | 2 |
| USER_SELECTABLE_FLAG | 11 |
| VALID_YN | 2 |

### 1.3 화면별 요약 (SAME 외)

| 화면 | 내역 |
|---|---|
| DM0003 | {'DIFF': 1, 'SAME': 19} |
| DM0007 | {'DIFF': 14, 'SAME': 9} |
| DMF0003 | {'DIFF': 14, 'SAME': 33} |
| DMF0021 | {'DIFF': 3, 'EXTRA': 2, 'MISSING': 1, 'SAME': 43} |
| DMF0022 | {'DIFF': 1, 'EXTRA': 2, 'SAME': 28} |
| DMF0035 | {'DIFF': 17, 'EXTRA': 1, 'SAME': 31} |
| DMF0041 | {'DIFF': 10} |
| DMF0044 | {'DIFF': 1, 'EXTRA': 3, 'SAME': 14} |
| DMF0045 | {'DIFF': 20, 'SAME': 2} |
| DMF0048 | {'DIFF': 2, 'EXTRA': 1, 'SAME': 36} |
| DMF0051 | {'DIFF': 1, 'SAME': 8} |
| DMF0066 | {'DIFF': 22} |
| DMF0081 | {'DIFF': 1} |
| DMF0082 | {'DIFF': 11, 'EXTRA': 8, 'SAME': 3} |

## 2. DM 범위 차이 전수 (SAME 제외)

| 화면 | 시트 | MEASURE | 구분 | 계통 | 내용/사유 |
|---|---|---|---|---|---|
| DM0003 | Mkt Fcst | `CUST_FCST` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DM0007 | Customer FCST | `Backorder` | DIFF | EMPTY_TO_DEFAULT | DEFAULT_FLAG:  → Y |
| DM0007 | Customer FCST | `Customer PO` | DIFF | EMPTY_TO_DEFAULT | DEFAULT_FLAG:  → Y |
| DM0007 | Customer FCST | `Customer PP` | DIFF | EMPTY_TO_DEFAULT | DEFAULT_FLAG:  → Y |
| DM0007 | Customer FCST | `D/O` | DIFF | EMPTY_TO_DEFAULT | DEFAULT_FLAG:  → Y |
| DM0007 | Customer FCST | `FCST` | DIFF | EMPTY_TO_DEFAULT | DEFAULT_FLAG:  → Y |
| DM0007 | Customer FCST | `Inventory (CAR)` | DIFF | EMPTY_TO_DEFAULT | DEFAULT_FLAG:  → Y |
| DM0007 | Customer FCST | `Inventory (CL)` | DIFF | EMPTY_TO_DEFAULT | DEFAULT_FLAG:  → Y |
| DM0007 | Customer FCST | `Inventory (MD)` | DIFF | EMPTY_TO_DEFAULT | DEFAULT_FLAG:  → Y |
| DM0007 | Customer FCST | `Inventory (PK)` | DIFF | EMPTY_TO_DEFAULT | DEFAULT_FLAG:  → Y |
| DM0007 | Customer FCST | `Inventory Car` | DIFF | EMPTY_TO_DEFAULT | DEFAULT_FLAG:  → Y |
| DM0007 | Customer FCST | `P/O` | DIFF | EMPTY_TO_DEFAULT | DEFAULT_FLAG:  → Y |
| DM0007 | Customer FCST | `Prod. Plan (CAR)` | DIFF | EMPTY_TO_DEFAULT | DEFAULT_FLAG:  → Y |
| DM0007 | Customer FCST | `Prod. Plan (MD)` | DIFF | EMPTY_TO_DEFAULT | DEFAULT_FLAG:  → Y |
| DM0007 | Customer FCST | `Prod. Plan (PK)` | DIFF | EMPTY_TO_DEFAULT | DEFAULT_FLAG:  → Y |
| DMF0003 | Mkt Fcst | `AS_In_Plan` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0003 | Mkt Fcst | `AS_In_Req` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0003 | Mkt Fcst | `AS_SHIP_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0003 | Mkt Fcst | `CUST_DIO` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0003 | Mkt Fcst | `CUST_INV_I` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0003 | Mkt Fcst | `CUST_PRODUCT_S` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0003 | Mkt Fcst | `CUST_WHIN_P` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0003 | Mkt Fcst | `MKT_DIO` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0003 | Mkt Fcst | `MKT_INV_I` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0003 | Mkt Fcst | `MKT_PRODUCT_S` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0003 | Mkt Fcst | `MKT_WHIN_P` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0003 | Mkt Fcst | `RTF_RP_CAR` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC'] |
| DMF0003 | Mkt Fcst | `VMI_In_Plan_TEST` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC'] |
| DMF0003 | Mkt Fcst | `VMI_Inv_TEST` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC'] |
| DMF0021 | Sales Plan | `CUST_FCST` | DIFF | REAL | SORT_ORDER_NO: 40 → 42 |
| DMF0021 | Sales Plan | `LOC_Catch_Up` | EXTRA | - | 미확인(TO-BE 단독 행 — 확장 근거 문서 미확인) |
| DMF0021 | Sales Plan | `RTF_RP_CAR` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC'] |
| DMF0021 | Sales Plan | `SalesAmt_KRW_User` | MISSING | - | AS-IS 존재 / TO-BE 부재 — 이관 누락 |
| DMF0021 | Sales Plan | `SalesAmt_LOC_User` | EXTRA | - | 미확인(TO-BE 단독 행 — 확장 근거 문서 미확인) |
| DMF0021 | Sales Plan | `TMM_FCST` | DIFF | REAL | SORT_ORDER_NO: 45 → 43 |
| DMF0022 | Sales Plan Waterfall | `LOC_Catch_Up` | EXTRA | - | 미확인(TO-BE 단독 행 — 확장 근거 문서 미확인) |
| DMF0022 | Sales Plan Waterfall | `MKT_FCST_AA` | EXTRA | - | 미확인(TO-BE 단독 행 — 확장 근거 문서 미확인) |
| DMF0022 | Sales Plan Waterfall | `RTF_RP_CAR` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC'] |
| DMF0035 | Mkt Fcst Waterfall | `AS_SHIP_PLAN` | DIFF | REAL | VALID_YN: Y → N |
| DMF0035 | Mkt Fcst Waterfall | `CUST_DIO` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0035 | Mkt Fcst Waterfall | `CUST_INV_I` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0035 | Mkt Fcst Waterfall | `CUST_Product_S` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0035 | Mkt Fcst Waterfall | `CUST_WHIN_P` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0035 | Mkt Fcst Waterfall | `Car Production_new` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0035 | Mkt Fcst Waterfall | `Customer FCST` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0035 | Mkt Fcst Waterfall | `Customer FCST_new` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0035 | Mkt Fcst Waterfall | `Customer Order_new` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0035 | Mkt Fcst Waterfall | `F_new_edi_fcst` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0035 | Mkt Fcst Waterfall | `MKT_DIO` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0035 | Mkt Fcst Waterfall | `MKT_INV_I` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0035 | Mkt Fcst Waterfall | `MKT_Product_S` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0035 | Mkt Fcst Waterfall | `MKT_WHIN_P` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0035 | Mkt Fcst Waterfall | `RTF_PR` | EXTRA | - | 미확인(TO-BE 단독 행 — 확장 근거 문서 미확인) |
| DMF0035 | Mkt Fcst Waterfall | `RTF_RP_CAR` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC'] |
| DMF0035 | Mkt Fcst Waterfall | `SCM_FCST` | DIFF | REAL | COLUMN_LABEL_NAME: SCM_FCST → SCM FCST[R+P] |
| DMF0035 | Mkt Fcst Waterfall | `SFA` | DIFF | REAL | VALID_YN: N → Y |
| DMF0041 | MDFSimulator | `Amt` | DIFF | EMPTY_TO_DEFAULT | USER_SELECTABLE_FLAG:  → Y |
| DMF0041 | MDFSimulator | `Cell_Qty` | DIFF | EMPTY_TO_DEFAULT | USER_SELECTABLE_FLAG:  → Y |
| DMF0041 | MDFSimulator | `Contract_Term` | DIFF | EMPTY_TO_DEFAULT | USER_SELECTABLE_FLAG:  → Y |
| DMF0041 | MDFSimulator | `MDF_Add` | DIFF | EMPTY_TO_DEFAULT | USER_SELECTABLE_FLAG:  → Y |
| DMF0041 | MDFSimulator | `MDF_Basic` | DIFF | EMPTY_TO_DEFAULT | USER_SELECTABLE_FLAG:  → Y |
| DMF0041 | MDFSimulator | `Total` | DIFF | EMPTY_TO_DEFAULT | USER_SELECTABLE_FLAG:  → Y |
| DMF0041 | MDF_Unit | `$/팩` | DIFF | EMPTY_TO_DEFAULT | USER_SELECTABLE_FLAG:  → Y |
| DMF0041 | MDF_Unit | `천$` | DIFF | EMPTY_TO_DEFAULT | USER_SELECTABLE_FLAG:  → Y |
| DMF0041 | MDF_Unit | `천셀` | DIFF | EMPTY_TO_DEFAULT | USER_SELECTABLE_FLAG:  → Y |
| DMF0041 | MDF_Unit | `천팩` | DIFF | EMPTY_TO_DEFAULT | USER_SELECTABLE_FLAG:  → Y |
| DMF0044 | MDF Reports | `Catch_Up` | EXTRA | - | 미확인(TO-BE 단독 행 — 확장 근거 문서 미확인) |
| DMF0044 | MDF Reports | `RTF` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_UC', '82'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0044 | MDF Reports | `SalesAmt_KRW_Catch_Up` | EXTRA | - | 미확인(TO-BE 단독 행 — 확장 근거 문서 미확인) |
| DMF0044 | MDF Reports | `SalesAmt_LOC_Catch_Up` | EXTRA | - | 미확인(TO-BE 단독 행 — 확장 근거 문서 미확인) |
| DMF0045 | Cell Biz | `INSP_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0045 | Cell Biz | `INTN_MOVEMENT` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0045 | Cell Biz | `RTF` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC'] |
| DMF0045 | Cell Biz | `RTF_SCP` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC'] |
| DMF0045 | Cell Biz | `SHIP_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0045 | Cell Biz | `SHIP_REQ` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0045 | Cell Biz | `SITE_MOVE` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0045 | Cell Biz | `TOTAL_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0045 | Cell Biz | `TOTAL_REQ` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0045 | Cell Biz | `WH_BOH_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0045 | Cell Biz | `WH_BOH_REQ` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0045 | Pack Biz | `PACK_FP` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0045 | Pack Biz | `RTF` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC'] |
| DMF0045 | Pack Biz | `RTF_SCP` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC'] |
| DMF0045 | Pack Biz | `SHIP_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0045 | Pack Biz | `SHIP_REQ` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0045 | Pack Biz | `TOTAL_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0045 | Pack Biz | `TOTAL_REQ` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0045 | Pack Biz | `WH_BOH_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0045 | Pack Biz | `WH_BOH_REQ` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0048 | Sales Monitoring | `RTF_PR` | EXTRA | - | 미확인(TO-BE 단독 행 — 확장 근거 문서 미확인) |
| DMF0048 | Sales Monitoring | `RTF_RP_CAR` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC'] |
| DMF0048 | Sales Monitoring | `RTF_RP_CELL` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC'] |
| DMF0051 | Biz Plan Waterfall | `LOC` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Cell Biz | `INSP_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Cell Biz | `INTN_MOVEMENT` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Cell Biz | `RTF` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Cell Biz | `RTF_SCP` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Cell Biz | `SCP_SHIP_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Cell Biz | `SHIP_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Cell Biz | `SHIP_REQ` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Cell Biz | `SITE_MOVE` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Cell Biz | `TOTAL_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Cell Biz | `TOTAL_REQ` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Cell Biz | `WH_BOH_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Cell Biz | `WH_BOH_REQ` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Pack Biz | `PACK_FP` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Pack Biz | `RTF` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Pack Biz | `RTF_SCP` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Pack Biz | `SCP_SHIP_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Pack Biz | `SHIP_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Pack Biz | `SHIP_REQ` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Pack Biz | `TOTAL_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Pack Biz | `TOTAL_REQ` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Pack Biz | `WH_BOH_PLAN` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0066 | Pack Biz | `WH_BOH_REQ` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['81', '81_UC', '82'] → ['81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0081 | Car Fcst | `S` | DIFF | EMPTY_TO_DEFAULT | USER_SELECTABLE_FLAG:  → Y |
| DMF0082 | FcstNPrice | `AS_In_Plan` | EXTRA | - | 2026-08-07 UICATEGORY 81/82 확장 (AS-IS 는 division 40 단독) — Doc/_archive/work_reports/2026-08-07_DMF0082_uicategory_보완.md |
| DMF0082 | FcstNPrice | `AS_In_Req` | EXTRA | - | 2026-08-07 UICATEGORY 81/82 확장 (AS-IS 는 division 40 단독) — Doc/_archive/work_reports/2026-08-07_DMF0082_uicategory_보완.md |
| DMF0082 | FcstNPrice | `AS_Inv` | EXTRA | - | 2026-08-07 UICATEGORY 81/82 확장 (AS-IS 는 division 40 단독) — Doc/_archive/work_reports/2026-08-07_DMF0082_uicategory_보완.md |
| DMF0082 | FcstNPrice | `BALANCE` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0082 | FcstNPrice | `CUST_FCST` | EXTRA | - | 2026-08-07 UICATEGORY 81/82 확장 (AS-IS 는 division 40 단독) — Doc/_archive/work_reports/2026-08-07_DMF0082_uicategory_보완.md |
| DMF0082 | FcstNPrice | `IN_TRANSIT` | EXTRA | - | 2026-08-07 UICATEGORY 81/82 확장 (AS-IS 는 division 40 단독) — Doc/_archive/work_reports/2026-08-07_DMF0082_uicategory_보완.md |
| DMF0082 | FcstNPrice | `KRW` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0082 | FcstNPrice | `LOC` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0082 | FcstNPrice | `MKT_FCST` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0082 | FcstNPrice | `MKT_FCST_PP` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0082 | FcstNPrice | `RTF_SCP` | EXTRA | - | 2026-08-07 UICATEGORY 81/82 확장 (AS-IS 는 division 40 단독) — Doc/_archive/work_reports/2026-08-07_DMF0082_uicategory_보완.md |
| DMF0082 | FcstNPrice | `RTF_SYS_RP` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0082 | FcstNPrice | `SCM_FCST` | DIFF | REAL | SMALL_CLASS_LABEL_NAME: SCM_FCST → SCM FCST[R+P] |
| DMF0082 | FcstNPrice | `TMM_FCST` | EXTRA | - | 2026-08-07 UICATEGORY 81/82 확장 (AS-IS 는 division 40 단독) — Doc/_archive/work_reports/2026-08-07_DMF0082_uicategory_보완.md |
| DMF0082 | FcstNPrice | `USD` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0082 | FcstNPrice | `VMI_DIO` | EXTRA | - | 2026-08-07 UICATEGORY 81/82 확장 (AS-IS 는 division 40 단독) — Doc/_archive/work_reports/2026-08-07_DMF0082_uicategory_보완.md |
| DMF0082 | FcstNPrice | `VMI_In_Plan` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0082 | FcstNPrice | `VMI_In_Req` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |
| DMF0082 | FcstNPrice | `VMI_Inv` | DIFF | DIV_SCOPE_ADDED | DIVISION_ID: ['40'] → ['40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'] |

## 3. MEASURE 표준 (전 494종)

| MEASURE | AS-IS 행/화면 | TO-BE 행/화면 | 라벨 표준 | DEFAULT | 선택가능 | 색(ATTR3) | division |
|---|---:|---:|---|---|---|---|---|
| `$/팩` | 1/1 | 1/1 | $/팩 | {'Y': 2} | {'Y': 1} | - | 40 |
| `ACTIVATE_COMPLETED` | 4/4 | 4/4 | Char. Completed | {'Y': 8} | {'Y': 8} | - | - |
| `ACTIVATE_PROGRESS` | 5/5 | 5/5 | Formation Progress | {'Y': 10} | {'N': 2, 'Y': 8} | - | - |
| `ADJ_ULD_RT` | 6/2 | 13/2 | Rate of Non Loading Time Adjustment | {'Y': 19} | {'Y': 13} | - | - |
| `ALLOCATION` | 16/16 | 16/16 | RTF | {'Y': 32} | {'N': 22, 'Y': 9} | - | ??,PACK |
| `ALLOCATION_DIO` | 3/3 | 3/3 | DIO(RTF) | {'Y': 6} | {'N': 6} | - | ALL |
| `ALLOCATION_GAP_MIN_DIO` | 2/2 | 2/2 | DIO Gap (Minimum) | {'Y': 4} | {'N': 2, 'Y': 2} | - | ALL |
| `ALLOCATION_GAP_STD_DIO` | 2/2 | 2/2 | DIO Gap (Standard) | {'Y': 4} | {'N': 2, 'Y': 2} | - | ALL |
| `ALLOCATION_TOTAL` | 3/3 | 3/3 | ALLOCATION_TOTAL | {'Y': 6} | {'N': 6} | - | ALL |
| `AMT` | 1/1 | 1/1 | 금액 | {'Y': 2} | {'Y': 1} | - | 40 |
| `AS_GAP_ACC` | 1/1 | 2/2 | AS ACC(RTF-FCST) | {'Y': 3} | {'Y': 3} | - | - |
| `AS_INV` | 4/4 | 5/5 | AS Inv. | {'N': 6, 'Y': 3} | {'N': 1, 'Y': 8} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `AS_IN_PLAN` | 4/4 | 5/5 | AS In Plan[R+P] | {'N': 6, 'Y': 3} | {'N': 1, 'Y': 8} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `AS_IN_REQ` | 4/4 | 5/5 | AS In Request[R+P] | {'N': 6, 'Y': 3} | {'N': 1, 'Y': 8} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `AS_MKT_FCST` | 1/1 | 2/2 | AS FCST | {'Y': 3} | {'Y': 3} | - | - |
| `AS_RTF` | 1/1 | 1/1 | AS RTF | {'Y': 2} | {'Y': 2} | - | - |
| `AS_SHIP_PLAN` | 2/2 | 2/2 | AS_SHIP_PLAN | {'N': 4} | {'Y': 4} | - | 81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `ATP` | 1/1 | 1/1 | ATP | {'Y': 2} | {'Y': 2} | - | - |
| `AVAILABLE_DIO` | 1/1 | 1/1 | (Available) DIO | {'Y': 2} | {'Y': 2} | - | - |
| `AVAILABLE_QTY` | 1/1 | 1/1 | (Available) Qty | {'Y': 2} | {'Y': 2} | - | - |
| `AV_RT` | 6/2 | 13/2 | Rate of Availability Time | {'Y': 19} | {'Y': 13} | - | - |
| `BACKORDER` | 1/1 | 1/1 | Backorder | {'Y': 1} | {'Y': 2} | - | - |
| `BALANCE` | 29/27 | 28/26 | Balance | {'N': 9, 'Y': 48} | {'N': 23, 'Y': 34} | {'242,242,242': 4, '252,213,180': 12} | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82,TOTAL |
| `BALANCE_CUM` | 1/1 | 1/1 | Balance(cum) | {'Y': 2} | {'N': 2} | - | TOTAL |
| `BEFORE_BOXING` | 1/1 | 1/1 | Before Boxing | {'Y': 2} | {'N': 2} | - | CELL |
| `BIZPLANPRICE_CUR` | 1/1 | 1/1 | Biz Plan Price(Cur.) | {'Y': 2} | {'Y': 2} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `BIZPLANPRICE_KRW` | 1/1 | 1/1 | Biz Plan Price(KRW) | {'Y': 2} | {'Y': 2} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `BM_RT` | 6/2 | 13/2 | Rate of Break down Maintenance (non-temporary stop) | {'Y': 19} | {'Y': 13} | - | - |
| `BNPIN` | 2/2 | 1/1 | BNP In | {'N': 1, 'Y': 2} | {'N': 1, 'Y': 2} | - | 82 |
| `BNP_IN` | 1/1 | 1/1 | BNP in | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `BOH` | 1/1 | 1/1 | BOH | {'Y': 2} | {'Y': 2} | - | - |
| `BOH_STOCK_OSP` | 1/1 | 1/1 | Packer | {'Y': 2} | {'Y': 2} | - | - |
| `BOXING_COMPLETE` | 1/1 | 1/1 | Boxing Complete | {'Y': 2} | {'N': 2} | - | CELL |
| `BUSINESS_PLAN` | 4/4 | 4/4 | Business Plan | {'Y': 8} | {'Y': 8} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `BUSINESS_PLAN_CONF` | 1/1 | 1/1 | Business Plan(Conf.) | {'Y': 2} | {'Y': 2} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `CAPA` | 2/2 | 2/2 | CAPA | {'Y': 4} | {'N': 4} | - | - |
| `CAPA_NJ` | 1/1 | 1/1 | CAPA NJ | {'Y': 2} | {'N': 2} | - | - |
| `CAPA_OC` | 1/1 | 1/1 | CAPA OC | {'Y': 2} | {'N': 2} | - | - |
| `CAR PRODUCTION_NEW` | 2/2 | 2/2 | Car Production_new | {'N': 2, 'Y': 2} | {'Y': 4} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `CAR_PRODUCTION` | 2/2 | 2/2 | CAR_PRODUCTION | {'N': 2, 'Y': 2} | {'Y': 4} | - | - |
| `CAR_PRODUCTION_NEW` | 1/1 | 1/1 | Car_Production_new | {'N': 2} | {'Y': 2} | - | - |
| `CAR_QTY` | 2/2 | 2/2 | Car Qty | {'Y': 4} | {'Y': 4} | - | - |
| `CATCH_UP` | 2/2 | 3/3 | Catch-Up | {'N': 3, 'Y': 2} | {'N': 1, 'Y': 4} | - | 40 |
| `CELL-USED_QTY` | 1/1 | 1/1 | Used Cells(in Pack) | {'Y': 2} | {'Y': 2} | - | - |
| `CELL_BALANCE` | 1/1 | 1/1 | Balance | {'Y': 2} | {'N': 2} | - | CELL |
| `CELL_BOH` | 4/4 | 4/4 | Cell BOH | {'Y': 8} | {'N': 8} | - | CELL |
| `CELL_CHAR_AVAILABLE` | 5/5 | 6/6 | Char. Available | {'Y': 11} | {'N': 6, 'Y': 4} | {'239,239,239': 2} | CELL |
| `CELL_CHAR_PLAN` | 5/5 | 6/6 | Char. Plan | {'Y': 11} | {'N': 6, 'Y': 4} | - | CELL |
| `CELL_EOH` | 6/6 | 7/7 | Cell Inventory | {'Y': 13} | {'N': 8, 'Y': 4} | {'225,213,222': 2, '239,239,239': 2} | CELL |
| `CELL_FORMATION` | 1/1 | 1/1 | Formation | {'Y': 2} | {'N': 2} | - | CELL |
| `CELL_FORM_HOLD` | 4/4 | 1/1 | Form. Hold | {'Y': 5} | {'N': 5} | - | CELL |
| `CELL_FORM_HOLD_AFTER` | 4/4 | 4/4 | After Form. Hold Release | {'Y': 8} | {'N': 6, 'Y': 1} | - | CELL |
| `CELL_FORM_HOLD_UNDER` | 4/4 | 4/4 | Form. Hold Release | {'Y': 8} | {'N': 6, 'Y': 1} | - | CELL |
| `CELL_FORM_HOLD_UNDER_AVAILABLE` | 3/3 | 3/3 | Form. Hold Release(avail) | {'Y': 6} | {'N': 6} | - | CELL |
| `CELL_FORM_PROGRESS` | 5/5 | 6/6 | Form. Progress | {'Y': 11} | {'N': 6, 'Y': 4} | {'239,239,239': 2} | CELL |
| `CELL_FOR_FORM_END` | 4/4 | 4/4 | Form. End Eta (Past) | {'Y': 8} | {'N': 6, 'Y': 1} | - | CELL |
| `CELL_INTRANSIT` | 1/1 | 1/1 | In transit | {'Y': 2} | {'N': 2} | - | CELL |
| `CELL_INTRANSIT_ETA` | 1/1 | 1/1 | In-Transit(ETA) | {'Y': 2} | {'N': 2} | - | CELL |
| `CELL_MODEL_CHANGE` | 1/1 | 1/1 | Model Change | {'Y': 2} | {'N': 2} | - | CELL |
| `CELL_PKG_PLAN_IN` | 1/1 | 1/1 | PKG Plan_In | {'Y': 2} | {'N': 2} | - | CELL |
| `CELL_PKG_PLAN_OUT` | 1/1 | 1/1 | PKG Plan_Out | {'Y': 2} | {'N': 2} | - | CELL |
| `CELL_PROD` | 5/5 | 7/7 | Production(PKG) | {'Y': 12} | {'N': 7, 'Y': 4} | {'252,213,180': 3} | CELL |
| `CELL_PROD_FORM_END` | 4/4 | 4/4 | Form. End Eta (Prod) | {'Y': 8} | {'N': 6, 'Y': 1} | {'237,248,170': 2} | CELL |
| `CELL_PROD_LOAD` | 4/4 | 4/4 | Load Ratio(%) | {'Y': 8} | {'N': 6, 'Y': 1} | {'163,255,194': 2} | CELL |
| `CELL_QTY` | 1/1 | 1/1 | 팩수량 | {'Y': 2} | {'Y': 1} | - | 40 |
| `CELL_REQ` | 1/1 | 1/1 | Cell Requirement Total | {'Y': 2} | {'N': 2} | - | CELL |
| `CELL_SHIP_PLAN` | 1/1 | 1/1 | Ship Plan(SCP) | {'Y': 2} | {'N': 2} | - | CELL |
| `CELL_SHIP_PLAN_ETA` | 1/1 | 1/1 | Ship Plan(ETA) | {'Y': 2} | {'N': 2} | - | CELL |
| `CELL_SHIP_PLAN_SSP` | 1/1 | 1/1 | Ship Plan(SSP) | {'Y': 2} | {'N': 2} | - | CELL |
| `CELL_SHIP_PLAN_TOTAL` | 4/4 | 4/4 | Cell Ship Plan(Sum) | {'Y': 8} | {'N': 6, 'Y': 1} | {'252,213,180': 2} | CELL |
| `CELL_TACT_TIME` | 1/1 | 1/1 | Tact Time | {'Y': 2} | {'N': 2} | - | CELL |
| `CELL_WHIN` | 1/1 | 1/1 | WH In | {'Y': 2} | {'N': 2} | - | CELL |
| `CELL_WORKING_TIME` | 1/1 | 1/1 | Working Time | {'Y': 2} | {'N': 2} | - | CELL |
| `CFA` | 7/7 | 5/5 | CFA(%) | {'N': 9, 'Y': 3} | {'N': 1, 'Y': 11} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `CFCR` | 5/5 | 4/4 | CFCR(%) | {'N': 9} | {'N': 1, 'Y': 8} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `CHAR_AVAILABLE` | 5/5 | 5/5 | Char. Available | {'Y': 10} | {'Y': 10} | - | - |
| `CHAR_COMPLETED_QTY` | 4/4 | 4/4 | Char. Complete Qty | {'N': 1, 'Y': 7} | {'Y': 8} | - | - |
| `CM_RT` | 6/2 | 13/2 | Rate of Corrective Maintenance | {'Y': 19} | {'Y': 13} | - | - |
| `COAT_REQ` | 1/1 | 1/1 | Coating Requirement | {'Y': 2} | {'Y': 2} | - | - |
| `COMPLETED_QTY` | 4/4 | 4/4 | Complete Qty | {'N': 1, 'Y': 7} | {'Y': 8} | - | - |
| `CONTAINER` | 2/2 | 2/2 | Container Qty | {'Y': 4} | {'Y': 4} | {'242,242,242': 4} | - |
| `CONTRACT_TERM` | 1/1 | 1/1 | 기본계약조건 | {'Y': 2} | {'Y': 1} | - | 40 |
| `CPM` | 1/1 | 2/1 | CPM | {'Y': 3} | {'Y': 2} | {'192,192,192': 2} | - |
| `CUST. FCST` | 1/1 | 1/1 | Cust. FCST | {'Y': 2} | {'Y': 2} | - | - |
| `CUSTOMER FCST` | 3/3 | 3/3 | Customer FCST | {'N': 4, 'Y': 2} | {'Y': 6} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `CUSTOMER FCST_NEW` | 2/2 | 2/2 | Customer FCST_new | {'N': 2, 'Y': 2} | {'Y': 4} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `CUSTOMER ORDER_NEW` | 2/2 | 2/2 | Customer Order_new | {'N': 2, 'Y': 2} | {'Y': 4} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `CUSTOMER PO` | 1/1 | 1/1 | Customer PO | {'Y': 1} | {'Y': 2} | - | - |
| `CUSTOMER PP` | 1/1 | 1/1 | Customer PP | {'Y': 1} | {'Y': 2} | - | - |
| `CUST_DIO` | 4/4 | 4/4 | Customer-DIO | {'N': 8} | {'Y': 8} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `CUST_FCST` | 13/11 | 13/11 | Cust. FCST[P+P] | {'N': 7, 'Y': 19} | {'N': 1, 'Y': 25} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `CUST_FCST_EDI` | 4/4 | 3/3 | EDI | {'N': 1, 'Y': 6} | {'N': 1, 'Y': 6} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `CUST_FCST_EDI_ORG` | 2/2 | 2/2 | EDI[Org.] | {'Y': 4} | {'Y': 4} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC |
| `CUST_FCST_ORG` | 2/2 | 2/2 | Cust. FCST[Org.] | {'Y': 4} | {'Y': 4} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `CUST_INV_I` | 5/5 | 5/5 | Customer-Inv. | {'N': 10} | {'Y': 10} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `CUST_MOVE` | 1/1 | 0/0 | Customer Pln | {'N': 1} | {'N': 1} | {'219,229,241': 1} | 40 |
| `CUST_PLAN` | 2/2 | 2/2 | Customer Plan | {'Y': 4} | {'N': 4} | {'219,229,241': 4} | - |
| `CUST_PRODUCT_S` | 4/4 | 4/4 | Customer-Prod. | {'N': 8} | {'Y': 8} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `CUST_REQ` | 2/2 | 2/2 | Customer Req | {'Y': 4} | {'N': 4} | {'219,229,241': 4} | - |
| `CUST_WHIN_P` | 4/4 | 4/4 | Customer-In | {'N': 8} | {'Y': 8} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `D/O` | 1/1 | 1/1 | D/O | {'Y': 1} | {'Y': 2} | - | - |
| `DAILY_CAPA` | 1/1 | 1/1 | Daily Capa | {'Y': 2} | {'Y': 1} | - | - |
| `DEMAND_DECREASE` | 1/1 | 1/1 | 수요 감소 | {'Y': 2} | {'Y': 1} | - | - |
| `DIO` | 6/6 | 7/7 | DIO | {'Y': 13} | {'N': 2, 'Y': 11} | {'228,223,236': 8} | CELL |
| `DIO_CELL` | 1/1 | 2/2 | DIO | {'Y': 3} | {'Y': 3} | - | - |
| `DIO_PACK` | 1/1 | 2/2 | DIO | {'Y': 3} | {'Y': 3} | - | - |
| `DIO_SALES` | 1/1 | 2/2 | DIO | {'Y': 3} | {'Y': 3} | - | - |
| `DIO_UNDER_SUM` | 1/1 | 1/1 | DIO 미달 | {'Y': 2} | {'Y': 1} | - | - |
| `DM_MKT_FCST` | 1/1 | 1/1 | MKT FCST | {'Y': 2} | {'N': 2} | - | TOTAL |
| `ELEC_RTF` | 3/3 | 1/1 | Electrode | {'N': 1, 'Y': 3} | {'N': 1, 'Y': 3} | - | - |
| `ENDING_INV_FOR_DIO` | 0/0 | 1/1 | Unmatched Inv | {'N': 1} | {'N': 1} | - | - |
| `ENDING_INV_MISMATCH_INV` | 0/0 | 1/1 | Unmatched Inv | {'N': 1} | {'N': 1} | - | - |
| `ENDING_INV_UNMATCH_INV` | 0/0 | 1/1 | Unmatched Inv | {'Y': 1} | {'Y': 1} | - | - |
| `EOH` | 1/1 | 0/0 | EOH | {'Y': 1} | {'Y': 1} | - | - |
| `EOH_TOTAL` | 3/3 | 3/3 | EOH_TOTAL | {'Y': 6} | {'N': 6} | - | ALL |
| `EQP_NBU` | 3/2 | 6/3 | 설비대수 | {'Y': 9} | {'Y': 6} | - | - |
| `EQP_QTY` | 0/0 | 1/1 | Equipment Quantity | {'Y': 1} | {'Y': 1} | - | - |
| `EQP_SPED` | 1/1 | 1/1 | m/min | {'Y': 2} | {'Y': 1} | - | - |
| `ETA_PAST` | 1/1 | 1/1 | Boxing Complete ETA(Past) | {'Y': 2} | {'N': 2} | - | CELL |
| `ETA_PROD` | 1/1 | 1/1 | Boxing Complete ETA(Prod) | {'Y': 2} | {'N': 2} | - | CELL |
| `ETC1` | 1/1 | 1/1 | 기타1 | {'Y': 2} | {'Y': 1} | - | - |
| `ETC2` | 1/1 | 1/1 | 기타2 | {'Y': 2} | {'Y': 1} | - | - |
| `ETC_LT` | 2/2 | 2/2 | Lead Time | {'Y': 4} | {'N': 2, 'Y': 1} | - | - |
| `ETC_RATE` | 2/2 | 2/2 | Conversion Rate | {'Y': 4} | {'N': 2, 'Y': 1} | - | - |
| `ETC_YIELD` | 2/2 | 2/2 | Yield | {'Y': 4} | {'N': 2, 'Y': 1} | - | - |
| `FCST` | 1/1 | 1/1 | FCST | {'Y': 1} | {'Y': 2} | - | - |
| `FCST_GAP` | 1/1 | 1/1 | Fcst Gap(MKT vs SCM) | {'N': 2} | {'Y': 2} | - | 40 |
| `FCST_QTY` | 1/1 | 1/1 | FCST | {'Y': 2} | {'Y': 2} | - | - |
| `FCST_RTF_ACC` | 5/5 | 5/5 | ACC(RTF-FCST) | {'Y': 10} | {'N': 8, 'Y': 1} | - | ??,PACK |
| `FCST_RTF_GAP` | 5/5 | 5/5 | Gap(RTF-FCST) | {'Y': 10} | {'N': 8, 'Y': 1} | - | ??,PACK |
| `FIX_REASON` | 2/2 | 2/2 | Fix Reason | {'Y': 4} | {'Y': 4} | - | - |
| `FORMATION_YIELD` | 4/4 | 4/4 | Formation Yield(%) | {'Y': 8} | {'Y': 8} | - | - |
| `FP_PLAN` | 1/1 | 0/0 | FP Plan | {'N': 1} | {'N': 1} | - | - |
| `F_NEW_EDI_FCST` | 2/2 | 2/2 | F_new_edi_fcst | {'N': 2, 'Y': 2} | {'Y': 4} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `GAP` | 5/5 | 6/6 | GAP | {'Y': 11} | {'N': 6, 'Y': 4} | {'252,213,180': 2} | CELL |
| `GAP_ACC` | 1/1 | 2/2 | ACC(RTF-FCST) | {'Y': 3} | {'Y': 3} | - | - |
| `GAP_AMT` | 1/1 | 1/1 | Amount Gap | {'Y': 2} | {'Y': 2} | - | - |
| `GAP_DIO` | 1/1 | 1/1 | DIO Gap | {'Y': 2} | {'Y': 2} | - | - |
| `GAP_PRE_GRO_DIO` | 3/3 | 3/3 | DIO Gap | {'N': 2, 'Y': 4} | {'N': 6} | - | CELL |
| `GAP_PRE_MIN_DIO` | 3/3 | 3/3 | DIO Gap | {'N': 2, 'Y': 4} | {'N': 6} | - | CELL |
| `GAP_QTY` | 1/1 | 1/1 | Qty Gap | {'Y': 2} | {'Y': 2} | - | - |
| `ID_RT` | 6/2 | 13/2 | Rate of Idle(Equipment Standby) | {'Y': 19} | {'Y': 13} | - | - |
| `IN-TRANSIT(ETA)` | 1/1 | 1/1 | In-Transit(ETA) | {'N': 2} | {'Y': 2} | - | - |
| `INCO_WIP` | 3/2 | 2/1 | Incomming WIP | {'Y': 5} | {'Y': 5} | - | - |
| `INSP_PLAN` | 5/5 | 5/5 | Inspection plan | {'Y': 10} | {'N': 4, 'Y': 6} | {'219,229,241': 10} | 81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `INSP_WIP` | 3/2 | 2/1 | Inspection WIP | {'Y': 5} | {'Y': 5} | - | - |
| `INTN_MOVEMENT` | 7/7 | 7/7 | Internal movement | {'Y': 14} | {'N': 4, 'Y': 10} | {'219,229,241': 10, '242,242,242': 4} | 81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `INTRANSIT` | 5/5 | 6/6 | Intransit | {'Y': 11} | {'N': 6, 'Y': 5} | {'239,239,239': 2} | ?? |
| `INTRANSIT_ETA` | 4/4 | 4/4 | In-Transit(ETA) | {'Y': 8} | {'N': 6, 'Y': 1} | - | ?? |
| `INTRANSIT_TOTAL` | 1/1 | 1/1 | In transit | {'Y': 2} | {'N': 2} | - | TOTAL |
| `INT_INCOM` | 1/1 | 1/1 | Intransit incoming | {'Y': 2} | {'Y': 2} | - | - |
| `INV` | 1/1 | 1/1 | Inv. | {'Y': 2} | {'Y': 2} | - | - |
| `INVENTORY` | 10/6 | 10/6 | Inventory | {'N': 2, 'Y': 18} | {'N': 2, 'Y': 18} | - | CELL |
| `INVENTORY (CAR)` | 1/1 | 1/1 | Inventory (CAR) | {'Y': 1} | {'Y': 2} | - | - |
| `INVENTORY (CL)` | 1/1 | 1/1 | Inventory (CL) | {'Y': 1} | {'Y': 2} | - | - |
| `INVENTORY (MD)` | 1/1 | 1/1 | Inventory (MD) | {'Y': 1} | {'Y': 2} | - | - |
| `INVENTORY (PK)` | 1/1 | 1/1 | Inventory (PK) | {'Y': 1} | {'Y': 2} | - | - |
| `INVENTORY CAR` | 1/1 | 1/1 | Inventory Car | {'Y': 1} | {'Y': 2} | - | - |
| `INVENTORY_BALANCE_TOTAL` | 2/2 | 2/2 | On site Inventory Balance | {'N': 2, 'Y': 2} | {'N': 4} | - | - |
| `INVENTORY_BOH` | 2/2 | 2/2 | BOH | {'Y': 4} | {'N': 4} | - | - |
| `INVENTORY_HOLD` | 2/2 | 2/2 | 보류재고 | {'Y': 4} | {'N': 4} | - | - |
| `INVENTORY_PRE_DIO` | 2/2 | 2/2 | DIO | {'Y': 4} | {'N': 4} | {'230,150,199': 2} | - |
| `INVENTORY_STD_DIO` | 1/1 | 0/0 | DIO | {'Y': 1} | {'N': 1} | - | - |
| `INVENTORY_TOTAL` | 3/3 | 3/3 | Stock | {'Y': 6} | {'N': 6} | - | CELL,TOTAL |
| `INV_AMT` | 1/1 | 1/1 | Inv. Amount | {'Y': 2} | {'Y': 2} | - | - |
| `INV_DIO` | 1/1 | 1/1 | DIO | {'Y': 2} | {'Y': 2} | - | - |
| `INV_QTY` | 1/1 | 1/1 | Inv. Qty | {'Y': 2} | {'Y': 2} | - | - |
| `IN_HOUSE_MOVING` | 1/1 | 1/1 | In-house Moving | {'Y': 2} | {'Y': 2} | - | - |
| `IN_TRANSIT` | 2/2 | 3/3 | In-Transit(ETA) | {'N': 5} | {'Y': 5} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `KRW` | 12/10 | 12/10 | Unit Price(KRW) | {'N': 14, 'Y': 10} | {'Y': 24} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `LD_RT` | 6/2 | 13/2 | Rate of Loading Time | {'Y': 19} | {'Y': 13} | - | - |
| `LESS_FCST` | 6/6 | 5/5 | Less FCST(%) | {'N': 9, 'Y': 2} | {'N': 1, 'Y': 10} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `LINE_CAPA` | 2/2 | 0/0 | Line Capa(Min) | {'Y': 2} | {'Y': 2} | - | - |
| `LINE_TOTAL_LOAD` | 3/3 | 1/1 | Line Total Load(%) | {'Y': 4} | {'Y': 4} | - | - |
| `LINE_TOTAL_LOAD_AMEND` | 2/2 | 2/2 | Line Total Load Amend (%) | {'Y': 4} | {'Y': 4} | - | - |
| `LINE_TOTAL_LOAD_ENGINE` | 6/6 | 6/6 | Line Total Load Engine (%) | {'Y': 12} | {'Y': 12} | - | - |
| `LINE_TOTAL_PROD` | 2/2 | 0/0 | Line Total Prod Plan | {'Y': 2} | {'Y': 2} | - | - |
| `LOADING_RATE` | 2/2 | 2/2 | LOADING RATE(%) | {'Y': 4} | {'N': 4} | {'216,228,188': 4} | - |
| `LOADING_RATIO_QTY_NJ` | 1/1 | 1/1 | LOADING RATIO QTY(NJ) | {'Y': 2} | {'N': 2} | - | - |
| `LOADING_RATIO_QTY_OC` | 1/1 | 1/1 | LOADING RATIO QTY(OC) | {'Y': 2} | {'N': 2} | - | - |
| `LOADING_RATIO_TIME_NJ` | 1/1 | 1/1 | LOADING RATIO TIME(NJ) | {'Y': 2} | {'N': 2} | - | - |
| `LOADING_RATIO_TIME_OC` | 1/1 | 1/1 | LOADING RATIO TIME(OC) | {'Y': 2} | {'N': 2} | - | - |
| `LOAD_RATE` | 1/1 | 1/1 | 가동율(%) | {'Y': 2} | {'Y': 1} | - | - |
| `LOC` | 15/13 | 14/12 | Unit Price(LOC) | {'N': 11, 'Y': 18} | {'N': 1, 'Y': 28} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `LOC_CATCH_UP` | 0/0 | 2/2 | Unit Price(LOC)_Catch Up | {'N': 2} | {'N': 2} | - | 40 |
| `LOT` | 3/2 | 2/1 | Lot | {'Y': 5} | {'Y': 5} | - | - |
| `M` | 0/0 | 1/1 | M | {'Y': 1} | {'Y': 1} | - | - |
| `MC_RT` | 7/2 | 16/2 | Rate of Model Change | {'Y': 23} | {'Y': 16} | - | - |
| `MDF_ADD` | 1/1 | 1/1 | MDF(추가) | {'Y': 2} | {'Y': 1} | - | 40 |
| `MDF_BASIC` | 1/1 | 1/1 | MDF(기본) | {'Y': 2} | {'Y': 1} | - | 40 |
| `MEASURE_COLOR` | 0/0 | 1/1 | COLOR | {'Y': 1} | {'Y': 1} | {'252,213,180': 1} | - |
| `MES_FCS_HOLD` | 4/3 | 4/3 | Hold Stock | {'Y': 8} | {'Y': 8} | - | - |
| `MES_FCS_RELEASE` | 4/3 | 4/3 | Release Stock | {'Y': 8} | {'Y': 8} | - | - |
| `MISMATCH_INV` | 1/1 | 1/1 | Unmatched Inv | {'Y': 2} | {'Y': 2} | - | - |
| `MKT_AMT_KRW` | 4/4 | 4/4 | MKT FCST Amt.(KRW) | {'N': 8} | {'Y': 8} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `MKT_AMT_LOC` | 4/4 | 4/4 | MKT FCST Amt.(LOC) | {'N': 8} | {'Y': 8} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `MKT_DIO` | 4/4 | 4/4 | Customer-DIO | {'N': 8} | {'Y': 8} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `MKT_FCST` | 35/33 | 35/33 | MKT FCST | {'N': 11, 'Y': 59} | {'N': 21, 'Y': 48} | {'218,238,243': 16, '219,229,241': 3} | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82,?? |
| `MKT_FCST_AA` | 0/0 | 1/1 | MKT FCST[A+P] | {'Y': 1} | {'Y': 1} | - | 81_AA |
| `MKT_FCST_CELL_TOTAL` | 3/3 | 3/3 | MKT FCST Total | {'Y': 6} | {'N': 6} | - | CELL |
| `MKT_FCST_DIO` | 3/3 | 3/3 | DIO(MKT FCST) | {'Y': 6} | {'N': 6} | - | ALL |
| `MKT_FCST_ENERGY` | 5/5 | 5/5 | MKT FCST[R+P] Energy(MWH) | {'N': 10} | {'Y': 10} | - | 40,82 |
| `MKT_FCST_PACK_TOTAL` | 3/3 | 3/3 | MKT FCST Total | {'Y': 6} | {'N': 6} | - | ITEM_ID |
| `MKT_FCST_PP` | 1/1 | 1/1 | MKT FCST[P+P] | {'N': 2} | {'Y': 2} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `MKT_FCST_RP` | 12/10 | 11/9 | MKT FCST[R+P] | {'N': 5, 'Y': 18} | {'N': 1, 'Y': 22} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `MKT_FCST_RP_CAR` | 9/7 | 8/6 | MKT FCST[R+P] CAR | {'N': 11, 'Y': 6} | {'N': 1, 'Y': 16} | - | 81,81_HD,81_HG,81_HM,81_ST,81_UC |
| `MKT_FCST_RP_CELL` | 9/7 | 8/6 | MKT FCST[R+P] CELL | {'N': 9, 'Y': 8} | {'N': 1, 'Y': 16} | - | 81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `MKT_FCST_TOTAL` | 3/3 | 3/3 | MKT_FCST_TOTAL | {'Y': 6} | {'N': 6} | - | ALL |
| `MKT_INV_I` | 5/5 | 5/5 | Customer-Inv. | {'N': 10} | {'Y': 10} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `MKT_PRODUCT_S` | 5/5 | 5/5 | Customer-Prod. | {'N': 8, 'Y': 2} | {'Y': 10} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `MKT_WHIN_P` | 4/4 | 4/4 | Customer-In | {'N': 8} | {'Y': 8} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `MMS` | 1/1 | 2/1 | mm/s | {'Y': 3} | {'Y': 2} | {'192,192,192': 2} | - |
| `MODEL_INVENTORY` | 7/7 | 7/7 | Model Inventory | {'Y': 14} | {'N': 2, 'Y': 12} | {'196,189,151': 12, '228,223,236': 2} | - |
| `MPP` | 1/1 | 1/1 | MPP | {'Y': 2} | {'Y': 2} | - | - |
| `MR_RT` | 6/2 | 13/2 | Rate of Materials Replacement | {'Y': 19} | {'Y': 13} | - | - |
| `NM_RT` | 6/2 | 13/2 | Rate of Out of materials | {'Y': 19} | {'Y': 13} | - | - |
| `NOTCHING` | 3/3 | 3/3 | Notching 투입 | {'Y': 6} | {'Y': 6} | - | - |
| `NOT_CONSUMED_BOH_P` | 1/1 | 1/1 | Unconsumed Inv(Prod) | {'Y': 2} | {'Y': 2} | - | - |
| `NOT_CONSUMED_BOH_S` | 1/1 | 1/1 | Unconsumed Inv(Sales) | {'Y': 2} | {'Y': 2} | - | - |
| `NO_WORK` | 1/1 | 1/1 | 비조업 | {'Y': 2} | {'Y': 1} | - | - |
| `ONHAND_EOH` | 4/4 | 3/3 | Target–Plan(Amend) | {'Y': 7} | {'Y': 7} | - | - |
| `OP-LT-EXCPT_DIO` | 1/1 | 1/1 | OP L/T Except DIO | {'Y': 2} | {'Y': 2} | - | - |
| `OP-LT-EXCPT_QTY` | 1/1 | 1/1 | OP L/T Except Qty | {'Y': 2} | {'Y': 2} | - | - |
| `OP-LT_DIO` | 1/1 | 1/1 | OP L/T | {'Y': 2} | {'Y': 2} | - | - |
| `OP-LT_QTY` | 1/1 | 1/1 | OP L/T Qty | {'Y': 2} | {'Y': 2} | - | - |
| `OP_RT` | 6/2 | 13/2 | Rate of Operation Time | {'Y': 19} | {'Y': 13} | - | - |
| `OVER_FCST` | 6/6 | 5/5 | Over FCST(%) | {'N': 9, 'Y': 2} | {'N': 1, 'Y': 10} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `OVER_SUPPLY` | 1/1 | 1/1 | Over-supply | {'Y': 2} | {'Y': 2} | - | - |
| `OVER_WPP` | 1/1 | 1/1 | Over-WPP | {'Y': 2} | {'Y': 2} | - | - |
| `OWMS_MODEL_INVENTORY` | 1/1 | 1/1 | WMS Inventory | {'Y': 2} | {'Y': 2} | - | - |
| `P/O` | 1/1 | 1/1 | P/O | {'Y': 1} | {'Y': 2} | - | - |
| `PACKL_LINE1` | 1/1 | 0/0 | PACK 1호기 | {'Y': 1} | {'Y': 1} | - | - |
| `PACK_BIZ` | 3/3 | 3/3 | PACK.Biz | {'Y': 6} | {'Y': 6} | - | - |
| `PACK_BOH` | 5/5 | 5/5 | Pack BOH | {'Y': 10} | {'N': 8, 'Y': 1} | {'230,150,199': 2} | PACK |
| `PACK_BOH_EXP_INSP_DATE` | 2/2 | 2/2 | Pack BOH(검사 예정일 반영) | {'Y': 4} | {'N': 2, 'Y': 1} | - | PACK |
| `PACK_BOH_HOLD` | 2/2 | 2/2 | Pack BOH(Hold) | {'Y': 4} | {'N': 2, 'Y': 1} | - | PACK |
| `PACK_BOH_WAIT_FOR_INSP` | 2/2 | 2/2 | Pack BOH(검사 대기) | {'Y': 4} | {'N': 2, 'Y': 1} | - | PACK |
| `PACK_CELL_BOH` | 3/3 | 3/3 | Cell BOH | {'Y': 6} | {'N': 6} | - | PACK |
| `PACK_CELL_BOH_HOLD` | 1/1 | 1/1 | Cell BOH(Hold) | {'Y': 2} | {'N': 2} | - | PACK |
| `PACK_CELL_EOH` | 5/5 | 6/6 | Cell Inventory | {'Y': 11} | {'N': 6, 'Y': 4} | {'239,239,239': 2} | PACK |
| `PACK_CELL_EOH_TOTAL` | 1/1 | 1/1 | Cell Inventory Total | {'Y': 2} | {'N': 2} | - | PACK |
| `PACK_DIO` | 1/1 | 1/1 | DIO | {'Y': 2} | {'N': 2} | - | PACK |
| `PACK_EOH` | 6/6 | 7/7 | Pack Inventory | {'Y': 13} | {'N': 8, 'Y': 4} | {'225,213,222': 2, '239,239,239': 2} | PACK |
| `PACK_FP` | 4/4 | 4/4 | Pack FP | {'Y': 8} | {'Y': 8} | {'219,229,241': 8} | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `PACK_INTRANSIT` | 1/1 | 1/1 | In transit | {'Y': 2} | {'N': 2} | - | PACK |
| `PACK_INTRANSIT_ETA` | 1/1 | 1/1 | In-Transit(ETA) | {'Y': 2} | {'N': 2} | - | PACK |
| `PACK_LINE1` | 3/3 | 3/3 | PACK 1호기 | {'Y': 6} | {'Y': 6} | - | - |
| `PACK_MODEL_CHANGE` | 1/1 | 1/1 | Model Change | {'Y': 2} | {'N': 2} | - | PACK |
| `PACK_PROD` | 6/6 | 7/7 | Production | {'Y': 13} | {'N': 8, 'Y': 4} | {'252,213,180': 3} | PACK |
| `PACK_PROD_LOAD` | 5/5 | 5/5 | Load Ratio(%) | {'Y': 10} | {'N': 8, 'Y': 1} | {'163,255,194': 2} | PACK |
| `PACK_PROD_LOAD_TOTAL` | 1/1 | 1/1 | Load Ratio(%) Total | {'Y': 2} | {'N': 2} | - | PACK |
| `PACK_PROD_TOTAL` | 2/2 | 1/1 | Production Total | {'Y': 3} | {'N': 3} | - | PACK |
| `PACK_RTF` | 1/1 | 1/1 | Packer RTF | {'Y': 2} | {'Y': 2} | - | - |
| `PACK_SHIP_PLAN` | 1/1 | 1/1 | Ship Plan | {'Y': 2} | {'N': 2} | - | PACK |
| `PACK_SHIP_PLAN_ETA` | 1/1 | 1/1 | Ship Plan(ETA) | {'Y': 2} | {'N': 2} | - | PACK |
| `PACK_SHIP_PLAN_TOTAL` | 1/1 | 1/1 | Shipment Plan Total | {'Y': 2} | {'N': 2} | - | ?? |
| `PACK_TACT_TIME` | 1/1 | 1/1 | Tact Time | {'Y': 2} | {'N': 2} | - | PACK |
| `PACK_WHIN` | 1/1 | 1/1 | WH In | {'Y': 2} | {'N': 2} | - | PACK |
| `PACK_WORKING_TIME` | 1/1 | 1/1 | Working Time | {'Y': 2} | {'N': 2} | - | PACK |
| `PD_RT` | 6/2 | 13/2 | Rate of Process Down | {'Y': 19} | {'Y': 13} | - | - |
| `PF_RT` | 6/2 | 13/2 | Rate of Performance Efficiency | {'Y': 19} | {'Y': 13} | - | - |
| `PKG_PLAN` | 1/1 | 1/1 | Package Plan | {'N': 2} | {'Y': 2} | - | - |
| `PLAN_REQ_GAP` | 1/1 | 1/1 | Gap(Shipment REQ vs Plan) | {'Y': 2} | {'N': 2} | - | ?? |
| `PM_RT` | 6/2 | 13/2 | Rate of Preventive Maintenance | {'Y': 19} | {'Y': 13} | - | - |
| `PO` | 1/1 | 1/1 | PO | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `POSTP_PLAN` | 4/3 | 3/2 | Post Process Plan | {'N': 5, 'Y': 2} | {'Y': 7} | {'219,229,241': 2} | 40 |
| `PO_RTF` | 1/1 | 1/1 | PO RTF | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `PPM` | 3/2 | 6/3 | PPM | {'Y': 9} | {'Y': 6} | - | - |
| `PPM_AVG` | 1/1 | 2/1 | PPM(AVG) | {'Y': 3} | {'Y': 2} | {'192,192,192': 2} | - |
| `PP_RT` | 6/2 | 13/2 | Rate of Production Preparation | {'Y': 19} | {'Y': 13} | - | - |
| `PR` | 1/1 | 1/1 | PR | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `PROD` | 1/1 | 1/1 | Production | {'Y': 2} | {'N': 2} | - | CELL |
| `PROD-AFTER-CELL_QTY` | 1/1 | 1/1 | Prod(after Cell) | {'Y': 2} | {'Y': 2} | - | - |
| `PROD-BEFORE-PACK_QTY` | 1/1 | 1/1 | Prod(before Pack) | {'Y': 2} | {'Y': 2} | - | - |
| `PROD. PLAN (CAR)` | 1/1 | 1/1 | Prod. Plan (CAR) | {'Y': 1} | {'Y': 2} | - | - |
| `PROD. PLAN (MD)` | 1/1 | 1/1 | Prod. Plan (MD) | {'Y': 1} | {'Y': 2} | - | - |
| `PROD. PLAN (PK)` | 1/1 | 1/1 | Prod. Plan (PK) | {'Y': 1} | {'Y': 2} | - | - |
| `PRODUCTION` | 7/6 | 7/6 | Production | {'Y': 14} | {'N': 12, 'Y': 1} | {'216,228,188': 8} | - |
| `PRODUCTION_CELL` | 1/1 | 1/1 | Production(Cell) | {'Y': 2} | {'N': 2} | - | - |
| `PRODUCT_ISSUE` | 1/1 | 1/1 | 생산 이슈 | {'Y': 2} | {'Y': 1} | - | - |
| `PROD_CAPA_D` | 6/2 | 13/2 | Daily Production Capacity | {'Y': 19} | {'Y': 13} | - | - |
| `PROD_CAPA_M` | 6/2 | 13/2 | Total Capa | {'Y': 19} | {'Y': 13} | - | - |
| `PROD_DATE` | 3/2 | 2/1 | Production Date | {'Y': 5} | {'Y': 5} | - | - |
| `PROD_LOAD` | 1/1 | 1/1 | Load Rate | {'Y': 2} | {'N': 2} | - | CELL |
| `PROD_OP_RT` | 6/2 | 13/2 | Rate of Production Operation | {'Y': 19} | {'Y': 13} | - | - |
| `PROD_PLAN` | 14/12 | 14/12 | Production | {'Y': 28} | {'N': 8, 'Y': 20} | {'242,242,242': 4} | - |
| `PROD_PLAN_AMEND` | 14/10 | 14/10 | Prod Plan(Amend) | {'Y': 28} | {'N': 6, 'Y': 22} | - | - |
| `PROD_PLAN_BEFORE` | 8/4 | 8/4 | Prod Plan(Before) | {'Y': 16} | {'Y': 16} | - | - |
| `PROD_PLAN_ENGINE` | 12/8 | 12/8 | Prod Plan(Engine) | {'Y': 24} | {'Y': 24} | {'216,228,188': 2} | - |
| `PROD_PLAN_ENGINE_CELL_QTY` | 2/2 | 2/2 | Prod Plan(Engine Cell) | {'Y': 4} | {'Y': 4} | - | - |
| `PROD_PLAN_ENGINE_STD_JR` | 1/1 | 1/1 | Prod Plan(Engine STD J/R) | {'Y': 2} | {'Y': 2} | - | - |
| `PROD_PLAN_INPUT` | 2/2 | 2/2 | 전극계획 조정 | {'Y': 4} | {'N': 4} | - | - |
| `PROD_PLAN_NJ` | 1/1 | 1/1 | PROD PLAN(NJ) | {'Y': 2} | {'N': 2} | - | - |
| `PROD_PLAN_OC` | 1/1 | 1/1 | PROD PLAN(OC) | {'Y': 2} | {'N': 2} | - | - |
| `PROD_PLAN_TOTAL` | 2/2 | 2/2 | SUM | {'Y': 4} | {'N': 4} | - | TOTAL |
| `PROD_QTY` | 1/1 | 1/1 | Prod | {'Y': 2} | {'Y': 2} | - | - |
| `PROD_REQ` | 1/1 | 1/1 | PROD REQ | {'Y': 2} | {'N': 2} | - | - |
| `PROD_TACT_TIME` | 2/2 | 2/2 | TACT TIME | {'Y': 4} | {'N': 4} | - | - |
| `PROD_TOTAL` | 1/1 | 1/1 | Production(Total) | {'Y': 2} | {'N': 2} | - | CELL |
| `PROD_WORKING_TIME` | 2/2 | 2/2 | WORKING TIME | {'Y': 4} | {'N': 4} | - | - |
| `PSI` | 1/1 | 1/1 | PSI | {'N': 2} | {'Y': 2} | - | - |
| `PSI_INVENTORY CAR` | 2/2 | 2/2 | PSI_Inventory Car | {'N': 2, 'Y': 2} | {'Y': 4} | - | - |
| `PSI_INVENTORY CAR_NEW` | 1/1 | 1/1 | PSI_Inventory Car_new | {'N': 2} | {'Y': 2} | - | - |
| `PUR_BALANCE` | 1/1 | 1/1 | Purchasing Balance | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `P_FP_COATER_PLAN` | 1/1 | 1/1 | Coater Plan | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `P_FP_COATER_POST_PLAN` | 1/1 | 1/1 | Coater Plan+ Post Yield | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `P_FP_NPC_ASSY_PLAN` | 1/1 | 1/1 | Assy Plan(Notching) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `P_INTRANSIT_ETA` | 1/1 | 1/1 | Receipt(Intransit)+Shipment Plan(In) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `P_INV_CONFIRM` | 1/1 | 1/1 | Inventory(Confirm) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `P_INV_SIM` | 1/1 | 1/1 | Inventory(Simulation) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `P_SCP_PROD_PLAN` | 1/1 | 1/1 | SCP Target (Coater) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `P_SCP_SHIP_PLAN_ETD` | 1/1 | 1/1 | SCP Target (Shipping Target ETD) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `P_SHIP_CONFIRM_ETD` | 1/1 | 1/1 | Shipment Plan Confirm(ETD) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `P_SHIP_PLAN_SIMU_ETD` | 1/1 | 1/1 | Shipment Plan (ETD) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `P_SHIP_REQ_ETD` | 1/1 | 1/1 | Shipment Request (ETD) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `P_SUM` | 1/1 | 1/1 | Y SUM | {'Y': 2} | {'N': 2} | - | TOTAL |
| `QL_RT` | 6/2 | 13/2 | Quality Rate | {'Y': 19} | {'Y': 13} | - | - |
| `QUALITY_ISSUES_REPORT` | 1/1 | 1/1 | 품질 이슈(보고) | {'Y': 2} | {'Y': 1} | - | - |
| `QUALITY_ISSUES_REPORT_OTHER` | 1/1 | 1/1 | 품질 이슈(보고 외) | {'Y': 2} | {'Y': 1} | - | - |
| `RAMP_UP` | 1/1 | 1/1 | Ramp-up(0.0~1.0) | {'Y': 2} | {'Y': 1} | - | - |
| `RATE` | 1/1 | 1/1 | Archeivement Rate | {'Y': 2} | {'Y': 2} | - | - |
| `RELEASE` | 1/1 | 1/1 | FP PLAN | {'Y': 2} | {'Y': 2} | - | - |
| `REQUIREMENT` | 5/5 | 4/4 | Prod Target | {'Y': 9} | {'N': 8, 'Y': 1} | - | - |
| `RESULT` | 2/2 | 2/2 | RESULT | {'Y': 4} | {'Y': 4} | - | - |
| `RESULT_WITH_RTF` | 1/1 | 1/1 | Result With RTF | {'Y': 2} | {'Y': 2} | - | - |
| `RMA` | 1/1 | 1/1 | RMA | {'N': 2} | {'Y': 2} | - | 40 |
| `RTF` | 23/18 | 23/18 | RTF[R+P] | {'N': 9, 'Y': 37} | {'N': 3, 'Y': 43} | {'219,229,241': 12} | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82,CELL |
| `RTF-FCST_QTY` | 1/1 | 1/1 | RTF-FCST | {'Y': 2} | {'Y': 2} | - | - |
| `RTF_BALANCE` | 1/1 | 1/1 | RTF_BALANCE | {'Y': 2} | {'Y': 2} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC |
| `RTF_CELL` | 1/1 | 1/1 | RTF_MKT Cell | {'Y': 2} | {'Y': 2} | - | 82 |
| `RTF_ENERGY` | 6/6 | 5/5 | RTF[R+P] Energy(MWH) | {'N': 11} | {'N': 1, 'Y': 10} | - | 40,82 |
| `RTF_ENG` | 1/1 | 1/1 | RTF_MKT Energy | {'Y': 2} | {'Y': 2} | - | 82 |
| `RTF_M1` | 2/2 | 2/2 | RTF(M-1) | {'Y': 4} | {'Y': 4} | - | - |
| `RTF_M2` | 2/2 | 2/2 | RTF(M-2) | {'Y': 4} | {'Y': 4} | - | - |
| `RTF_PR` | 2/2 | 4/4 | RTF_PR | {'N': 2, 'Y': 4} | {'Y': 6} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC |
| `RTF_QTY` | 1/1 | 1/1 | RTF | {'Y': 2} | {'Y': 2} | - | - |
| `RTF_RP_CAR` | 8/6 | 8/6 | RTF[R+P] CAR | {'N': 10, 'Y': 6} | {'Y': 16} | - | 81,81_HD,81_HG,81_HM,81_ST,81_UC |
| `RTF_RP_CELL` | 8/6 | 8/6 | RTF_MKT[R+P] CELL | {'N': 10, 'Y': 6} | {'Y': 16} | - | 81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `RTF_SCP` | 11/8 | 11/8 | RTF_System[R+P] | {'N': 7, 'Y': 15} | {'Y': 22} | {'219,229,241': 12} | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `RTF_SYS_RP` | 10/10 | 9/9 | RTF[R+P] | {'N': 4, 'Y': 15} | {'Y': 19} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `RTF_SYS_RP_CAR` | 7/7 | 6/6 | RTF[R+P] CAR | {'N': 11, 'Y': 2} | {'N': 1, 'Y': 12} | - | 81,81_HD,81_HG,81_HM,81_ST,81_UC |
| `RTF_SYS_RP_CELL` | 7/7 | 6/6 | RTF[R+P] CELL | {'N': 11, 'Y': 2} | {'N': 1, 'Y': 12} | - | 81,81_HD,81_HG,81_HM,81_ST,81_UC |
| `RTF_SYS_RP_ENG` | 1/1 | 1/1 | RTF[R+P] Energy (MWH) | {'Y': 2} | {'Y': 2} | - | 82 |
| `RTF_TEST` | 1/1 | 1/1 | RTF_System[R+P] | {'N': 2} | {'Y': 2} | - | 40 |
| `R_FP_COATER_PLAN` | 1/1 | 1/1 | Coater Plan | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `R_FP_COATER_POST_PLAN` | 1/1 | 1/1 | Coater Plan+ Post Yield | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `R_FP_NPC_ASSY_PLAN` | 1/1 | 1/1 | Assy Plan(Notching) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `R_INTRANSIT_ETA` | 1/1 | 1/1 | Receipt(Intransit)+Shipment Plan(In) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `R_INV_SHIP_PLAN` | 1/1 | 1/1 | Inventory(Ship Plan) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `R_INV_SHIP_REQ` | 1/1 | 1/1 | Inventory(Ship req) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `R_SCP_PROD_PLAN` | 1/1 | 1/1 | SCP Target (Coater) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `R_SCP_SHIP_PLAN_ETA` | 1/1 | 1/1 | SCP Target (Shipping Target ETA) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `R_SHIP_PLAN_ETD` | 1/1 | 1/1 | Shipment Plan(Out) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `R_SHIP_REQ_ETA` | 1/1 | 1/1 | Shipment Request (ETA) | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `S` | 1/1 | 1/1 | S) 차량판매[R+P] | {'Y': 2} | {'Y': 1} | - | - |
| `SAFETY_STOCK` | 1/1 | 1/1 | Safety Stock level | {'Y': 2} | {'N': 2} | {'252,213,180': 2} | - |
| `SALESAMT_CUR` | 1/1 | 1/1 | Sales Amount(Cur.) | {'Y': 2} | {'Y': 2} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `SALESAMT_KRW` | 12/10 | 12/10 | Sales Amt.(KRW) | {'Y': 24} | {'Y': 24} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `SALESAMT_KRW_40` | 2/2 | 2/2 | Sales Amt.(KRW) | {'Y': 4} | {'Y': 4} | - | - |
| `SALESAMT_KRW_CATCH_UP` | 2/2 | 3/3 | Sales Amt.(KRW)_Catch Up | {'N': 3, 'Y': 2} | {'N': 1, 'Y': 4} | - | 40 |
| `SALESAMT_KRW_USER` | 1/1 | 0/0 | SalesAmt.(KRW)_User | {'N': 1} | {'Y': 1} | - | 40 |
| `SALESAMT_LOC` | 11/9 | 11/9 | Sales Amt.(LOC) | {'Y': 22} | {'Y': 22} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `SALESAMT_LOC_40` | 2/2 | 2/2 | Sales Amt.(LOC) | {'Y': 4} | {'Y': 4} | - | - |
| `SALESAMT_LOC_CATCH_UP` | 2/2 | 3/3 | Sales Amt.(LOC)_Catch Up | {'N': 3, 'Y': 2} | {'N': 1, 'Y': 4} | - | 40 |
| `SALESAMT_LOC_USER` | 0/0 | 1/1 | Sales Amt.(LOC)_User | {'Y': 1} | {'Y': 1} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `SALESAMT_USD` | 10/8 | 10/8 | Sales Amt.(USD) | {'N': 6, 'Y': 14} | {'Y': 20} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `SALESAMT_USD_40` | 2/2 | 2/2 | Sales Amt.(USD) | {'Y': 4} | {'Y': 4} | - | - |
| `SALESAMT_USD_CATCH_UP` | 2/2 | 2/2 | Sales Amt.(USD)_Catch Up | {'N': 2, 'Y': 2} | {'Y': 4} | - | 40 |
| `SCM_FCST` | 4/4 | 4/4 | SCM FCST[R+P] | {'Y': 8} | {'Y': 8} | - | 40 |
| `SCP_PLAN` | 3/3 | 3/3 | SCP Plan | {'Y': 6} | {'N': 4, 'Y': 2} | - | - |
| `SCP_PLAN_VERSION_A` | 1/1 | 1/1 | SCP PLAN_Version A | {'Y': 2} | {'N': 2} | - | - |
| `SCP_PLAN_VERSION_B` | 1/1 | 1/1 | SCP PLAN_Version B | {'Y': 2} | {'N': 2} | - | - |
| `SCP_PROD_PLAN` | 7/2 | 16/2 | SCP Production Plan | {'Y': 23} | {'Y': 16} | - | - |
| `SCP_PROD_PLAN_DDN` | 4/1 | 7/1 | Days of Availability Time | {'Y': 11} | {'Y': 7} | - | - |
| `SCP_SHIP_PLAN` | 8/4 | 8/4 | SCP Ship Plan | {'Y': 16} | {'Y': 16} | {'228,223,236': 12, '252,213,180': 4} | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `SD_RT` | 7/2 | 16/2 | Rate of Shut Down | {'Y': 23} | {'Y': 16} | - | - |
| `SEMI_INTRANSIT` | 5/5 | 6/6 | Semi Intransit | {'Y': 11} | {'N': 6, 'Y': 4} | {'239,239,239': 2} | CELL |
| `SEMI_INTRANSIT_ETA` | 4/4 | 4/4 | Semi In-Transit(ETA) | {'Y': 8} | {'N': 6, 'Y': 1} | - | CELL |
| `SEMI_PACK_PROD_CELL` | 2/2 | 2/2 | Production(Cell) | {'Y': 4} | {'N': 4} | - | CELL |
| `SEMI_SHIP_PLAN` | 5/5 | 7/7 | Semi Ship Plan | {'Y': 12} | {'N': 7, 'Y': 4} | {'219,229,241': 3} | CELL |
| `SEMI_SHIP_PLAN_ETA` | 4/4 | 4/4 | Semi Ship Plan(ETA) | {'Y': 8} | {'N': 6, 'Y': 1} | {'237,248,170': 2} | CELL |
| `SEMI_SHIP_REQ` | 2/2 | 2/2 | Semi Ship Req | {'Y': 4} | {'N': 4} | - | CELL |
| `SEMI_WHIN` | 4/4 | 5/5 | Semi WH In | {'Y': 9} | {'N': 6, 'Y': 3} | - | CELL |
| `SEMI_WHIN_TOTAL` | 4/4 | 4/4 | Semi WH In(Sum) | {'Y': 8} | {'N': 6, 'Y': 1} | {'252,213,180': 2} | CELL |
| `SEMI_WH_IN` | 2/2 | 2/2 | Semi WH In | {'Y': 4} | {'Y': 4} | - | - |
| `SEMU_WHIN2` | 0/0 | 1/1 | Semi WH In2 | {'Y': 1} | {'Y': 1} | - | - |
| `SFA` | 6/6 | 5/5 | SFA(%) | {'N': 9, 'Y': 2} | {'N': 1, 'Y': 10} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `SHIPMENT_PLAN` | 1/1 | 1/1 | ATP(Available To Promise) | {'N': 2} | {'Y': 2} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `SHIP_AVAILABLE` | 2/2 | 2/2 | Ship_Available(CNTR) | {'Y': 4} | {'N': 2, 'Y': 2} | - | CELL |
| `SHIP_AVAL` | 2/2 | 2/2 | Ship Available | {'N': 2, 'Y': 2} | {'Y': 4} | {'242,242,242': 4} | - |
| `SHIP_AVAL_GAP` | 2/2 | 2/2 | └Gap(Ship Available vs. Shipment Plan) | {'N': 2, 'Y': 2} | {'Y': 4} | {'242,242,242': 4} | - |
| `SHIP_BALANCE` | 1/1 | 1/1 | Shipping Balance | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `SHIP_CONFIRM` | 7/5 | 7/5 | Shipment Confirm | {'Y': 14} | {'Y': 14} | {'242,242,242': 2} | - |
| `SHIP_EXPECTED` | 1/1 | 1/1 | Ship_Expected(Box) | {'Y': 2} | {'Y': 2} | - | - |
| `SHIP_PLAN` | 40/32 | 41/33 | Ship Plan | {'Y': 81} | {'N': 18, 'Y': 62} | {'163,255,194': 2, '219,229,241': 23, '242,242,242': 4} | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82,?? |
| `SHIP_PLAN_AMEND` | 12/8 | 12/8 | Ship Plan Amend | {'Y': 24} | {'N': 2, 'Y': 22} | - | - |
| `SHIP_PLAN_AMEND_CELL_QTY` | 4/4 | 4/4 | Ship Plan Amend(Cell Qty) | {'Y': 8} | {'Y': 8} | - | - |
| `SHIP_PLAN_AMEND_ENERGY` | 1/1 | 1/1 | Ship Plan Amend (MWh) | {'Y': 2} | {'Y': 2} | - | - |
| `SHIP_PLAN_CELL_QTY` | 4/4 | 4/4 | Ship Plan(Cell Qty) | {'Y': 8} | {'Y': 8} | - | - |
| `SHIP_PLAN_DETAIL` | 1/1 | 1/1 | Shipment Plan | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `SHIP_PLAN_ENERGY` | 1/1 | 1/1 | Ship Plan (MWh) | {'Y': 2} | {'Y': 2} | - | - |
| `SHIP_PLAN_ETA` | 4/4 | 4/4 | Ship Plan(ETA) | {'Y': 8} | {'N': 6, 'Y': 1} | {'237,248,170': 2} | ?? |
| `SHIP_PLAN_PLANT` | 4/4 | 4/4 | Ship Plan(Plant Sum) | {'Y': 8} | {'N': 6, 'Y': 1} | {'252,213,180': 2} | ?? |
| `SHIP_PLAN_RTF` | 1/1 | 1/1 | Ship. Plan(RTF) | {'Y': 2} | {'Y': 2} | - | - |
| `SHIP_PLAN_SEMI` | 1/1 | 1/1 | Ship. Plan(Semi) | {'Y': 2} | {'Y': 2} | - | - |
| `SHIP_PLAN_TOTAL` | 3/3 | 3/3 | SUM | {'Y': 6} | {'N': 6} | - | TOTAL |
| `SHIP_PLAN_WH_IN` | 1/1 | 1/1 | Ship plan (WH In) | {'Y': 2} | {'Y': 2} | - | - |
| `SHIP_REQ` | 40/30 | 40/30 | Ship Req | {'Y': 80} | {'N': 22, 'Y': 58} | {'215,227,188': 20, '242,242,242': 4} | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82,??,TOTAL |
| `SHIP_REQ_CELL` | 1/1 | 1/1 | Ship Req Cell | {'Y': 2} | {'N': 2} | - | CELL |
| `SHIP_REQ_CELL_QTY` | 4/4 | 4/4 | Ship Req(Cell Qty) | {'Y': 8} | {'Y': 8} | - | - |
| `SHIP_REQ_CELL_SHORT` | 1/1 | 1/1 | Ship Req(Cell-Short) | {'Y': 2} | {'N': 2} | - | CELL |
| `SHIP_REQ_CELL_TOTAL` | 2/2 | 2/2 | Ship Req Total | {'Y': 4} | {'N': 4} | - | CELL |
| `SHIP_REQ_PACK` | 1/1 | 1/1 | Ship Req Pack | {'Y': 2} | {'N': 2} | - | CELL |
| `SHIP_REQ_PACK_SHORT` | 1/1 | 1/1 | Ship Req(Pack-Short) | {'Y': 2} | {'N': 2} | - | CELL |
| `SHIP_REQ_PACK_TOTAL` | 2/2 | 2/2 | Ship Req Total | {'Y': 4} | {'N': 4} | - | ITEM_ID |
| `SHIP_REQ_TOTAL` | 1/1 | 1/1 | Ship Req Total | {'Y': 2} | {'N': 2} | - | CELL |
| `SHIP_RESULT` | 1/1 | 1/1 | Shipment Result | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `SITE_MOVE` | 4/4 | 4/4 | Site-Move Plan | {'Y': 8} | {'Y': 8} | {'219,229,241': 8} | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `SS_GAP` | 1/1 | 1/1 | GAP | {'N': 2} | {'Y': 2} | - | 81,81_HD,81_HG,81_HM,81_ST,81_UC |
| `SS_LVL` | 1/1 | 1/1 | SAFETY_STOCK_LEVEL | {'N': 2} | {'Y': 2} | - | 81,81_HD,81_HG,81_HM,81_ST,81_UC |
| `STANDARD_AMT` | 1/1 | 1/1 | Standard Amount | {'Y': 2} | {'Y': 2} | - | - |
| `STANDARD_DIO` | 1/1 | 1/1 | Standard DIO | {'Y': 2} | {'Y': 2} | - | - |
| `STANDARD_DIO_CHANGE` | 1/1 | 1/1 | 기준DIO 변동(L/T, 주기 등) | {'Y': 2} | {'Y': 1} | - | - |
| `STANDARD_DIO_CHANGE_OTHER` | 1/1 | 1/1 | 기준DIO 변동(기타) | {'Y': 2} | {'Y': 1} | - | - |
| `STANDARD_QTY` | 1/1 | 1/1 | Standard Qty | {'Y': 2} | {'Y': 2} | - | - |
| `STD_DIO` | 1/1 | 2/2 | STD_DIO | {'Y': 3} | {'Y': 3} | - | - |
| `STD_DIO_CELL` | 1/1 | 2/2 | STD_DIO | {'Y': 3} | {'Y': 3} | - | - |
| `STD_DIO_PACK` | 1/1 | 2/2 | STD_DIO | {'Y': 3} | {'Y': 3} | - | - |
| `STD_DIO_SALES` | 1/1 | 2/2 | STD_DIO | {'Y': 3} | {'Y': 3} | - | - |
| `STOCK_BNP` | 1/1 | 1/1 | WH | {'Y': 2} | {'Y': 2} | - | - |
| `STOCK_PW` | 1/1 | 1/1 | Packer | {'Y': 2} | {'Y': 2} | - | - |
| `STOCK_RESERVE` | 1/1 | 1/1 | 재고 비축 | {'Y': 2} | {'Y': 1} | - | - |
| `STOCK_SHIP` | 1/1 | 1/1 | Intransi | {'Y': 2} | {'Y': 2} | - | - |
| `SUM` | 1/1 | 1/1 | 합계 | {'Y': 2} | {'Y': 1} | - | - |
| `SUPPLY_PLAN` | 1/1 | 1/1 | Supply Plan (MOP) | {'Y': 2} | {'N': 2} | - | - |
| `SW_CNV_RT` | 1/1 | 1/1 | 표준폭환산자 | {'Y': 2} | {'Y': 1} | - | - |
| `TACT_TIME` | 1/1 | 4/2 | Tact Time (대당 평균) | {'Y': 5} | {'Y': 4} | - | - |
| `TD_RT` | 7/2 | 16/2 | Rate of Test/Development | {'Y': 23} | {'Y': 16} | - | - |
| `TEEP` | 6/2 | 13/2 | Total Effective Equipment Performance | {'Y': 19} | {'Y': 13} | - | - |
| `THRY_CAPA_D` | 6/2 | 13/2 | Daily Theory Capacity | {'Y': 19} | {'Y': 13} | - | - |
| `TMM_FCST` | 5/5 | 5/5 | TMM [P+P] | {'N': 10} | {'N': 1, 'Y': 9} | - | 81,81_HD,81_HG,81_HM,81_ST,81_UC |
| `TOTAL` | 1/1 | 1/1 | Total | {'Y': 2} | {'Y': 1} | - | 40 |
| `TOTAL INV` | 1/1 | 0/0 | TOT_INV | {'N': 1} | {'N': 1} | - | - |
| `TOTAL_PLAN` | 8/4 | 8/4 | Total(Plan) | {'Y': 16} | {'Y': 16} | {'219,229,241': 16} | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `TOTAL_REQ` | 8/4 | 8/4 | Total(Req) | {'Y': 16} | {'Y': 16} | {'219,229,241': 16} | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `TOT_BALANCE` | 1/1 | 1/1 | Total Balance | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `TOT_CONTAINER` | 1/1 | 1/1 | Total Container Qty | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `TOT_INTN_MOVEMENT` | 1/1 | 1/1 | Total Internal movement | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `TOT_INV` | 1/1 | 2/2 | Total Inv | {'Y': 3} | {'Y': 3} | - | - |
| `TOT_PROD_PLAN` | 1/1 | 1/1 | Total Production | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `TOT_SHIP_AVAL` | 1/1 | 1/1 | Total Ship Available | {'N': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `TOT_SHIP_AVAL_GAP` | 1/1 | 1/1 | └Total Gap(Ship Available vs. Shipment Plan) | {'N': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `TOT_SHIP_PLAN` | 1/1 | 1/1 | Total Shipment Plan[R+P] | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `TOT_SHIP_REQ` | 1/1 | 1/1 | Total Shipment Request | {'Y': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `TOT_WH_STOCK` | 1/1 | 1/1 | Total Warehouse Stock | {'N': 2} | {'Y': 2} | {'242,242,242': 2} | - |
| `TO_SITE_BOH` | 5/5 | 5/5 | BOH | {'Y': 10} | {'N': 8, 'Y': 1} | - | ??,TOTAL |
| `TO_SITE_EOH` | 6/6 | 7/7 | EOH | {'Y': 13} | {'N': 8, 'Y': 4} | {'225,213,222': 2, '239,239,239': 2} | ??,TOTAL |
| `TTT` | 1/1 | 2/1 | Tact Time | {'Y': 3} | {'Y': 2} | {'192,192,192': 2} | - |
| `UD_RT` | 6/2 | 13/2 | UT/IT Down | {'Y': 19} | {'Y': 13} | - | - |
| `USAGE` | 1/1 | 1/1 | Usage | {'Y': 2} | {'Y': 2} | - | - |
| `USD` | 12/10 | 12/10 | Unit Price(USD) | {'N': 14, 'Y': 10} | {'Y': 24} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `USER_SALESAMT_KRW2` | 2/2 | 2/2 | Sales Amt..(KRW) | {'Y': 4} | {'Y': 4} | - | - |
| `USER_SALESAMT_LOC2` | 2/2 | 2/2 | Sales Amt..(LOC) | {'Y': 4} | {'Y': 4} | - | - |
| `USER_SALESAMT_USD2` | 2/2 | 2/2 | Sales Amt..(USD) | {'Y': 4} | {'Y': 4} | - | - |
| `VMI_DIO` | 1/1 | 2/2 | DIO | {'N': 3} | {'Y': 3} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `VMI_INV` | 4/4 | 3/3 | VMI Inv. | {'N': 7} | {'N': 1, 'Y': 6} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `VMI_INV_TEST` | 1/1 | 1/1 | VMI Inv_System. | {'N': 2} | {'Y': 2} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC |
| `VMI_IN_PLAN` | 5/5 | 4/4 | VMI-In Plan[R+P] | {'N': 9} | {'N': 1, 'Y': 8} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `VMI_IN_PLAN_TEST` | 1/1 | 1/1 | VMI-In Plan_System[R+P] | {'N': 2} | {'Y': 2} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC |
| `VMI_IN_REQ` | 5/5 | 4/4 | VMI-In Request[R+P] | {'N': 9} | {'N': 1, 'Y': 8} | - | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `W1_FCST` | 1/1 | 1/1 | Sales Fcst W-1 | {'N': 2} | {'Y': 2} | - | - |
| `W1_WPP` | 1/1 | 1/1 | WPP-1 | {'N': 2} | {'Y': 2} | - | - |
| `W2_CUST_FCST` | 1/1 | 1/1 | Cust Fcst W-2 | {'N': 2} | {'Y': 2} | - | - |
| `W2_FCST` | 1/1 | 1/1 | Sales Fcst W-2 | {'N': 2} | {'Y': 2} | - | - |
| `W2_WPP` | 1/1 | 1/1 | WPP-2 | {'N': 2} | {'Y': 2} | - | - |
| `WHIN` | 4/4 | 5/5 | WH In | {'Y': 9} | {'N': 6, 'Y': 3} | - | ?? |
| `WHIN_BALANCE` | 3/3 | 3/3 | Balance(WH In) | {'Y': 6} | {'N': 6} | - | ?? |
| `WHIN_TOTAL` | 5/5 | 5/5 | WH In(Sum) | {'Y': 10} | {'N': 8, 'Y': 1} | {'252,213,180': 2} | ??,TOTAL |
| `WH_BOH_PLAN` | 10/6 | 10/6 | W/H BOH(Plan) | {'Y': 20} | {'N': 4, 'Y': 16} | {'219,229,241': 20} | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `WH_BOH_REQ` | 10/6 | 10/6 | W/H BOH(Req) | {'Y': 20} | {'N': 4, 'Y': 16} | {'219,229,241': 20} | 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 |
| `WH_IN` | 14/13 | 13/12 | WH In | {'Y': 27} | {'N': 2, 'Y': 25} | {'219,229,241': 2} | 40 |
| `WH_IN_BALANCE` | 7/7 | 7/7 | Balance(WH In) | {'Y': 14} | {'N': 10, 'Y': 4} | - | - |
| `WH_IN_TOTAL` | 1/1 | 1/1 | WH In Total | {'Y': 2} | {'Y': 2} | - | - |
| `WH_STOCK` | 7/5 | 7/5 | Warehouse Stock | {'N': 2, 'Y': 12} | {'Y': 14} | {'242,242,242': 4} | - |
| `WPP` | 1/1 | 1/1 | WPP | {'Y': 2} | {'Y': 2} | - | - |
| `WT_RT` | 7/2 | 16/2 | Rate of No Production(Wait for Order) | {'Y': 23} | {'Y': 16} | - | - |
| `YD` | 0/0 | 1/1 | yd | {'Y': 1} | {'Y': 1} | - | - |
| `YIELD` | 2/2 | 2/2 | Yield | {'Y': 4} | {'N': 2, 'Y': 2} | - | - |
| `YIELD_A` | 1/1 | 1/1 | Yield_A | {'Y': 2} | {'Y': 2} | - | - |
| `YIELD_E` | 1/1 | 1/1 | Yield_E | {'Y': 2} | {'Y': 2} | - | - |
| `Y_SUM` | 2/2 | 2/2 | Y SUM | {'Y': 4} | {'N': 4} | - | TOTAL |
| `천$` | 1/1 | 1/1 | 천$ | {'Y': 2} | {'Y': 1} | - | 40 |
| `천셀` | 1/1 | 1/1 | 천셀 | {'N': 2} | {'Y': 1} | - | 40 |
| `천팩` | 1/1 | 1/1 | 천팩 | {'Y': 2} | {'Y': 1} | - | 40 |
