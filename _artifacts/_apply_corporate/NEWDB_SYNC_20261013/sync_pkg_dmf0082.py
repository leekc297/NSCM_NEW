"""신규 사내오라클(59.19.252.148:2521/ZIOUI1) ← 구 사내오라클(222.110.191.243) 누락분 반영 : PKG_DMF0082 BODY

사용자 요청(2026-10-13): 사내오라클 IP 변경 + "어제 8시 이후부터 방금까지 수정된 항목 중 누락분을 신규 사내오라클에 적용".
전수 비교 결과(USER_SOURCE 795 객체 해시 대조) 구 DB 쪽이 앞선 코드 객체는 PKG_DMF0082 BODY 1개:
  [E20261013-DMF0082SSPMNEW]  (구 DB 10-13 00:18 적용)  신규 행 SSPM 4키 검증 5-1 신설
  [E20261013-DMF0082ADJYNALL] (구 DB 10-13 09:59 적용)  단가 검증 #10 조정 제외 품목 예외 주석 처리
신규 DB BODY(LAST_DDL 10-12 21:52:20)에는 두 마커가 없다.

방식: 신규 DB 의 현재 원문(ALL_SOURCE 재조회) 위에 두 건의 치환을 원 빌더(transform) 그대로 순서대로 얹는다.
      구 DB 원문 통째 덮어쓰기 아님. 결과가 구 DB 현재 원문과 완전히 같은지 대조해 확인한다.

  python sync_pkg_dmf0082.py build   # 신규 DB 원문 재조회 → 00_BACKUP / 01_BODY 생성 + 구 DB 원문 대조
  python sync_pkg_dmf0082.py apply   # FRESH-GATE 통과 시 신규 DB 에 적용 + 컴파일 확인
"""
import sys, os, hashlib, json, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
PKG, TYP = "PKG_DMF0082", "PACKAGE BODY"
NEW_HOST, OLD_HOST = "59.19.252.148", "222.110.191.243"
STATE = os.path.join(HERE, "_fresh_state_pkg_dmf0082.json")
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0082_BODY.sql", "01_PKG_DMF0082_BODY.sql"
STEPS = [("DMF0082_SSPMNEW_20261013", "[E20261013-DMF0082SSPMNEW]"),
         ("DMF0082_ADJYNALL_20261013", "[E20261013-DMF0082ADJYNALL]")]


def connect(host):
    u, p, d = conn_info()
    port_svc = d.split(":", 1)[1]
    return oracledb.connect(user=u, password=p, dsn=f"{host}:{port_svc}")


def read_source(cur):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS'), status FROM all_objects "
                "WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=PKG, t=TYP)
    ddl, status = cur.fetchone()
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=PKG, t=TYP)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "status": status, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}


def ident(cur):
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), (SELECT DBID FROM V$DATABASE), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') FROM dual")
    return cur.fetchone()


def load_transform(folder):
    spec = importlib.util.spec_from_file_location(folder, os.path.join(ROOT, folder, "build_apply.py"))
    m = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(m)
    return m.transform


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def build():
    with connect(NEW_HOST) as con:
        cur = con.cursor()
        host, dbid, fetched = ident(cur)
        assert host != "ol9-db", f"대상이 신규 DB 가 아님: {host}"
        s = read_source(cur)   # 기준본 = 지금 신규 DB ALL_SOURCE 에서 새로 조회한 원문
    with connect(OLD_HOST) as con:
        o = read_source(con.cursor())
    new = s["src"]
    for folder, mark in STEPS:
        before = new.count("\n")
        new = load_transform(folder)(new)
        print("  step", mark, "lines", before, "->", new.count("\n"), "marker", new.count(mark))
    same = new.rstrip() == o["src"].rstrip()
    print("RESULT == 구 DB 현재 원문:", same, "| 구 DB LAST_DDL", o["last_ddl"], o["status"])
    if not same:
        sys.exit("ABORT: 두 치환을 얹은 결과가 구 DB 원문과 다름 — 다른 차이가 있음. 적용 중단")
    stamp = f"-- SOURCE-FRESH: SCM_MGR.{PKG} {TYP} LAST_DDL={s['last_ddl']} FETCHED={fetched} DB=ZIOUI1({NEW_HOST} SERVER_HOST={host} DBID={dbid})\n"
    open(os.path.join(HERE, F_BAK), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(s["src"]) + "/\n")
    open(os.path.join(HERE, F_NEW), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(new) + "/\n")
    json.dump({"last_ddl": s["last_ddl"], "md5": s["md5"], "fetched": fetched, "dbid": dbid, "old_md5": o["md5"], "old_last_ddl": o["last_ddl"]},
              open(STATE, "w"), indent=1)
    print("BUILD OK", fetched, "NEW DB", host, dbid, "LAST_DDL", s["last_ddl"], s["status"], "lines", s["src"].count("\n"), "->", new.count("\n"))


def strip(txt):
    lines = [l for l in txt.split("\n") if not l.startswith("-- SOURCE-FRESH:")]
    t = "\n".join(lines).rstrip()
    return t[:-1].rstrip() if t.endswith("/") else t


def apply():
    st = json.load(open(STATE))
    with connect(NEW_HOST) as con:
        cur = con.cursor()
        host, dbid, _ = ident(cur)
        assert dbid == st["dbid"] and host != "ol9-db", f"대상 DB 불일치: {host} {dbid}"
        # FRESH-GATE: 적용 직전 신규 DB 원문 재조회 == build 시점 기준본 (다르면 중단·재빌드)
        now = read_source(cur)
        if now["md5"] != st["md5"] or now["last_ddl"] != st["last_ddl"]:
            sys.exit(f"FRESH-GATE FAIL: build {st['last_ddl']} {st['md5']} → now {now['last_ddl']} {now['md5']}")
        print("FRESH-GATE PASS", host, dbid)
        cur.execute("SELECT object_name||'|'||object_type FROM user_objects WHERE status='INVALID' ORDER BY 1")
        inv_before = [r[0] for r in cur]
        tobe = strip(open(os.path.join(HERE, F_NEW), encoding="utf-8").read())
        cur.execute(tobe)
        after = read_source(cur)
        print("APPLIED", F_NEW, "DB==TOBE", after["src"].rstrip() == tobe[len("CREATE OR REPLACE "):].rstrip(),
              "markers", [after["src"].count(m) for _, m in STEPS], "== 구 DB md5", after["md5"] == st["old_md5"])
        cur.execute("SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name=:n ORDER BY 1", n=PKG)
        for r in cur:
            print("  ", r)
        cur.execute("SELECT type, line, position, text FROM user_errors WHERE name=:n ORDER BY sequence", n=PKG)
        errs = cur.fetchall()
        print("USER_ERRORS", len(errs))
        for e in errs:
            print("  ", e)
        cur.execute("SELECT object_name||'|'||object_type FROM user_objects WHERE status='INVALID' ORDER BY 1")
        inv_after = [r[0] for r in cur]
        print("SCM_MGR INVALID", len(inv_before), "->", len(inv_after), "| 새로 INVALID:", sorted(set(inv_after) - set(inv_before)))


if __name__ == "__main__":
    {"build": build, "apply": apply}[sys.argv[1]]()
