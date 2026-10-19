"""보류 51 컬럼 전체를 테이블 묶음 케이스로 순차 실행 — 케이스마다 gen(zt_auto) → deploy → run → drop → report.
  python zt_batch.py [--from CASEnn] [--only CASEnn,...] [--dry]
케이스 = 보류 컬럼을 기본 테이블(접미사 _C/_H/_KEEP 제거)로 묶은 것. 사내 행 0 테이블은 '데이터 없음 — 테스트 불가' 로 기록."""
import sys, os, re, json, time, subprocess, collections, traceback
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import zt_case
CACHE = os.path.join(os.path.dirname(HERE), "_cache")
LOG = zt_case.log


def build_cases():
    R = json.load(open(os.path.join(CACHE, "result.json"), encoding="utf-8"))
    hold = [(c["table"], c["column"]) for c in R["cols"] if str(c.get("dclass", "")).startswith("보류")]
    fam = collections.defaultdict(lambda: collections.defaultdict(set))
    for t, c in hold:
        base = re.sub(r"_(C|H|KEEP|C_KEEP)$", "", t)
        fam[base][c].add(t)
    cases = []
    i = 1
    for base in sorted(fam):
        cols = sorted(fam[base]); tabs = sorted({t for c in cols for t in fam[base][c]})
        main = base if base in tabs else tabs[0]
        cases.append({"id": f"CASE{i:02d}", "name": f"CASE{i:02d}_{main}", "table": main, "cols": cols, "tables": tabs})
        i += 1
    return cases


def main():
    a = sys.argv[1:]
    cases = build_cases()
    only = set(a[a.index("--only") + 1].split(",")) if "--only" in a else None
    start = a[a.index("--from") + 1] if "--from" in a else None
    for c in cases:
        print(c["id"], c["table"], c["cols"], "tables", c["tables"])
    if "--dry" in a:
        return
    go = start is None
    for c in cases:
        if not go and c["id"] == start:
            go = True
        if not go or (only and c["id"] not in only):
            continue
        LOG("=" * 20, c["name"], c["cols"], c["tables"])
        t0 = time.time()
        gen = os.path.join(HERE, c["name"].lower() + ".json")
        cmd = [sys.executable, os.path.join(HERE, "zt_auto.py"), c["name"], c["table"], ",".join(c["cols"]), "--skip-run"]
        if len(c["tables"]) > 1:
            cmd += ["--tables", ",".join(t for t in c["tables"] if t != c["table"])]
        r = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", errors="replace")
        open(os.path.join(HERE, "_" + c["name"].lower() + "_gen.log"), "w", encoding="utf-8").write(r.stdout + r.stderr)
        if r.returncode != 0 or not os.path.exists(gen):
            LOG(c["name"], "gen FAIL", (r.stderr or r.stdout)[-300:]); continue
        case = json.load(open(gen, encoding="utf-8"))
        case["call_timeout_sec"] = 600
        with zt_case.conn() as cn:
            cur = cn.cursor(); n = cur.execute(f"SELECT COUNT(*) FROM (SELECT 1 FROM SCM_MGR.{c['table']} WHERE ROWNUM <= 1)").fetchone()[0]
        if n == 0:
            case["notes"].append(f"{c['table']}: 사내 행 0 — 데이터 없음, 실행 비교 불가(코드 변경 지점만 적용)"); case["calls"] = []
        json.dump(case, open(gen, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
        LOG(c["name"], "packages", len(case["packages"]), "edits", sum(len(v["edits"]) for v in case["packages"].values()), "calls", len(case["calls"]))
        try:
            zt_case.deploy(case)
            if case["calls"]:
                zt_case.run(case)
            else:
                json.dump([], open(os.path.join(HERE, "_result", case["name"] + ".json"), "w", encoding="utf-8"))
        except SystemExit as e:
            LOG(c["name"], "중단:", str(e)[:200])
        except Exception:
            LOG(c["name"], "오류:", traceback.format_exc()[-400:])
        finally:
            try:
                zt_case.drop(case)
            except Exception as e:
                LOG("drop 오류", str(e)[:100])
        LOG(c["name"], "done %.0fs" % (time.time() - t0))
        try:
            subprocess.run([sys.executable, os.path.join(HERE, "zt_report.py")], capture_output=True)
        except Exception:
            pass


if __name__ == "__main__":
    main()
