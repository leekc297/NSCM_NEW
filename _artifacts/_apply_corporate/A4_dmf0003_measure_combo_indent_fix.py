#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
A4_dmf0003_measure_combo_indent_fix.py
===============================================================================
DMF0003 종속 메저 단계별 indent 복원 (2026-07-13 사용자 요구).

원인 (실측)
  - MEASURE 컬럼 표시명 = admin 콤보 SCM_ADM_CMBO_SQL_M SQL_ID='Measure' dataMap.
  - AS-IS 원본 dbo.UP_FX_GetCommonDataList @CODE='Measure' (LGCE_SCMDEV L2142~2237):
      1단계 (CUST_FCST 직계)      : N' └ '     — CUST_FCST_EDI(EDI)/EXCEL/RPA/동적 measure
      2단계 (EDI 하위 세부 14종)   : N'    └ '  — 공백 4칸 (Immidiate/Planning_Forecast/
        Commercial_Agreement/Firm_Temp/Manumacturing_Material_Temp/Material_Temp/Backorder
        + 동일 [Org.] 7종)
  - TO-BE 'Measure' 콤보 SQL 은 전부 ' └ ' 1단계로 평탄화 → 종속 메저가 동일 단계로 표시.

교정
  - 위 14종의 접두를 AS-IS 그대로 '    └ ' 로 복원 (각 치환 패턴 정확히 1회 매치 assert).
  - FE 짝 수정: MktFcstGrid.tsx formatItem — MEASURE 셀 white-space:pre (HTML 공백 collapse 차단).

실행: python A4_dmf0003_measure_combo_indent_fix.py --apply   (없으면 dry-run)
"""
import sys

import oracledb

APPLY = "--apply" in sys.argv

# 2단계 대상 14종 (AS-IS L2171~2216 실측)
LEVEL2 = [
    "Immidiate",
    "Planning_Forecast",
    "Commercial_Agreement",
    "Firm_Temp",
    "Manumacturing_Material_Temp",
    "Material_Temp",
    "Backorder",
    "Immidiate[Org.]",
    "Planning_Forecast[Org.]",
    "Commercial_Agreement[Org.]",
    "Firm_Temp[Org.]",
    "Manumacturing_Material_Temp[Org.]",
    "Material_Temp[Org.]",
    "Backorder[Org.]",
]


def connect():
    last = None
    for kw in (dict(service_name="OCGSCMD_P01"), dict(sid="ESSCMD")):
        try:
            dsn = oracledb.makedsn(host="121.162.245.167", port=2521, **kw)
            return oracledb.connect(user="SCM_MGR", password="!SCMroqkf2026", dsn=dsn)
        except Exception as e:
            last = e
    raise last


conn = connect()
cur = conn.cursor()

cur.execute("SELECT SQL_DTL_CTN FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID='Measure'")
row = cur.fetchone()
assert row, "SQL_ID='Measure' row not found"
body = row[0].read() if hasattr(row[0], "read") else row[0]
orig = body

changed = 0
for name in LEVEL2:
    old = f"' └ ' || '{name}' FROM DUAL"
    new = f"'    └ ' || '{name}' FROM DUAL"
    n = body.count(old)
    already = body.count(new)
    if already == 1 and n == 0:
        print(f"  = {name:38} 이미 2단계 (skip)")
        continue
    assert n == 1, f"[{name}] expected 1 match, got {n}"
    body = body.replace(old, new, 1)
    changed += 1
    print(f"  ✔ {name:38} ' └ ' → '    └ '")

print(f"\n변경 {changed} 건 / 본문 {len(orig)} → {len(body)} chars")

if APPLY and changed:
    cur.execute(
        """UPDATE SCM_ADM_CMBO_SQL_M
              SET SQL_DTL_CTN = :b, LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
            WHERE SQL_ID = 'Measure'""",
        b=body)
    assert cur.rowcount == 1
    conn.commit()
    # 사후 검증
    cur.execute("SELECT SQL_DTL_CTN FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID='Measure'")
    after = cur.fetchone()[0]
    after = after.read() if hasattr(after, "read") else after
    n2 = sum(after.count(f"'    └ ' || '{n}' FROM DUAL") for n in LEVEL2)
    print(f"COMMIT 완료 — 사후검증: 2단계 접두 {n2}/14")
else:
    conn.rollback()
    print("dry-run — 변경 없음. 적용: --apply")

cur.close()
conn.close()
