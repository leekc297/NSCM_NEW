# -*- coding: utf-8 -*-
"""_diag_raw.json → 진단표 렌더."""
import io
import json
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
R = json.load(open("_diag_raw.json", encoding="utf-8"))
thr = float(sys.argv[1]) if len(sys.argv) > 1 else 0.02
for r in R:
    mx = max(c["ela"] for c in r["cases"].values())
    if mx < thr:
        continue
    print("=" * 110)
    print("SQL %s | obj=%s | LINE#=%s | BODY매칭=%s | maxELA=%s"
          % (r["sid"], r["obj"], r["line_hint"], r["body_line"], mx))
    for k, c in sorted(r["cases"].items()):
        print("   %-20s ela=%7.3f ex=%3d bg=%9d disk=%8d rows=%9d"
              % (k, c["ela"], c["ex"], c["bg"], c["dr"], c["rows"]))
    print("   FULL:", r["fulls"], " IDX:", r["idxs"])
    print("   SQL:", r["sql"][:190])
