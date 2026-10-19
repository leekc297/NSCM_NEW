# -*- coding: utf-8 -*-
"""
Phase 4 — 기준정보·IF STEP 의 등록값 명세 (데이터 많은 ITEM 기준 5건씩)

DB 변경 없음. 각 STEP 이 다루는 원장에서 **실존 레코드 5건**을 뽑아
"어느 테이블에 어떤 키·값을 등록/수신하는지" 를 문자열로 만든다.

대상 (탐색 실측으로 화면·테이블 확정)
  SSPM                 DMF0005  SCM_MST_SITE_ITEM
  N:N Master Mapping   DMF0072  DM_CUST_MODEL_MAPPING_M
  Customer FCST Master DMF0007  DM_MST_CUSTOMER_FCST
  Customer FCST Mapping DMF0006 DM_MST_CUSTOMER_MODEL     (※ 명칭 근사 — 추정)
  실적 IF              (IF)     DM_DNM_SALES_RESULT_IF
  EDI Call-off IF      (IF)     DM_DNM_EDI_CALLOFF_ITEM
  재고 Data IF         (IF)     DM_PLN_MKT_FCST_RESULT(VMI_Inv)  ※ SCM_DNM_STOCK_VMI 는 81 전용
"""
import re
import json
import pathlib
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

D = pathlib.Path(__file__).resolve().parent
N = 5


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
    m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


# STEP 키 -> (테이블, 키컬럼들, 정렬근거컬럼, division 컬럼 유무)
SPEC = {
    "SSPM": ("SCM_MST_SITE_ITEM",
             ["PROJECT_CODE", "SCM_SITE_ID", "ITEM_ID"],
             ["CURRENCY", "DEPT_ID", "OWNER", "CUST_GROUP", "APPLICATION", "ROUTE",
              "LIABILITY_PERIOD", "INVENTORY_DAY"], True),
    "NN":   ("DM_CUST_MODEL_MAPPING_M",
             ["DATA_TYPE_CODE", "SOLDTO_CODE", "SHIPTO_CODE", "CUSTOMER_ITEM_ID",
              "SCM_SITE_ID", "PROJECT_CODE", "ITEM_ID"],
             ["FCST_TYPE", "INCOTERMS", "DOM_EXP", "MAPPING_ITEM_ID"], True),
    "CFM":  ("DM_MST_CUSTOMER_FCST",
             ["PLAN_WEEK", "CUSTOMER_CODE", "SCM_SITE_ID", "MEASURE_GROUP", "MEASURE"],
             ["SUMMARY_BUCKET_VALUE", "CUSTOMER_PSI", "QTY"], True),
    "CMM":  ("DM_MST_CUSTOMER_MODEL",
             ["CUSTOMER_CODE", "CUSTOMER_ITEM_ID", "ITEM_ID"],
             ["SCM_SITE_ID", "PROJECT_CODE"], True),
    "RSLT": ("DM_DNM_SALES_RESULT_IF", None, None, True),
    "EDI":  ("DM_DNM_EDI_CALLOFF_ITEM", None, None, True),
    # 82 재고 축 — SCM_DNM_STOCK_VMI 는 81 전용이라 82 가 0건. VMI_Inv 실적 원장으로 대체.
    "VMI":  ("DM_PLN_MKT_FCST_RESULT", None, None, True),
}


def cols_of(cur, tbl):
    cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                    AND TABLE_NAME=:t ORDER BY COLUMN_ID""", t=tbl)
    return [r[0] for r in cur]


out = {}
with conn() as db:
    cur = db.cursor()
    for key, (tbl, kcols, vcols, has_div) in SPEC.items():
        have = cols_of(cur, tbl)
        if not have:
            print("{:5s} {:30s} — 테이블 없음".format(key, tbl)); continue
        # 키/값 컬럼 미지정이면 실존 컬럼에서 자동 선정
        if kcols is None:
            kcols = [c for c in ("ITEM_ID", "SCM_SITE_ID", "PROJECT_CODE", "CUSTOMER_CODE",
                                 "CUSTOMER_ITEM_ID", "PLANT_CODE", "LOCATION_ID") if c in have][:4]
        if vcols is None:
            vcols = [c for c in ("QTY", "STOCK_QTY", "AMOUNT", "YYYYMMDD", "DELIVERY_DATE",
                                 "CREATION_DATE", "MEASURE", "FCST_TYPE") if c in have][:4]
        kcols = [c for c in kcols if c in have]
        vcols = [c for c in vcols if c in have]
        div_col = "DIVISION_ID" in have
        out[key] = {"table": tbl, "key_cols": kcols, "val_cols": vcols, "by_div": {}}
        for div in ("40", "81", "82"):
            if not div_col:
                out[key]["by_div"][div] = []
                continue
            sel = ", ".join(kcols + vcols)
            order = "ORDER BY {} DESC".format(kcols[0]) if kcols else ""
            # 대형 IF 테이블(EDI 3.4M / 재고 2.7M)에 윈도우 함수를 쓰면 수 분 이상 걸린다.
            # 키 중복은 파이썬에서 제거하고 SQL 은 단순 스캔 + 조기 종료로 끝낸다.
            try:
                extra = " AND MEASURE = 'VMI_Inv'" if key == "VMI" else ""
                cur.execute("SELECT {s} FROM SCM_MGR.{t} WHERE DIVISION_ID = :d{e} "
                            "AND ROWNUM <= 4000".format(s=sel, t=tbl, e=extra), d=div)
                seen, rows = set(), []
                for r in cur:
                    d0 = dict(zip(kcols + vcols, r))
                    kk = tuple(str(d0.get(c)) for c in kcols)
                    if kk in seen:
                        continue
                    seen.add(kk)
                    rows.append(d0)
                    if len(rows) >= N:
                        break
            except Exception as e:
                rows = []
                print("   {:5s} DIV {} ERR {}".format(key, div, str(e)[:60]))
            out[key]["by_div"][div] = rows
        cnt = {d: len(v) for d, v in out[key]["by_div"].items()}
        print("{:5s} {:30s} 키={:42s} {}".format(key, tbl, ",".join(kcols)[:42], cnt))

(D / "12_master_if.json").write_text(json.dumps(out, ensure_ascii=False, indent=1, default=str),
                                     encoding="utf-8")
print("\n12_master_if.json 저장")
