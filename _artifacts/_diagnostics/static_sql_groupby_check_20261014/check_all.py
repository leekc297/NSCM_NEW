"""SCM_MGR 의 패키지 BODY · 프로시저 · 함수 전체에서 GROUP BY 가 있는 정적 SQL 을 "파싱만" 해 보는 일괄 점검 (읽기 전용)

  python check_all.py            # 전체 실행 (4개 접속으로 나눠 실행, 결과는 results.jsonl 에 이어 쓴다 — 중간에 끊겨도 이어서 실행)
  python check_all.py report     # results.jsonl → 00_REPORT.md · findings.tsv

배경(2026-10-14): PKG_DMF0044 에서 SELECT 와 GROUP BY 의 식이 달라 실행 시점에만 나는 ORA-00979 가 5문장 나왔다
  (컴파일은 VALID). 사용자 요청: 같은 패턴을 다른 PKG · SP 에도 일괄 확인.

기준 원문 = 실행 시점에 ALL_SOURCE 에서 새로 조회한 원문 (로컬 파일 아님). 객체마다 LAST_DDL_TIME 을 같이 기록한다.
방법 = _apply_corporate/DMF0044_GRPUPPER_20261014/check_static_sql.py 와 같은 절차:
  주석 제거 → ';' 로 문장 분리 → SQL 본문 추출 → DBMS_SQL.PARSE (실행 없음) → 모르는 이름(ORA-00904)은 PL/SQL 변수로 보고
  바인드로 바꿔 재파싱 → 그래도 실패하면 상수로 바꿔 재파싱.
범위 = GROUP BY 가 들어 있는 정적 SQL 문장만 (이번 오류 계열의 대상).
한계
  - 문자열로 조립해 실행하는 동적 SQL 은 대상이 아니다 → 객체별 개수만 기록한다.
  - 파싱이 다른 오류로 끝난 문장은 "미판정" 으로 따로 모은다 (도구가 PL/SQL 전용 문법 · 변수 자료형을 흉내 내지 못한 경우가 대부분).
"""
import sys, os, re, json, threading, time
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0044_GRPUPPER_20261014")
from ora import conn_info
import oracledb
import check_static_sql as C

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results.jsonl")
TYPES = ("PACKAGE BODY", "PROCEDURE", "FUNCTION")
SAME = ("ORA-00979", "ORA-00937", "ORA-00934")   # GROUP BY 불일치 · 단일 그룹 함수 아님 · 그룹 함수 위치 오류
LOCK = threading.Lock()


def connect():
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    con.cursor().execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR")
    return con


def check_object(cur, name, typ):
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=name, t=typ)
    src = "".join(r[0] for r in cur)
    if " wrapped" in src[:200].lower():
        return {"skip": "wrapped"}
    code = C.strip_comments(src)
    procs = [(m.start(), m.group(2)) for m in re.finditer(r"^\s*(PROCEDURE|FUNCTION)\s+(\w+)", code, re.M)]
    out = {"lines": src.count("\n"), "stmts": 0, "ok": 0, "items": [],
           "dyn": sum(1 for m in re.finditer(r"'(?:[^']|'')*'", code) if re.search(r"\bGROUP\s+BY\b", m.group(0), re.I))}
    for off, stmt in C.split_statements(code):
        if not re.search(r"\bGROUP\s+BY\b", C.mask_strings(stmt), re.I):
            continue
        ex = C.extract_sql(stmt)
        if not ex:
            continue
        sql, s = ex
        if sql.lstrip()[:1] == "'" or not re.search(r"\bGROUP\s+BY\b", C.mask_strings(sql), re.I):
            continue
        pos = off + s + (len(sql) - len(sql.lstrip()))
        line = code.count("\n", 0, pos) + 1
        proc = next((nm for st, nm in reversed(procs) if st <= pos), "")
        out["stmts"] += 1
        code_, msg, _ = C.parse_only(cur, sql)
        if code_ == "OK":
            out["ok"] += 1
        else:
            out["items"].append({"line": line, "proc": proc, "code": code_, "msg": msg[:200], "sql": re.sub(r"\s+", " ", sql)[:90]})
    return out


def worker(jobs, done_keys, idx):
    con = connect()
    cur = con.cursor()
    while True:
        with LOCK:
            if not jobs:
                return
            name, typ, ddl, status = jobs.pop()
        t0 = time.time()
        try:
            r = check_object(cur, name, typ)
        except Exception as e:   # 접속 끊김 등 — 다시 접속하고 이 객체는 오류로 기록
            r = {"error": str(e)[:300]}
            try:
                con = connect(); cur = con.cursor()
            except Exception:
                pass
        r.update({"name": name, "type": typ, "last_ddl": ddl, "status": status, "sec": round(time.time() - t0, 1)})
        with LOCK:
            open(RES, "a", encoding="utf-8").write(json.dumps(r, ensure_ascii=False) + "\n")
            done_keys.add((name, typ))
            if len(done_keys) % 25 == 0:
                print(time.strftime("%H:%M:%S"), "done", len(done_keys), "left", len(jobs), flush=True)


