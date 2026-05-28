#!/usr/bin/env python3
"""
GSCM Extended Events 트레이스 분석 스크립트
사용법: python analyze_perf_trace.py <24_Perf_Analysis_Template.xlsx>

입력: 1_Trace_Data 시트에 운영 DB Extended Events 결과가 입력되어 있어야 함
출력: 2_Top_Frequency / 3_Top_Slow / 4_Orphan_Verification 시트 자동 채움
"""
import sys, os, json
from openpyxl import load_workbook
from openpyxl.styles import Font, PatternFill, Alignment

def main(xlsx_path):
    wb = load_workbook(xlsx_path)
    ws_trace = wb["1_Trace_Data"]
    
    # Read trace data (skip header + example rows)
    trace = []
    for row in ws_trace.iter_rows(min_row=2, values_only=True):
        if not row[0]: continue
        # Skip examples (yellow filled — heuristic: 4 specific names)
        if row[0] in ("DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL", "PR_SCP_PLN_MRP_PROD_TARGET_NERP",
                      "UP_FX_GetUserInfoList", "DMF0009_GET_CODE"):
            print(f"Skipping example: {row[0]}")
            continue
        trace.append({
            "sp": row[0], "exec_count": row[1] or 0, "avg_ms": row[2] or 0,
            "max_ms": row[3] or 0, "cpu_ms": row[4] or 0, "reads": row[5] or 0,
            "users": row[6] or 0
        })
    print(f"Trace rows: {len(trace)}")
    
    if not trace:
        print("No real trace data — only examples found. Please paste production trace first.")
        return
    
    # Top 100 by frequency
    ws_freq = wb["2_Top_Frequency"]
    # Clear old (keep header)
    if ws_freq.max_row > 1:
        ws_freq.delete_rows(2, ws_freq.max_row)
    for i, t in enumerate(sorted(trace, key=lambda x: -x["exec_count"])[:100], 1):
        priority = "🔴 1순위" if t["exec_count"] > 100000 else "🟡 2순위" if t["exec_count"] > 10000 else "🟢 3순위"
        ws_freq.append([i, t["sp"], t["exec_count"], t["avg_ms"], t["cpu_ms"]/1000, priority])
    
    # Top 100 by duration
    ws_slow = wb["3_Top_Slow"]
    if ws_slow.max_row > 1:
        ws_slow.delete_rows(2, ws_slow.max_row)
    for i, t in enumerate(sorted(trace, key=lambda x: -x["avg_ms"])[:100], 1):
        guide = ("Critical 분해 + 인덱스" if t["avg_ms"] > 5000 else
                 "쿼리 플랜 검토" if t["avg_ms"] > 1000 else "OK")
        ws_slow.append([i, t["sp"], t["avg_ms"], t["max_ms"], t["reads"], guide])
    
    # Orphan verification — cross check with 5_SP_Inventory
    ws_inv = wb["5_SP_Inventory"]
    fox_match = {}  # sp_name -> "Y"/"" (FoxQuery match)
    for row in ws_inv.iter_rows(min_row=2, values_only=True):
        if row[1]:
            fox_match[row[1]] = row[3] or ""
    
    used_sps = set(t["sp"] for t in trace if t["exec_count"] > 0)
    
    ws_orph = wb["4_Orphan_Verification"]
    if ws_orph.max_row > 1:
        ws_orph.delete_rows(2, ws_orph.max_row)
    
    # Orphans that ARE used (정적분석 누락)
    for sp in sorted(used_sps - set(s for s, v in fox_match.items() if v == "Y")):
        ws_orph.append([sp, "N (FoxQuery 미매칭)", "Y (실제 호출)", "보존 — 동적 호출 식별 필요"])
    
    # Orphans that are NOT used (true dead code candidates)
    fox_only = set(s for s, v in fox_match.items() if v == "Y") - used_sps
    for sp in sorted(fox_only)[:50]:
        ws_orph.append([sp, "Y (FoxQuery 매칭)", "N (트레이스 기간 호출 없음)", "유지 (트레이스 기간 외 호출 가능)"])
    
    wb.save(xlsx_path)
    print(f"Updated {xlsx_path}")
    print(f"  Top freq: {min(100, len(trace))}")
    print(f"  Top slow: {min(100, len(trace))}")
    print(f"  Orphan verification: {len(used_sps - set(s for s, v in fox_match.items() if v == 'Y'))} dynamic callers identified")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python analyze_perf_trace.py <xlsx_path>")
        sys.exit(1)
    main(sys.argv[1])
