#!/usr/bin/env python3
"""
Stage 3d — GTT 사용 SP 의 BEGIN 직후 DELETE 누락 audit.

GTT (Global Temporary Table, GT_*) 는 ON COMMIT PRESERVE ROWS 가 흔하지만
BE pool 의 같은 session 에서 SP 가 2회 호출되면 1회차 row 가 잔존 → 결과 중복.

Audit:
  각 PROCEDURE 단위로 (a) GT_* INSERT 가 있는지 (b) BEGIN 직후 (또는 첫 50줄 내)
  `DELETE FROM GT_*` 가 있는지 — 누락 시 list.

수동 보강 권고: GT_* INSERT 직전에 DELETE FROM GT_<table>; 추가.
"""
import re
import sys
from pathlib import Path
from collections import defaultdict

ROOT = Path("To-be_v2_converted/06_Packages")
GLOB = "04_Package_PKG_*.sql"

PROC_RE = re.compile(r"^\s*PROCEDURE\s+(\w+)", re.IGNORECASE | re.MULTILINE)
BEGIN_RE = re.compile(r"^\s*BEGIN\s*$", re.IGNORECASE | re.MULTILINE)
END_RE = re.compile(r"^\s*END\s+(\w+)\s*;", re.IGNORECASE | re.MULTILINE)
GT_INSERT_RE = re.compile(r"INSERT\s+INTO\s+(GT_\w+)", re.IGNORECASE)
GT_DELETE_RE = re.compile(r"DELETE\s+FROM\s+(GT_\w+)", re.IGNORECASE)


def audit_file(text: str) -> list[dict]:
    """Returns list of {proc, gt_inserts_without_prior_delete}."""
    results = []
    # Split per procedure — find PROCEDURE ... IS|AS ... BEGIN ... END proc_name;
    # Simplification: find proc body between BEGIN and matching END proc_name;
    procs = list(PROC_RE.finditer(text))
    for i, m in enumerate(procs):
        proc_name = m.group(1)
        start = m.end()
        # find next BEGIN
        bm = BEGIN_RE.search(text, start)
        if not bm:
            continue
        # find END proc_name;
        em = re.search(rf"^\s*END\s+{re.escape(proc_name)}\s*;", text[bm.end():],
                       re.IGNORECASE | re.MULTILINE)
        if not em:
            continue
        body = text[bm.end():bm.end() + em.start()]
        inserts = GT_INSERT_RE.findall(body)
        deletes = GT_DELETE_RE.findall(body)
        # Tables inserted but not previously DELETE'd
        missing = []
        delete_set = set(d.upper() for d in deletes)
        for t in set(i.upper() for i in inserts):
            if t not in delete_set:
                missing.append(t)
        if missing:
            results.append({"proc": proc_name, "missing": sorted(missing)})
    return results


def main():
    total_proc = 0
    total_miss = 0
    print(f"{'File':50s} {'Procedure':40s} {'Missing GT_* DELETE'}")
    print("-" * 130)
    for f in sorted(ROOT.glob(GLOB)):
        text = f.read_text(encoding="utf-8")
        results = audit_file(text)
        for r in results:
            total_proc += 1
            total_miss += len(r["missing"])
            print(f"{f.name:50s} {r['proc']:40s} {', '.join(r['missing'])}")
    print("-" * 130)
    print(f"Total: {total_proc} procedures with {total_miss} GT_* INSERT lacking BEGIN-time DELETE")


if __name__ == "__main__":
    main()
