#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""단위테스트 보완대상 2파일에서 DMF0021(Sales Plan) 관련 행 **전수** 추출.

⚠ anti-simplification: 시트 1개·키워드 1개로 거르지 않는다.
   ① 두 파일의 **전 시트** 순회 ② 행 전체를 문자열로 합쳐 다중 키워드(OR) 매칭
   ③ 매칭 행은 **전 셀 원문**을 그대로 덤프(요약 금지 — 요구 대조 단위는 문구)
"""
import sys, io, pathlib
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from openpyxl import load_workbook

BASE = pathlib.Path(r"C:\Projects\NSCM\Doc\단위테스트_보완대상")
# ⚠ '~$...' = Excel 잠금 임시파일(파일이 열려 있을 때 생성) — 로드 불가라 반드시 제외
FILES = sorted(f for f in BASE.glob("*.xlsx") if not f.name.startswith("~$"))
KEYS = ["DMF0021", "SALES PLAN", "SALESPLAN", "매출계획"]


def norm(v):
    return "" if v is None else str(v).strip()


for f in FILES:
    print("\n" + "=" * 110)
    print(f"# FILE: {f.name}")
    wb = load_workbook(f, data_only=True)
    print(f"  시트: {wb.sheetnames}")
    for ws in wb.worksheets:
        rows = list(ws.iter_rows(values_only=True))
        if not rows:
            continue
        # 헤더 후보 = 비어있지 않은 셀이 가장 많은 상위 3행 중 첫 행
        hdr_idx, hdr = 0, rows[0]
        for i in range(min(5, len(rows))):
            if sum(1 for c in rows[i] if norm(c)) > sum(1 for c in hdr if norm(c)):
                hdr_idx, hdr = i, rows[i]
        hits = []
        for i, r in enumerate(rows):
            if i <= hdr_idx:
                continue
            blob = " ".join(norm(c) for c in r).upper()
            if any(k in blob for k in KEYS):
                hits.append((i + 1, r))
        if not hits:
            continue
        print(f"\n  ── 시트 '{ws.title}' — DMF0021 매칭 {len(hits)}행 (헤더 행{hdr_idx+1}) ──")
        cols = [norm(c) for c in hdr]
        for rn, r in hits:
            print(f"\n  [행 {rn}]")
            for ci, cell in enumerate(r):
                v = norm(cell)
                if not v:
                    continue
                name = cols[ci] if ci < len(cols) and cols[ci] else f"col{ci+1}"
                v = v.replace("\n", "\n           ")
                print(f"    · {name} = {v}")
