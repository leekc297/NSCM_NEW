"""신규 사내오라클(59.19.252.148) ← 구 사내오라클(222.110.191.243) 누락분 반영 : 시노님 15건 (SCP0080 / SCP0002)

구 DB 는 아래 15개 이름이 PUBLIC SYNONYM(2026-09-12 생성)으로 풀린다. 신규 DB 에는 PUBLIC 시노님이 하나도 없고
앱 계정 SCMP_APP 소유 시노님(2,301건)만 쓰는데, 이 15개 이름은 SCMP_APP 시노님도 없어 앱 계정에서 이름이 풀리지 않는다.
→ 신규 DB 방식에 맞춰 SCMP_APP 소유 시노님으로 만든다. 권한(GRANT)은 신·구 동일하여 건드리지 않는다.

  python sync_synonyms_scp0080.py check
  python sync_synonyms_scp0080.py apply
"""
import sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

NEW_HOST, OLD_HOST = "59.19.252.148", "222.110.191.243"
SY = ("SELECT SYNONYM_NAME, MAX(TABLE_NAME) FROM ALL_SYNONYMS WHERE TABLE_OWNER='SCM_MGR' "
      "AND OWNER IN ('PUBLIC','SCMP_APP') AND SYNONYM_NAME NOT LIKE 'BIN$%' GROUP BY SYNONYM_NAME")


def connect(host):
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=f"{host}:{d.split(':', 1)[1]}")


def main(mode):
    with connect(OLD_HOST) as co, connect(NEW_HOST) as cn:
        c = cn.cursor(); c.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), (SELECT DBID FROM V$DATABASE), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
        host, dbid, now = c.fetchone()
        assert host != "ol9-db", f"대상이 신규 DB 가 아님: {host}"
        a = co.cursor(); a.execute(SY); old = dict(a.fetchall())
        c.execute(SY); new = dict(c.fetchall())
        miss = sorted(k for k in old if k not in new)
        print("NEW DB", host, dbid, now, "| 이름 해석 old", len(old), "new", len(new), "| 신규에 없는 이름", len(miss))
        todo = []
        for n in miss:
            assert old[n] == n, f"시노님명≠대상명 {n}->{old[n]}"
            c.execute("SELECT OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE NOT IN ('PACKAGE BODY','INDEX')", n=n)
            tgt = c.fetchall()
            c.execute("SELECT COUNT(*) FROM ALL_OBJECTS WHERE OWNER='SCMP_APP' AND OBJECT_NAME=:n", n=n)
            clash = c.fetchone()[0]
            print("   ", n, "| 신규 DB 대상", tgt, "| SCMP_APP 동명 객체", clash)
            if tgt and not clash:
                todo.append(n)
        if mode != "apply":
            return
        for n in todo:
            c.execute(f'CREATE SYNONYM SCMP_APP."{n}" FOR SCM_MGR."{n}"')
        c.execute(SY); new2 = dict(c.fetchall())
        print("CREATED", len(todo), "| 적용 후 신규에 없는 이름", sorted(k for k in old if k not in new2))
        c.execute("SELECT COUNT(*) FROM ALL_SYNONYMS WHERE OWNER='SCMP_APP' AND TABLE_OWNER='SCM_MGR'")
        print("SCMP_APP 시노님 수", c.fetchone()[0])


if __name__ == "__main__":
    main(sys.argv[1])
