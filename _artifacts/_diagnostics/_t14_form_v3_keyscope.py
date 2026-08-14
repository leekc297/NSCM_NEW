#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 Excel Form V3 — **키 축에서 조회기간 필터 제거**.

증상: div 81 · 화면 기본 조회구간(20260801~20270131)에서 Excel Form 0건.
근거(실측): PSI(DM_PLN_CUSTOMER_PSI) 데이터는 20260701~20260727 에만 존재 →
  K 서브쿼리의 `CP.YYYYMMDD BETWEEN p_start AND p_end` 가 **키 조합 자체를 과거 업로드 시점으로 제한**해
  "그 기간에 업로드된 적 있는 키"만 남는다.

⭐ 정정 근거: 양식의 키 조합은 **앞으로 업로드할 대상**이라 조회 기간과 무관하다.
   기간이 관계되는 것은 **값 컬럼(주차)** 뿐이고, 그건 DMF0007 `SUMMARY_BUCKET_VALUE` 기반
   `UPLOAD_VALID_WEEKS`(컬러링 원천)가 이미 조회 구간으로 걸러 담당한다.
   ⇒ K 에서 기간 필터를 제거해야 "업로드를 위한 실제 데이터" 요구가 성립한다.
"""
import io, pathlib, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0014_EXCELFORM_20260814")

OLD = """              AND    CP.YYYYMMDD BETWEEN ''p_start_yyyymmdd'' AND ''p_end_yyyymmdd''
             ) K"""
NEW = """              /* ⭐ [V3 2026-08-14] 키 축에는 **조회기간 필터를 걸지 않는다**.
                 양식의 키 조합은 앞으로 업로드할 대상이라 기간과 무관하다. 기간은 값 컬럼(주차)에만
                 관계되고 그건 아래 UPLOAD_VALID_WEEKS 가 담당한다.
                 (V2 는 여기에 CP.YYYYMMDD BETWEEN 을 걸어, 화면 기본구간 20260801~ 에서
                  PSI 실데이터 구간 20260701~0727 과 어긋나 **전건 0** 이 됐다 — div 81 실사고) */
             ) K"""

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
body = "".join(r[0] for r in cur.fetchall())

if OLD not in body:
    sys.exit("⛔ V2 키축 기간필터를 찾지 못함 — 이미 정정됐거나 본문 변경")
body_v3 = body.replace(OLD, NEW, 1)

(OUT / "05_PKG_DMF0014_BODY_FORM_V3.sql").write_text(
    "SET DEFINE OFF\nCREATE OR REPLACE " + body_v3.rstrip() + "\n/\n", encoding="utf-8")

cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
cur.execute("CREATE OR REPLACE " + body_v3.rstrip())
print("[deploy] BODY V3 OK")
cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
               AND OBJECT_NAME='PKG_DMF0014' ORDER BY 1""")
for r in cur.fetchall():
    print(f"   {r[0]:<14} {r[1]}")
cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014'")
print(f"[errors] {cur.fetchone()[0]}")
con.close()
