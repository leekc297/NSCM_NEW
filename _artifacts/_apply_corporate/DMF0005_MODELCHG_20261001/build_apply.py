"""DMF0005 Model Code Change — PKG_DMF0005 에 P_DMF0005_SAVE_MODEL_CHANGE_POPUP 추가 (사내 ZIOUI1)

사용:
  python build_apply.py build   # DB 원문 재조회(ALL_SOURCE) → 00_BACKUP / 01_spec / 02_body SQL 생성
  python build_apply.py apply   # FRESH-GATE(적용 직전 재조회 = build 기준본 일치) 통과 시 spec → body 적용 + 컴파일 오류 확인

hook #152: 기준본 = 착수 시 DB 에서 새로 읽은 원문만. 로컬 사본 기준 금지.
"""
import sys, os, hashlib, json, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0005"
PROC = "P_DMF0005_SAVE_MODEL_CHANGE_POPUP"
STATE = os.path.join(HERE, "_fresh_state.json")

SPEC_DECL = f"""
  -- 2026.10.01 Claude(Code) [DMF0005] Model Code Change 팝업 저장 (AS-IS DMF0005_SAVE_MODEL_CHANGE_POPUP)
  PROCEDURE {PROC} (
      P_DATA            IN CLOB
    , P_USER_ID         IN VARCHAR2
    , O_RESULT_CURSOR   OUT SYS_REFCURSOR
  );

"""


def connect():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def read_source(cur):
    """DB 원문 재조회 — ALL_SOURCE + LAST_DDL_TIME (유일한 기준본)."""
    out = {}
    for typ in ("PACKAGE", "PACKAGE BODY"):
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects "
                    "WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=PKG, t=typ)
        ddl = cur.fetchone()[0]
        cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=PKG, t=typ)
        src = "".join(r[0] for r in cur)
        out[typ] = {"last_ddl": ddl, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}
    return out


def splice(src, insert_text, kind):
    if PROC in src:
        sys.exit(f"ABORT: {PROC} 가 이미 {kind} 에 존재 — 재조회 원문 확인 필요")
    m = list(re.finditer(rf"(?im)^\s*END\s+{PKG}\s*;\s*$", src))
    if len(m) != 1:
        sys.exit(f"ABORT: {kind} 의 'END {PKG};' 위치를 1곳으로 특정할 수 없음 ({len(m)})")
    pos = m[0].start()
    return src[:pos].rstrip() + "\n" + insert_text + "\n" + src[pos:].lstrip("\n")


def ddl_text(src):
    # ALL_SOURCE 첫 줄 = 'PACKAGE "PKG_DMF0005" IS' / 'PACKAGE BODY ...' → CREATE OR REPLACE 부착
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def build():
    with connect() as con:
        cur = con.cursor()
        s = read_source(cur)
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') FROM dual")
        fetched = cur.fetchone()[0]
    body_new = open(os.path.join(HERE, "new_proc_body.plsql"), encoding="utf-8").read()
    spec = s["PACKAGE"]; body = s["PACKAGE BODY"]
    new_spec = splice(spec["src"], SPEC_DECL, "PACKAGE")
    new_body = splice(body["src"], "\n" + body_new + "\n", "PACKAGE BODY")

    def stamp(typ, info):
        return f"-- SOURCE-FRESH: SCM_MGR.{PKG} {typ} LAST_DDL={info['last_ddl']} FETCHED={fetched} DB=ZIOUI1\n"

    files = {
        "00_BACKUP_PKG_DMF0005_spec.sql": stamp("PACKAGE", spec) + ddl_text(spec["src"]) + "/\n",
        "00_BACKUP_PKG_DMF0005_body.sql": stamp("PACKAGE BODY", body) + ddl_text(body["src"]) + "/\n",
        "01_PKG_DMF0005_spec.sql": stamp("PACKAGE", spec) + ddl_text(new_spec) + "/\n",
        "02_PKG_DMF0005_body.sql": stamp("PACKAGE BODY", body) + ddl_text(new_body) + "/\n",
    }
    for fn, txt in files.items():
        open(os.path.join(HERE, fn), "w", encoding="utf-8", newline="\n").write(txt)
    json.dump({t: {k: v for k, v in s[t].items() if k != "src"} for t in s} | {"fetched": fetched},
              open(STATE, "w"), indent=1)
    print("BUILD OK fetched", fetched)
    for t in s:
        print(" ", t, s[t]["last_ddl"], s[t]["md5"], "lines", s[t]["src"].count("\n"))
    print("  spec +", new_spec.count("\n") - spec["src"].count("\n"), "lines / body +",
          new_body.count("\n") - body["src"].count("\n"), "lines")


