"""당일 오등록한 MSG01032 (KO/EN/CN) 삭제 — FE 검증 원복에 따른 정리 (2026-09-15)."""
import pathlib, sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "_diagnostics"))
import ora  # noqa: E402
import oracledb  # noqa: E402

u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    cur.execute("""DELETE FROM SCM_MGR.SCM_ADM_MSG_M
                   WHERE MSG_ID = 'MSG01032' AND CREATED_BY = 'admin'
                     AND TRUNC(CREATION_DATE) = DATE '2026-09-15'""")
    print("deleted", cur.rowcount)
    con.commit()
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID = 'MSG01032'")
    print("remaining", cur.fetchone()[0])
