# -*- coding: utf-8 -*-
"""사내 PKG_DMF0005 BODY 의 판본 마커 출현 수 — C01 [E2] CORP 열 기준값 산출용 (읽기 전용)."""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

MARKERS = [
    "PERF-DMF0005 20260722", "optimizer_dynamic_sampling = 2", "2026.09.08 AJS", "2026.09.11 AJS", "2026.09.17 AJS",
    "2026.09.30 AJS", "2026.10.08 POJ", "2026.10.09 POJ", "E20261013-DMF0005MCDUP", "E20261014-DMF0005PARTIALGET",
    "UNISTR('\\3000')", "OWNER_NAME_KO", "FN_GET_MULTI_OWNER_NAME(", "FN_SPLITSTRING(", "FN_GET_DEPT_LIST(",
    "GT_GGET_SPLIT_", "DM_MST_ITEM_SINGLE_V", "SELECT CO.COUNTRY_NAME FROM SCM_MST_COUNTRY",
]
u, p, d = conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0005' AND type='PACKAGE BODY' ORDER BY line")
    src = "".join(r[0] for r in cur)
    print("lines", src.count("\n"), "chars", len(src))
    for m in MARKERS:
        print(f"{src.count(m):4d}  {m}")
