# -*- coding: utf-8 -*-
"""
Phase 1 — Step No 정의 (단일 원천)

원본: C:\TRANFILE\RECEIVE\DM_통합테스트_SampleData_20260918.xlsx (읽기 전용)
각 Step No 에 화면 ID · 대상원장 · 권한그룹 · 입력 MEASURE · 오전 생성분 단계ID 를 결합한다.

화면 확정 근거 — SCM_ADM_MNU_M × SCM_ADM_MSG_M 실측 (2026-09-18)
  SSPM                 = DMF0005 Sales Site Project Model  → SCM_MST_SITE_ITEM
  N:N Master Mapping   = DMF0072 N: N Master Mapping        → DM_CUST_MODEL_MAPPING_M
  Customer FCST Master = DMF0007 Customer FCST Master       → DM_MST_CUSTOMER_FCST
  Customer FCST Mapping= DMF0007 Customer FCST Master       → DM_MST_CUSTOMER_FCST   (사용자 정정 2026-09-18)
  Customer FCST Upload = DMF0014                            → DM_PLN_MKT_FCST
  Sales Price          = DMF0020                            → SCM_MST_FUTURE_PRICE
저장대상 테이블은 각 PKG_DMFxxxx BODY 원문의 INSERT/MERGE/UPDATE 대상 추출로 확정.

원장 정정 3건 (탐색 실측 2026-09-18)
  · DMF0014 는 `DM_PLN_CUSTOMER_PSI` 에 **직접** 쓴다. `DM_PLN_MKT_FCST` 전이는 후속 배치
    `PR_DM_PLN_CUST_FCST_TO_MKT_FCST` 가 수행 → 검증은 **2단계 분리** 필요
  · 실적 IF 는 `XIF_ERP_SALES_RESULT_R_SN → DM_DNM_SALES_RESULT_IF`(PR_DM_DNM_SALES_RESULT_IF)
    → `PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING` → `DM_PLN_MKT_FCST_RESULT`/`DM_PLN_SALES_PLAN_RESULT`
  · 82 재고 IF — 수신표 `SCM_DNM_STOCK_VMI` 는 **81 전용**이다(2,750,711행 전부 81, 82 는 0건).
    82 의 실측 가능한 재고 축은 `DM_PLN_MKT_FCST_RESULT(MEASURE='VMI_Inv')` 60,659행이고,
    VMI Refresh(`PR_DM_PLN_ESS_VMI_REFRESH`, DIVISION='82' 하드코딩)가
    `DM_PLN_MKT_FCST(MEASURE='VMI_In_Req')` 2,124행을 생성한다.

Customer FCST Mapping(81 4-2) = **DMF0007 Customer FCST Master** (사용자 정정 2026-09-18).
   DMF0007 은 조회 2종(`GET_CUST_FCST_DATA` / `GET_CUST_PSI_DATA`)을 가진 탭 구성이고,
   `DM_MST_CUSTOMER_MODEL` 은 **전혀 쓰지 않는다**(읽기 0 / 쓰기 0 실측) — 초기 DMF0006 추정은 폐기.

82 6-1/6-2 : 엑셀 항목은 'UI : FCST&PRICE MGMT'(DMF0082)이나
   **DMF0082 의 저장 권한은 40 · 81 division 뿐**이다(사용자 확인 2026-09-18).
   82 는 조회 전용(V82-00)이므로 실제화면 = **DMF0003** 으로 처리한다.
⚠ 82 판가입력 2행은 원본에서 StepNo 가 둘 다 '5-1' → 5-1/5-2 로 분리 (사용자 확정).
"""

SRC_XLSX = r"C:\TRANFILE\RECEIVE\DM_통합테스트_SampleData_20260918.xlsx"

