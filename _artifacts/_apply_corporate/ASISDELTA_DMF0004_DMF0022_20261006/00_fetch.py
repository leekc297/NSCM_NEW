"""[E20261006-ASISDELTA] 착수 시 DB 원문 조회·백업 (조회 전용 — DB 변경 없음)

대상: SCM_MGR.PKG_DMF0004 (SPEC·BODY) · SCM_MGR.PKG_DMF0022 (BODY)
  python 00_fetch.py     # ALL_SOURCE + LAST_DDL_TIME 재조회 → _base_*.txt · 00_BACKUP_*.sql · _fresh_state.json
"""
import sys, os, json, hashlib, datetime

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
TARGETS = [("PKG_DMF0004", "PACKAGE"), ("PKG_DMF0004", "PACKAGE BODY"), ("PKG_DMF0022", "PACKAGE BODY")]


def read_source(cur, name, typ):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS'), status FROM all_objects "
                "WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=name, t=typ)
    ddl, status = cur.fetchone()
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=name, t=typ)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "status": status, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}


def key(name, typ):
    return name + "__" + typ.replace(" ", "_")


if __name__ == "__main__":
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT SYS_CONTEXT('USERENV','DB_NAME'), SYS_CONTEXT('USERENV','SERVER_HOST'), USER FROM DUAL")
        print("DB", cur.fetchone())
        now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        state = {"fetched": now}
        for name, typ in TARGETS:
            s = read_source(cur, name, typ)
            k = key(name, typ)
            with open(os.path.join(HERE, "_base_" + k + ".txt"), "w", encoding="utf-8", newline="\n") as f:
                f.write(s["src"])
            with open(os.path.join(HERE, "00_BACKUP_" + k + ".sql"), "w", encoding="utf-8", newline="\n") as f:
                f.write(f"-- SOURCE-FRESH: SCM_MGR.{name} {typ} LAST_DDL={s['last_ddl']} FETCHED={now} DB=ZIOUI1\n"
                        "-- 적용 전 원문 백업 (원복용)\n" + "CREATE OR REPLACE " + s["src"].rstrip() + "\n/\n")
            state[k] = {x: s[x] for x in ("last_ddl", "status", "md5")}
            print(k, s["last_ddl"], s["status"], s["md5"], len(s["src"].split("\n")), "lines")
        json.dump(state, open(os.path.join(HERE, "_fresh_state.json"), "w"), indent=1, ensure_ascii=False)
