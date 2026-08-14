#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""No.65 — 81 Div 컬럼 축 전수 대조 (시트 한정판).

요구 원문: "81 Div 의 MKT FCST 컬럼에서 존재하던 컬럼이 정상적으로 FCST&PRICE MGMT 화면에
           반영되었는지 확인 / 81 Div 는 End Customer 컬럼 미사용, Project 컬럼 사용하는데
           Project 컬럼 자체가 없음 (As-Is 29개 / 현재 21개 항목) / Cust FCST 관련 Measure 없음"

축: AS-IS DMF0003 **'Mkt Fcst' 시트** (81 스코프)  ↔  TO-BE DMF0082 **'FcstNPrice' 시트** (81 스코프)
    ※ AS-IS DMF0003 은 다중 시트(psi / Customer Demand Analysis / sspCompare …) — 시트 한정 필수.
"""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
from asis import _conn as asis_conn
import oracledb

DIV = sys.argv[1] if len(sys.argv) > 1 else "81"


def in_div(csv, div):
    return div in [x.strip() for x in (csv or "").split(",")]


acn = asis_conn(); acur = acn.cursor()
acur.execute("SELECT DISTINCT SHEET_NAME FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0003'")
print(f"# AS-IS DMF0003 시트 = {[r[0] for r in acur.fetchall()]}\n")

acur.execute(
    """SELECT COLUMN_NAME, COLUMN_LABEL_NAME, DIVISION_ID, VISIBLE_FLAG, DEFAULT_FLAG,
              USER_SELECTABLE_FLAG, SORT_ORDER_NO
       FROM SCM_MST_SHEET_COLUMNS
       WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst' AND VALID_YN='Y'
       ORDER BY SORT_ORDER_NO"""
)
asis = [r for r in acur.fetchall() if in_div(r[2], DIV)]
acn.close()

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
cur.execute(
    """SELECT COLUMN_NAME, COLUMN_LABEL_NAME, DIVISION_ID, VISIBLE_FLAG, DEFAULT_FLAG,
              USER_SELECTABLE_FLAG, SORT_ORDER_NO, CELL_COMBO_DATA_TYPE, INPUT_TP_CD
       FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
       WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND VALID_YN='Y'
       ORDER BY SORT_ORDER_NO"""
)
tobe_all = cur.fetchall()
tobe = [r for r in tobe_all if in_div(r[2], DIV)]

a_vis = [r for r in asis if r[3] == "Y"]
t_vis = [r for r in tobe if r[3] == "Y"]
a_names, t_names = {r[0] for r in asis}, {r[0] for r in tobe}

print(f"## 카운트 (division={DIV})")
print(f"   AS-IS DMF0003 'Mkt Fcst' : 전체 {len(asis)}개 / VISIBLE=Y {len(a_vis)}개")
print(f"   TO-BE DMF0082 'FcstNPrice': 전체 {len(tobe)}개 / VISIBLE=Y {len(t_vis)}개")
print(f"   (요구 원문 표기 = As-Is 29개 / 현재 21개)\n")

print("## ⛔ AS-IS 에 있고 TO-BE 81 스코프에 없는 컬럼")
miss = 0
for r in sorted(asis, key=lambda x: x[6]):
    if r[0] not in t_names:
        other = next((x for x in tobe_all if x[0] == r[0]), None)
        note = f"TO-BE 존재하나 DIVISION_ID='{other[2]}' → 81 제외" if other else "TO-BE 미존재"
        print(f"   {r[0]:<22} {str(r[1])[:24]:<26} VIS={r[3]} DEF={r[4]} | {note}")
        miss += 1
print(f"   → {miss}건\n")

print("## TO-BE 81 스코프에만 있는 컬럼")
for r in sorted(tobe, key=lambda x: x[6]):
    if r[0] not in a_names:
        print(f"   {r[0]:<22} {str(r[1])[:24]:<26} VIS={r[3]} DEF={r[4]} COMBO={r[7]}")

print("\n## VISIBLE / DEFAULT 플래그가 어긋난 공통 컬럼")
for r in sorted(asis, key=lambda x: x[6]):
    t = next((x for x in tobe if x[0] == r[0]), None)
    if t and (r[3] != t[3] or r[4] != t[4]):
        print(f"   {r[0]:<22} AS-IS VIS={r[3]} DEF={r[4]}  ↔  TO-BE VIS={t[3]} DEF={t[4]}")

print("\n## 요구 지목 컬럼")
for col in ("PROJECT_CODE", "END_CUSTOMER"):
    a = next((r for r in asis if r[0] == col), None)
    t = next((r for r in tobe_all if r[0] == col), None)
    print(f"   [{col}]")
    print(f"      AS-IS : {('DIV=' + str(a[2]) + ' VIS=' + str(a[3]) + ' DEF=' + str(a[4])) if a else '없음'}")
    print(f"      TO-BE : {('DIV=' + str(t[2]) + ' VIS=' + str(t[3]) + ' DEF=' + str(t[4]) + ' COMBO=' + str(t[7])) if t else '없음'}")

con.close()
