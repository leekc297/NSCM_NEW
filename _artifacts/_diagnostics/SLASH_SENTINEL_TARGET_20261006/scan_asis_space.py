"""AS-IS 실데이터 — 모집단 1,797 컬럼의 공백 실태 (읽기 전용 SELECT)
  blank_any : col = ''                       (MSSQL 은 '' 과 공백만 문자열을 같게 봄 → 합산)
  space_only: col = '' AND DATALENGTH(col)>0 (공백만으로 된 값 — Oracle 에선 NULL 이 아님)
  trail_sp  : DATALENGTH(col) <> DATALENGTH(RTRIM(col)) AND col <> ''  (뒤 공백 붙은 실제 값 — MSSQL 은 'A'='A ' 로 봄)
  dash      : col = '-'   ddash: col = '--'
"""
import sys, os, json, time, collections
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\DASH_SENTINEL_INVENTORY_20261001")
import extract_dash_inventory as old
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "_cache", "asis_space.json")
pop = json.load(open(os.path.join(HERE, "_cache", "pop.json"), encoding="utf-8"))["rows"]
meta = json.load(open(os.path.join(HERE, "_cache", "asis_meta.json"), encoding="utf-8"))
names = {db: {k.split("|")[1] for k in meta["tables"] if k.startswith(db + "|")} for db in ("LGCE_SCMDEV", "LGCE_FPDEV")}
by = collections.OrderedDict()
for r in pop:
    tb, cn = r["table"], r["column"]
    home = "LGCE_SCMDEV" if tb in names["LGCE_SCMDEV"] else ("LGCE_FPDEV" if tb in names["LGCE_FPDEV"] else None)
    if home and cn in meta["tables"][home + "|" + tb]["types"]:
        by.setdefault((home, tb), []).append(cn)
done = json.load(open(OUT, encoding="utf-8")) if os.path.exists(OUT) else {}
print("tables", len(by), "already", len(done), flush=True)
with old.asis() as c:
    cur = c.cursor()
    for (db, tb), cols in by.items():
        key = f"{db}|{tb}"
        if key in done:
            continue
        parts = ["COUNT(*)"]
        for cn in cols:
            parts += [f"SUM(CASE WHEN [{cn}] = '' THEN 1 ELSE 0 END)",
                      f"SUM(CASE WHEN [{cn}] = '' AND DATALENGTH([{cn}]) > 0 THEN 1 ELSE 0 END)",
                      f"SUM(CASE WHEN [{cn}] <> '' AND DATALENGTH([{cn}]) <> DATALENGTH(RTRIM([{cn}])) THEN 1 ELSE 0 END)",
                      f"SUM(CASE WHEN [{cn}] = '-' THEN 1 ELSE 0 END)", f"SUM(CASE WHEN [{cn}] = '--' THEN 1 ELSE 0 END)"]
        t0 = time.time()
        try:
            r = cur.execute(f"SELECT {', '.join(parts)} FROM {db}.dbo.[{tb}] WITH (NOLOCK)").fetchone()
            res = {"total": int(r[0] or 0), "cols": {cn: {"blank_any": int(r[1 + 5 * i] or 0), "space_only": int(r[2 + 5 * i] or 0), "trail_sp": int(r[3 + 5 * i] or 0),
                                                     "dash": int(r[4 + 5 * i] or 0), "ddash": int(r[5 + 5 * i] or 0)} for i, cn in enumerate(cols)}, "sec": round(time.time() - t0, 1)}
        except Exception as e:
            res = {"error": str(e)[:300]}
        done[key] = res
        json.dump(done, open(OUT, "w", encoding="utf-8"), ensure_ascii=False)
        print(time.strftime("%H:%M:%S"), key, res.get("total"), res.get("sec"), res.get("error", ""), flush=True)
# 집계
tot = collections.Counter(); cls = collections.Counter(); top = []
for key, v in done.items():
    if v.get("error"):
        cls["스캔 실패"] += 1; continue
    for cn, x in v["cols"].items():
        tot["blank_any"] += x["blank_any"]; tot["space_only"] += x["space_only"]; tot["trail_sp"] += x["trail_sp"]
        k = ("공백만O" if x["space_only"] else "공백만X") + "/" + ("뒤공백O" if x["trail_sp"] else "뒤공백X")
        cls[k] += 1
        if x["space_only"] or x["trail_sp"]:
            top.append((key.split("|")[1], cn, x["space_only"], x["trail_sp"], x["blank_any"] - x["space_only"], x["dash"], v["total"]))
print("합계", dict(tot)); print("컬럼 분류", dict(cls))
top.sort(key=lambda t: -(t[2] + t[3]))
print("공백만/뒤공백 있는 컬럼", len(top))
for t in top[:40]:
    print("  %s.%s  공백만 %s  뒤공백 %s  순수빈값 %s  '-' %s  전체 %s" % t)
