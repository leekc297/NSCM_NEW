"""[조회 전용] 조인의 한쪽만 변환되는 쌍 — 현재 결과 vs '/' 변환 후 결과 (사내 ZIOUI1 실측)

A_join(_risk.json) 의 각 쌍에 대해, 같은 문장에서 같은 두 테이블을 잇는 등치 전부를 조인 조건으로 삼아
  현재   : 조인 성립 행 수 전체
  끊김   : 그중 변환 컬럼 = '-' AND 상대 컬럼 = '-' 로 성립하는 행 수  ← 변환 후 변환 컬럼만 '/' 가 되어 더 이상 성립하지 않는 행
  변환 후: 현재 − 끊김
끊김 = 0 이면 그 자리는 이상 없음. 끊김 > 0 이면 상대 컬럼을 변환 범위에 넣거나 코드의 조인 조건을 손봐야 한다.
한계: 등치 외 조건(기간·사업부 등 상수 비교)은 넣지 않으므로 '현재' 는 실제 실행 결과보다 클 수 있다. 끊김 행의 존재 여부와 규모를 보는 용도.
결과 = _join_break.json
"""
import sys, json, time, pathlib, collections
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE)); import s1_data_scan as s

R = json.loads((HERE / "_risk.json").read_text(encoding="utf-8"))
pairs = json.loads((HERE / "_join_pairs.json").read_text(encoding="utf-8"))
OUT = HERE / "_join_break.json"
done = json.loads(OUT.read_text(encoding="utf-8")) if OUT.exists() else {}

# 문장 단위 등치 묶음: (obj, stmt_line, t1, t2) → {(c1, c2)}
grp = collections.defaultdict(set)
for p in pairs:
    grp[(p["obj"], p["stmt_line"], p["t1"], p["t2"])].add((p["c1"], p["c2"]))
    grp[(p["obj"], p["stmt_line"], p["t2"], p["t1"])].add((p["c2"], p["c1"]))

con = s.connect(); cur = con.cursor()
cur.execute("SELECT sys_context('userenv','db_name'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual"); print("DB", cur.fetchone(), flush=True)
jobs = []
for a in R["A_join"]:
    ta, ca, tb, cb = a["conv_table"], a["conv_col"], a["other_table"], a["other_col"]
    preds = set()
    for (obj, st, t1, t2), eqs in grp.items():
        if t1 == ta and t2 == tb and (ca, cb) in eqs:
            preds.add(tuple(sorted(eqs)))
    for pr in preds:
        key = f"{ta}.{ca}={tb}.{cb} | " + " & ".join(f"{x}={y}" for x, y in pr)
        if key in done and "error" not in done[key]: continue
        jobs.append((key, ta, ca, tb, cb, pr, a["other_kind"], a["objects"]))
print("측정 건", len(jobs), flush=True)
for n, (key, ta, ca, tb, cb, pr, kind, objs) in enumerate(jobs, 1):
    on = " AND ".join(f'A."{x}" = B."{y}"' for x, y in pr)
    base = f'FROM SCM_MGR."{ta}" A JOIN SCM_MGR."{tb}" B ON {on}'
    ent = dict(conv=f"{ta}.{ca}", other=f"{tb}.{cb}", other_kind=kind, join_cols=[f"{x}={y}" for x, y in pr], objects=objs)
    t0 = time.time()
    try:
        cur.execute(f"SELECT COUNT(*) {base}"); ent["now"] = cur.fetchone()[0]
        cur.execute(f"""SELECT COUNT(*) {base} WHERE A."{ca}" = '-' AND B."{cb}" = '-'"""); ent["broken"] = cur.fetchone()[0]
        ent["after"] = ent["now"] - ent["broken"]
    except Exception as e:
        ent["error"] = str(e)[:300]
        try: con.ping()
        except Exception: con = s.connect(); cur = con.cursor()
    ent["sec"] = round(time.time() - t0, 1)
    done[key] = ent
    OUT.write_text(json.dumps(done, ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"[{n}/{len(jobs)}] {key[:120]} now={ent.get('now')} broken={ent.get('broken')} {ent.get('error','')} ({ent['sec']}s)", flush=True)
print("done", flush=True)
