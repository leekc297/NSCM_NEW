#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""패치 앵커 원문 정확 추출 (공백 1바이트까지) — 손대기 전 확인용"""
import pathlib
src = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_diagnostics\_tmp_LIVE_PKG_DMF0044_BODY.sql")
lines = src.read_text(encoding="utf-8").splitlines(keepends=True)

def dump(tag, a, b):
    print("\n" + "#" * 100)
    print(f"### {tag}   (L{a}~L{b})")
    print("#" * 100)
    for i in range(a - 1, b):
        print(f"{i+1:5d} |{lines[i].rstrip(chr(10))}|")

dump("A. ISV CTE  (DEPT_CREATE)",      9400, 9414)
dump("A. ISV CTE  (PRODUCT_CREATE)",   9705, 9719)
dump("B1. DEPT_CREATE 룩업 2건",        9532, 9542)
dump("B2. DEPT_CREATE ORI_VERSION 1회", 9374, 9379)
dump("B3. PRODUCT_CREATE ORI_VERSION",  9743, 9752)
dump("B3b. PRODUCT_CREATE GROUP BY",    9788, 9799)
dump("B4. EXCHANGE ORI_VERSION",        2604, 2628)

text = "".join(lines)
for tag, s in (
    ("ISV block", "        WITH ISV AS (\n"),
    ("MATERIALIZE", "SELECT /*+ MATERIALIZE */"),
    ("TUNE-M mark", "TUNE-M 2026-08-10"),
    ("TUNE-M2 mark", "TUNE-M2 2026-08-10"),
):
    print(f"\ncount[{tag}] = {text.count(s)}")