def strip_stamp_and_slash(txt):
    lines = [l for l in txt.split("\n") if not l.startswith("-- SOURCE-FRESH:")]
    txt = "\n".join(lines).rstrip()
    if txt.endswith("/"):
        txt = txt[:-1].rstrip()
    return txt


def apply():
    state = json.load(open(STATE))
    with connect() as con:
        cur = con.cursor()
        # FRESH-GATE — 적용 직전 DB 원문 재조회, build 기준본과 다르면 중단 (타 작업자 변경 덮어쓰기 방지)
        now = read_source(cur)
        for t in ("PACKAGE", "PACKAGE BODY"):
            if now[t]["md5"] != state[t]["md5"] or now[t]["last_ddl"] != state[t]["last_ddl"]:
                sys.exit(f"FRESH-GATE FAIL: {t} 변경됨 (build {state[t]['last_ddl']} {state[t]['md5']} → "
                         f"now {now[t]['last_ddl']} {now[t]['md5']}). build 재실행 후 다시 적용.")
        print("FRESH-GATE PASS")
        for fn in ("01_PKG_DMF0005_spec.sql", "02_PKG_DMF0005_body.sql"):
            ddl = strip_stamp_and_slash(open(os.path.join(HERE, fn), encoding="utf-8").read())
            cur.execute(ddl)
            print("APPLIED", fn)
        cur.execute("SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects "
                    "WHERE object_name=:n ORDER BY 1", n=PKG)
        for r in cur:
            print("  ", r)
        cur.execute("SELECT type, line, position, text FROM user_errors WHERE name=:n ORDER BY type, sequence", n=PKG)
        errs = cur.fetchall()
        print("USER_ERRORS", len(errs))
        for e in errs:
            print("  ", e)


def reapply():
    """1차 적용 후 본문 보정 재적용.
    FRESH-GATE: DB 현재 원문 = 1차 적용한 01/02 그대로인지 재조회로 확인(그 사이 타 작업자 변경 없음) →
    기준본(00_BACKUP = 착수 시 DB 원문, md5 는 _fresh_state.json) 위에 보정된 프로시저로 01/02 재생성 → 적용."""
    state = json.load(open(STATE))
    prev = {"PACKAGE": "01_PKG_DMF0005_spec.sql", "PACKAGE BODY": "02_PKG_DMF0005_body.sql"}
    base = {"PACKAGE": "00_BACKUP_PKG_DMF0005_spec.sql", "PACKAGE BODY": "00_BACKUP_PKG_DMF0005_body.sql"}

    def src_of(fn):
        t = strip_stamp_and_slash(open(os.path.join(HERE, fn), encoding="utf-8").read())
        return t[len("CREATE OR REPLACE "):]

    with connect() as con:
        cur = con.cursor()
        now = read_source(cur)
        for t in prev:
            if now[t]["src"].rstrip() != src_of(prev[t]).rstrip():
                sys.exit(f"FRESH-GATE FAIL: {t} DB 원문이 1차 적용본과 다름 — 타 작업자 변경 가능. 중단.")
            b = src_of(base[t])
            if hashlib.md5((b.rstrip() + "\n").encode()).hexdigest() != state[t]["md5"] and \
               hashlib.md5(b.encode()).hexdigest() != state[t]["md5"]:
                print(f"WARN: {t} BACKUP md5 재계산 불일치(개행 차) — 원문 비교로 대체")
        print("FRESH-GATE PASS (DB = 1차 적용본)")
        body_new = open(os.path.join(HERE, "new_proc_body.plsql"), encoding="utf-8").read()
        new_spec = src_of(prev["PACKAGE"])                      # 스펙은 변경 없음
        new_body = splice(src_of(base["PACKAGE BODY"]), "\n" + body_new + "\n", "PACKAGE BODY")
        stamp = open(os.path.join(HERE, prev["PACKAGE BODY"]), encoding="utf-8").readline()
        open(os.path.join(HERE, prev["PACKAGE BODY"]), "w", encoding="utf-8", newline="\n").write(
            stamp + ddl_text(new_body) + "/\n")
        cur.execute(ddl_text(new_body).rstrip())
        print("APPLIED 02_PKG_DMF0005_body.sql (reapply)")
        cur.execute("SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects "
                    "WHERE object_name=:n ORDER BY 1", n=PKG)
        for r in cur:
            print("  ", r)
        cur.execute("SELECT type, line, position, text FROM user_errors WHERE name=:n ORDER BY type, sequence", n=PKG)
        errs = cur.fetchall()
        print("USER_ERRORS", len(errs))
        for e in errs:
            print("  ", e)


if __name__ == "__main__":
    {"build": build, "apply": apply, "reapply": reapply}[sys.argv[1]]()
