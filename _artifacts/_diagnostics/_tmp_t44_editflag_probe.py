#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""MAIN GRID 편집가능 셀 미표시 — 원인 후보 3축 동시 확인 (조회 전용)
   ① 라이브 BODY 의 마커 인벤토리 (EDITFLAGSTD 가 적용됐는가 / 내 배포로 유실됐는가)
   ② PKG_DMF0044 안의 REPORT_GROUP2 참조 5곳 — B-1 삭제 영향 가능성
   ③ EDIT_FLAG 를 만드는 로직 위치
"""
import sys, pathlib, re
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()

def sec(t): print("\n" + "=" * 116); print(t); print("=" * 116)

cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                AND TYPE='PACKAGE BODY' ORDER BY LINE""")
live = "".join(r[0] for r in cur.fetchall())
lines = live.splitlines()

sec("[①] 라이브 BODY 마커 인벤토리 — 오늘 적용분이 모두 살아있는가")
MARKS = ["AUTHUNION 2026-08-09", "PIVOTSEL 2026-08-10", "PRODUCTDETAIL 2026-08-10",
         "RPTGRP-STUB 2026-08-10", "SEQGRP 2026-08-10", "ETCDEL 2026-08-10",
         "DYNSAMP 2026-08-10", "NODATAGUARD 2026-08-10", "DESCNULL 2026-08-10",
         "TUNE-M 2026-08-10", "TUNE-M2 2026-08-10", "TUNE-T 2026-08-10",
         "TUNE-V 2026-08-10", "TUNE-J 2026-08-10", "TUNE-S 2026-08-10",
         "MSRDUP", "EDITFLAG", "EDITFLAGSTD"]
for m in MARKS:
    print(f"    {m:<28} = {live.count(m)}")

sec("[①-b] 배포본 파일들과 라이브 대조 — EDITFLAGSTD 가 적용된 적 있는가")
OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate")
for f in sorted(OUT.glob("PKG_DMF0044_BODY_*.sql")):
    t = f.read_text(encoding="utf-8", errors="ignore")
    print(f"    {f.name:<52} {len(t.splitlines()):>6}행   TUNE-S={t.count('TUNE-S')} "
          f"EDITFLAG={t.count('EDITFLAG')}")
print(f"    {'(LIVE)':<52} {len(lines):>6}행   TUNE-S={live.count('TUNE-S')} EDITFLAG={live.count('EDITFLAG')}")

sec("[②] PKG_DMF0044 안의 REPORT_GROUP2 참조 — B-1 삭제 영향 판정")
for i, ln in enumerate(lines, 1):
    if "REPORT_GROUP2" in ln.upper():
        lo = max(0, i - 4); hi = min(len(lines), i + 3)
        print(f"\n  --- L{i} 문맥 ---")
        for k in range(lo, hi):
            print(f"    {k+1:5d} | {lines[k].rstrip()}")

sec("[③] EDIT_FLAG 생성 로직 위치 (MAIN GRID)")
for i, ln in enumerate(lines, 1):
    if re.search(r'EDIT_FLAG', ln, re.I):
        print(f"    L{i:5d} | {ln.strip()[:150]}")

con.close()
