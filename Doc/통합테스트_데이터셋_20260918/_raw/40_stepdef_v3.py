# -*- coding: utf-8 -*-
"""v3 STEP 정의 — 단일 원천 (10_stepmap.py v1 + 32_build.py v2 병합)

원본 `{40|81|82} DIVISION` 시트의 `샘플 Link`='샘플' 행이 샘플 생성 대상이다.
v1(06) 은 Report/BizPlan/Waterfall 등 `샘플지정='N'` STEP 까지 실었고,
v2(07) 는 샘플 STEP 만 실으면서 RTF 점검(40 9-1 / 81 11-1 / 82 9-1)과
EDI IF 4표(81 3-2a~d)를 신설했다. v3 는 **둘의 합집합**이다.

튜플 = (DIV, StepNo, 샘플지정, 화면(엑셀), 실제화면, 대상원장, [권한그룹],
        입력MEASURE, 구분, LAYOUT키)
LAYOUT키 = 30_layouts.json 키. None = v2 에서 LAYOUT 미수집(=STEP 시트 없음).
"""

STEPS = [
 # ── 40 ───────────────────────────────────────────────────────────────────
 ("40", "1-1",  "Y", "DMF0005", "DMF0005", "SCM_MST_SITE_ITEM",
  ["기준정보 관리"], "-", "기준정보", "40|1-1"),
 ("40", "3-1",  "Y", "(IF)", "(IF)",
  "DM_DNM_SALES_RESULT_IF → DM_PLN_MKT_FCST_RESULT / DM_PLN_SALES_PLAN_RESULT",
  ["-"], "실적수량", "IF", "40|3-1"),
 ("40", "4-1",  "Y", "DMF0082", "DMF0082", "DM_PLN_CFM_SELLING_PRICE, DM_PLN_MKT_FCST",
  ["DM Planner"], "LOC(단가) / MKT_FCST", "UI", "40|4-1"),
 ("40", "6-1",  "Y", "DMF0082", "DMF0082", "DM_PLN_MKT_FCST",
  ["SCP Planner"], "SCM_FCST", "UI", "40|6-1"),
 ("40", "9-1",  "Y", "DMF0082", "DMF0082", "DM_PLN_MKT_FCST(RTF)",
  ["DM Planner", "SCP Planner"], "RTF_SCP / RTF_SYS_RP", "검증", "40|9-1"),
 ("40", "10-1", "Y", "DMF0021", "DMF0021", "DM_PLN_SALES_PLAN",
  ["DM Planner", "SCP Planner"], "SalesAmt_LOC / RTF_SYS_RP", "UI", "40|10-1"),
 ("40", "12-1", "N", "DMF0044", "DMF0044", "-",
  ["DM Planner"], "관리대상(Report)", "UI", None),
 ("40", "12-2", "N", "DMF0049", "DMF0049", "-",
  ["DM ADMIN/ADMIN"], "관리대상(Etc Report)", "UI", None),
 ("40", "13-1", "N", "DMF0042", "DMF0042", "DM_PLN_BIZPLAN",
  ["DM Planner"], "BIZ PLAN 관리대상", "UI", None),
 ("40", "14-1", "N", "DMF0035", "DMF0035", "-",
  ["-"], "MKT FCST / SALES PLAN / BIZ PLAN", "검증", None),

 # ── 81 ───────────────────────────────────────────────────────────────────
 ("81", "1-1",  "Y", "DMF0005", "DMF0005", "SCM_MST_SITE_ITEM",
  ["기준정보 관리"], "-", "기준정보", "81|1-1"),
 ("81", "3-1",  "Y", "DMF0072", "DMF0072", "DM_CUST_MODEL_MAPPING_M",
  ["기준정보 관리"], "-", "기준정보", "81|3-1"),
 ("81", "3-2",  "Y", "(IF)", "(IF)",
  "DM_DNM_EDI_CALLOFF_HEAD/PARTNER/ITEM → DM_PLN_MKT_FCST(CUST_FCST_EDI)",
  ["-"], "CUST_FCST_EDI", "IF", None),
 ("81", "3-2a", "Y", "(IF)", "(IF)", "INF_MGR.XIF_ERP_EDI_CALLOFF_HEAD_R",
  ["-"], "CUST_FCST_EDI", "IF", "81|3-2a"),
 ("81", "3-2b", "Y", "(IF)", "(IF)", "INF_MGR.XIF_ERP_EDI_CALLOFF_ITEM_R",
  ["-"], "CUST_FCST_EDI", "IF", "81|3-2b"),
 ("81", "3-2c", "Y", "(IF)", "(IF)", "INF_MGR.XIF_ERP_EDI_CALLOFF_PARTNER_R",
  ["-"], "CUST_FCST_EDI", "IF", "81|3-2c"),
 ("81", "3-2d", "Y", "(IF)", "(IF)", "INF_MGR.XIF_CUST_DEMAND_MAPPING_MST_R",
  ["-"], "CUST_FCST_EDI", "IF", "81|3-2d"),
 ("81", "4-1",  "Y", "DMF0007", "DMF0007", "DM_MST_CUSTOMER_FCST",
  ["기준정보 관리"], "-", "기준정보", "81|4-1"),
 ("81", "4-2",  "Y", "DMF0007", "DMF0007", "DM_MST_CUSTOMER_FCST",
  ["기준정보 관리"], "-", "기준정보", "81|4-2"),
 ("81", "4-3",  "Y", "DMF0014", "DMF0014", "DM_PLN_CUSTOMER_PSI → (배치) DM_PLN_MKT_FCST",
  ["DM Planner"], "CUST_FCST", "UI", "81|4-3"),
 ("81", "5-1",  "Y", "(IF)", "(IF)",
  "DM_DNM_SALES_RESULT_IF → DM_PLN_MKT_FCST_RESULT / DM_PLN_SALES_PLAN_RESULT",
  ["-"], "실적수량", "IF", "81|5-1"),
 ("81", "6-1",  "Y", "DMF0082", "DMF0082", "SCM_MST_FUTURE_PRICE, DM_PLN_MKT_FCST",
  ["DM Planner"], "LOC(단가) / MKT_FCST", "UI", "81|6-1"),
 ("81", "6-2",  "Y", "DMF0082", "DMF0082", "DM_PLN_MKT_FCST",
  ["DM Planner (W/S)"], "MKT_FCST", "UI", "81|6-2"),
 ("81", "8-1",  "Y", "DMF0082", "DMF0082", "DM_PLN_MKT_FCST",
  ["SCP Planner"], "SCM_FCST", "UI", "81|8-1"),
 ("81", "11-1", "Y", "DMF0082", "DMF0082", "DM_PLN_MKT_FCST(RTF)",
  ["DM Planner", "SCP Planner"], "RTF_SCP / RTF_SYS_RP", "검증", "81|11-1"),
 ("81", "12-1", "Y", "DMF0021", "DMF0021", "DM_PLN_SALES_PLAN",
  ["DM Planner", "SCP Planner"], "SalesAmt_LOC / RTF_SYS_RP", "UI", "81|12-1"),
 ("81", "14-1", "N", "DMF0035", "DMF0035", "-",
  ["-"], "MKT FCST / SALES PLAN", "검증", None),

 # ── 82 ───────────────────────────────────────────────────────────────────
 ("82", "1-1",  "Y", "DMF0005", "DMF0005", "SCM_MST_SITE_ITEM",
  ["기준정보 관리"], "-", "기준정보", "82|1-1"),
 ("82", "3-1",  "Y", "(IF)", "(IF)",
  "DM_PLN_MKT_FCST_RESULT(VMI_Inv) → (VMI Refresh) → DM_PLN_MKT_FCST(VMI_In_Req)",
  ["-"], "재고", "IF", "82|3-1"),
 ("82", "4-1",  "Y", "(IF)", "(IF)",
  "DM_DNM_SALES_RESULT_IF → DM_PLN_MKT_FCST_RESULT / DM_PLN_SALES_PLAN_RESULT",
  ["-"], "실적수량", "IF", "82|4-1"),
 ("82", "5-1",  "Y", "DMF0020", "DMF0020", "SCM_MST_FUTURE_PRICE",
  ["DM Planner"], "LOC/USD/KRW 단가(52주)", "UI", "82|5-1"),
 ("82", "5-2",  "Y", "DMF0020", "DMF0020", "SCM_MST_FUTURE_PRICE",
  ["ADMIN"], "LOC/USD/KRW 단가(52주)", "UI", "82|5-2"),
 ("82", "6-1",  "Y", "DMF0082", "DMF0003", "DM_PLN_MKT_FCST",
  ["DM Planner"], "MKT_FCST", "UI", "82|6-1"),
 ("82", "6-2",  "Y", "DMF0082", "DMF0003", "DM_PLN_MKT_FCST",
  ["DM Planner (W/S)"], "MKT_FCST", "UI", "82|6-2"),
 ("82", "9-1",  "Y", "DMF0003", "DMF0003", "DM_PLN_MKT_FCST(RTF)",
  ["DM Planner"], "RTF_SCP / RTF_SYS_RP", "검증", "82|9-1"),
 ("82", "10-1", "Y", "DMF0021", "DMF0021", "DM_PLN_SALES_PLAN",
  ["DM Planner"], "SalesAmt_LOC", "UI", "82|10-1"),
 ("82", "12-1", "N", "DMF0035", "DMF0035", "-",
  ["-"], "MKT FCST / SALES PLAN", "검증", None),
]

SHEET_OF = {"40": "40 DIVISION", "81": "81 DIVISION", "82": "82 DIVISION"}
OUT_SHEET = {"40": "40TestData", "81": "81TestData", "82": "82TestData"}


def snum(s):
    """StepNo 정렬키 — '3-2a' → (3, 2, 'a')"""
    a, _, b = str(s).partition("-")
    suf = ""
    while b and b[-1].isalpha():
        suf = b[-1] + suf
        b = b[:-1]
    try:
        return (int(a), int(b or 0), suf)
    except ValueError:
        return (999, 999, suf)


if __name__ == "__main__":
    for d in ("40", "81", "82"):
        rs = [s for s in STEPS if s[0] == d]
        print("DIV {} — STEP {:2d} / 샘플 {:2d} / LAYOUT 보유 {:2d}".format(
            d, len(rs), sum(1 for s in rs if s[2] == "Y"),
            sum(1 for s in rs if s[9])))