# (DIV, StepNo, 샘플, 화면ID, 실제화면, 대상원장, 권한그룹들, 입력MEASURE, 오전단계ID들, 성격)
#   성격 : UI / 기준정보 / IF / 배치 / 검증
STEPS = [
 # ── 40 ────────────────────────────────────────────────────────────────────
 ("40", "1-1",  "Y", "DMF0005", "DMF0005", "SCM_MST_SITE_ITEM",
  ["기준정보 관리"], "-", [], "기준정보"),
 ("40", "3-1",  "Y", "(IF)",    "(IF)",    "DM_DNM_SALES_RESULT_IF → DM_PLN_MKT_FCST_RESULT / DM_PLN_SALES_PLAN_RESULT",
  ["-"], "실적수량", [], "IF"),
 ("40", "4-1",  "Y", "DMF0082", "DMF0082", "DM_PLN_CFM_SELLING_PRICE, DM_PLN_MKT_FCST",
  ["DM Planner"], "LOC(단가) / MKT_FCST", ["S40-01", "S40-02"], "UI"),
 ("40", "6-1",  "Y", "DMF0082", "DMF0082", "DM_PLN_MKT_FCST",
  ["SCP Planner"], "SCM_FCST", ["S40-03"], "UI"),
 ("40", "10-1", "Y", "DMF0021", "DMF0021", "DM_PLN_SALES_PLAN",
  ["DM Planner", "SCP Planner"], "SalesAmt_LOC / RTF_SYS_RP", ["S40-06", "S40-07"], "UI"),
 ("40", "12-1", "N", "DMF0044", "DMF0044", "-",
  ["DM Planner"], "관리대상(Report)", ["S40-09"], "UI"),
 ("40", "12-2", "N", "DMF0049", "DMF0049", "-",
  ["DM ADMIN/ADMIN"], "관리대상(Etc Report)", ["S40-10"], "UI"),
 ("40", "13-1", "N", "DMF0042", "DMF0042", "DM_PLN_BIZPLAN",
  ["DM Planner"], "BIZ PLAN 관리대상", ["S40-11"], "UI"),
 ("40", "14-1", "N", "DMF0035", "DMF0035", "-",
  ["-"], "MKT FCST / SALES PLAN / BIZ PLAN", ["S40-12"], "검증"),

 # ── 81 ────────────────────────────────────────────────────────────────────
 ("81", "1-1",  "Y", "DMF0005", "DMF0005", "SCM_MST_SITE_ITEM",
  ["기준정보 관리"], "-", [], "기준정보"),
 ("81", "3-1",  "Y", "DMF0072", "DMF0072", "DM_CUST_MODEL_MAPPING_M",
  ["기준정보 관리"], "-", [], "기준정보"),
 ("81", "3-2",  "Y", "(IF)",    "(IF)",    "DM_DNM_EDI_CALLOFF_HEAD/PARTNER/ITEM → DM_PLN_MKT_FCST(CUST_FCST_EDI)",
  ["-"], "CUST_FCST_EDI", ["S81-01"], "IF"),
 ("81", "4-1",  "Y", "DMF0007", "DMF0007", "DM_MST_CUSTOMER_FCST",
  ["기준정보 관리"], "-", [], "기준정보"),
 ("81", "4-2",  "Y", "DMF0007", "DMF0007", "DM_MST_CUSTOMER_FCST",
  ["기준정보 관리"], "-", [], "기준정보"),   # 사용자 정정 2026-09-18 — Cust FCST Master
 ("81", "4-3",  "Y", "DMF0014", "DMF0014", "DM_PLN_CUSTOMER_PSI → (배치) DM_PLN_MKT_FCST",
  ["DM Planner"], "CUST_FCST", ["S81-02"], "UI"),
 ("81", "5-1",  "Y", "(IF)",    "(IF)",    "DM_DNM_SALES_RESULT_IF → DM_PLN_MKT_FCST_RESULT / DM_PLN_SALES_PLAN_RESULT",
  ["-"], "실적수량", [], "IF"),
 ("81", "6-1",  "Y", "DMF0082", "DMF0082", "SCM_MST_FUTURE_PRICE, DM_PLN_MKT_FCST",
  ["DM Planner"], "LOC(단가) / MKT_FCST", ["S81-03", "S81-04"], "UI"),
 ("81", "6-2",  "Y", "DMF0082", "DMF0082", "DM_PLN_MKT_FCST",
  ["DM Planner (W/S)"], "MKT_FCST", ["S81-05"], "UI"),
 ("81", "8-1",  "Y", "DMF0082", "DMF0082", "DM_PLN_MKT_FCST",
  ["SCP Planner"], "SCM_FCST", ["S81-06"], "UI"),
 ("81", "12-1", "Y", "DMF0021", "DMF0021", "DM_PLN_SALES_PLAN",
  ["DM Planner", "SCP Planner"], "SalesAmt_LOC / RTF_SYS_RP", ["S81-08", "S81-09"], "UI"),
 ("81", "14-1", "N", "DMF0035", "DMF0035", "-",
  ["-"], "MKT FCST / SALES PLAN", ["S81-11"], "검증"),

 # ── 82 ────────────────────────────────────────────────────────────────────
 ("82", "1-1",  "Y", "DMF0005", "DMF0005", "SCM_MST_SITE_ITEM",
  ["기준정보 관리"], "-", [], "기준정보"),
 ("82", "3-1",  "Y", "(IF)",    "(IF)",    "DM_PLN_MKT_FCST_RESULT(VMI_Inv) → (VMI Refresh) → DM_PLN_MKT_FCST(VMI_In_Req)",
  ["-"], "재고", [], "IF"),
 ("82", "4-1",  "Y", "(IF)",    "(IF)",    "DM_DNM_SALES_RESULT_IF → DM_PLN_MKT_FCST_RESULT / DM_PLN_SALES_PLAN_RESULT",
  ["-"], "실적수량", [], "IF"),
 ("82", "5-1",  "Y", "DMF0020", "DMF0020", "SCM_MST_FUTURE_PRICE",
  ["DM Planner"], "LOC/USD/KRW 단가(52주)", ["S82-01"], "UI"),
 ("82", "5-2",  "Y", "DMF0020", "DMF0020", "SCM_MST_FUTURE_PRICE",
  ["ADMIN"], "LOC/USD/KRW 단가(52주)", [], "UI"),
 ("82", "6-1",  "Y", "DMF0082", "DMF0003", "DM_PLN_MKT_FCST",
  ["DM Planner"], "MKT_FCST", ["S82-02"], "UI"),
 ("82", "6-2",  "Y", "DMF0082", "DMF0003", "DM_PLN_MKT_FCST",
  ["DM Planner (W/S)"], "MKT_FCST", ["S82-03"], "UI"),
 ("82", "10-1", "Y", "DMF0021", "DMF0021", "DM_PLN_SALES_PLAN",
  ["DM Planner"], "SalesAmt_LOC", ["S82-05"], "UI"),
 ("82", "12-1", "N", "DMF0035", "DMF0035", "-",
  ["-"], "MKT FCST / SALES PLAN", ["S82-07"], "검증"),
]

# 오전 단계ID -> (DIV, StepNo) 역인덱스
MORNING = {}
for div, sno, smp, scr, real, led, auths, meas, morn, kind in STEPS:
    for mid in morn:
        MORNING[mid] = (div, sno)

# 원본 엑셀 StepNo 중복 정정 (82 판가입력)
STEPNO_FIX = {("82", 2): "5-2"}   # 같은 '5-1' 중 2번째 판가입력 행

SHEET_OF = {"40": "40 DIVISION", "81": "81 DIVISION", "82": "82 DIVISION"}
OUT_SHEET = {"40": "40TestData", "81": "81TestData", "82": "82TestData"}

if __name__ == "__main__":
    print("STEP 정의 {}건".format(len(STEPS)))
    for d in ("40", "81", "82"):
        rows = [s for s in STEPS if s[0] == d]
        smp = [s for s in rows if s[2] == "Y"]
        print("  DIV {} — 총 {:2d} STEP / 샘플 {:2d} / 오전승계 {:2d}".format(
            d, len(rows), len(smp), sum(len(s[8]) for s in rows)))
    print("\n오전 단계ID 매핑 {}건".format(len(MORNING)))