def run():
    con = connect()
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    print("DB", cur.fetchone(), flush=True)
    cur.execute("SELECT object_name, object_type, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS'), status FROM all_objects "
                "WHERE owner='SCM_MGR' AND object_type IN ('PACKAGE BODY','PROCEDURE','FUNCTION') "
                "AND object_name IN (SELECT name FROM all_source WHERE owner='SCM_MGR' AND UPPER(text) LIKE '%GROUP BY%') ORDER BY 1, 2")
    allobj = cur.fetchall()
    done = set()
    if os.path.exists(RES):
        for l in open(RES, encoding="utf-8"):
            j = json.loads(l)
            if "error" not in j:
                done.add((j["name"], j["type"]))
    jobs = [o for o in allobj if (o[0], o[1]) not in done]
    print("GROUP BY 가 있는 객체", len(allobj), "· 남은 객체", len(jobs), flush=True)
    jobs.reverse()
    th = [threading.Thread(target=worker, args=(jobs, done, i)) for i in range(4)]
    for t in th:
        t.start()
    for t in th:
        t.join()
    print("FINISHED", time.strftime("%H:%M:%S"), flush=True)


def report():
    rows = {}
    for l in open(RES, encoding="utf-8"):
        j = json.loads(l)
        rows[(j["name"], j["type"])] = j          # 같은 객체가 두 번 있으면 뒤의 것
    rows = list(rows.values())
    errs = [r for r in rows if "error" in r]
    good = [r for r in rows if "error" not in r and "skip" not in r]
    stmts = sum(r["stmts"] for r in good)
    ok = sum(r["ok"] for r in good)
    same = [(r, i) for r in good for i in r["items"] if i["code"] in SAME]
    other = [(r, i) for r in good for i in r["items"] if i["code"] not in SAME]
    with open(os.path.join(HERE, "findings.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("분류\t객체\t종류\t상태\tLAST_DDL\t행\t프로시저\t오류\t문장 앞부분\n")
        for kind, lst in (("같은 계열", same), ("미판정", other)):
            for r, i in sorted(lst, key=lambda x: (x[0]["name"], x[1]["line"])):
                f.write("\t".join([kind, r["name"], r["type"], r["status"], r["last_ddl"], str(i["line"]), i["proc"], i["msg"], i["sql"]]) + "\n")
    by_obj = {}
    for r, i in same:
        by_obj.setdefault((r["name"], r["type"], r["status"], r["last_ddl"]), []).append(i)
    oc = {}
    for r, i in other:
        oc[i["code"]] = oc.get(i["code"], 0) + 1
    L = []
    L.append("# SCM_MGR 정적 SQL — GROUP BY 불일치(ORA-00979 계열) 일괄 점검 결과\n")
    L.append(f"- 대상 DB: 사내오라클 ZIOUI1 · 기준 원문 = 실행 시점 ALL_SOURCE · 실행 없이 파싱만(DBMS_SQL.PARSE)")
    L.append(f"- 점검 객체(GROUP BY 가 있는 PACKAGE BODY · PROCEDURE · FUNCTION): **{len(rows)}개** (점검 실패 {len(errs)}개)")
    L.append(f"- GROUP BY 가 있는 정적 SQL 문장: **{stmts}개** → 통과 {ok} · **같은 계열 오류 {len(same)}** · 미판정 {len(other)}")
    L.append(f"- 점검 밖: 문자열로 조립하는 동적 SQL 중 GROUP BY 가 있는 곳 {sum(r['dyn'] for r in good)}곳 ({sum(1 for r in good if r['dyn'])}개 객체)\n")
    L.append(f"## 같은 계열 오류 — {len(by_obj)}개 객체 · {len(same)}문장\n")
    L.append("| 객체 | 종류 | 상태 | LAST_DDL | 행 | 프로시저 | 오류 |")
    L.append("|---|---|---|---|---|---|---|")
    for (n, t, st, ddl), items in sorted(by_obj.items()):
        for i in sorted(items, key=lambda x: x["line"]):
            L.append(f"| {n} | {t} | {st} | {ddl} | {i['line']} | {i['proc']} | {i['msg'][:110].replace('|', '/')} |")
    L.append(f"\n## 미판정 — {len(other)}문장 (오류 코드별)\n")
    L.append("파싱이 다른 오류로 끝난 문장이다. 도구가 PL/SQL 전용 문법 · 변수 자료형을 흉내 내지 못한 경우가 대부분이며, 같은 계열 오류로 확인된 것은 아니다. 목록은 `findings.tsv`.\n")
    L.append("| 오류 코드 | 문장 수 |")
    L.append("|---|---|")
    for k, v in sorted(oc.items(), key=lambda x: -x[1]):
        L.append(f"| {k} | {v} |")
    if errs:
        L.append(f"\n## 점검 실패 객체 — {len(errs)}개\n")
        for r in errs:
            L.append(f"- {r['name']} ({r['type']}): {r['error'][:150]}")
    open(os.path.join(HERE, "00_REPORT.md"), "w", encoding="utf-8", newline="\n").write("\n".join(L) + "\n")
    print("\n".join(L[:8]))
    print("같은 계열 객체:", len(by_obj), "| 미판정 코드:", sorted(oc.items(), key=lambda x: -x[1])[:8])


if __name__ == "__main__":
    report() if len(sys.argv) > 1 and sys.argv[1] == "report" else run()
