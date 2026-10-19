"""[E20261013-DMF0005MCDUP] 저장 SP 실호출 — 키가 겹치는 변경쌍만 사용 (차단되어 전체 ROLLBACK 되는 경우만 호출)

  ⚠ 겹치지 않는 변경쌍은 호출하지 않는다 — 성공하면 38개 테이블의 Model 코드가 실제로 바뀌고 COMMIT 된다.
  호출 전후로 변경 전·후 Model 의 테이블별 행 수와 이력 건수를 비교해 데이터가 그대로인지 확인한다.

  python test_call.py MPCLGE19CY2G MPCLGE19CY2M
"""
import sys, os, re, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))


def snapshot(cur, tabs, b, a):
    snap = {}
    for t in tabs:
        cur.execute(f"SELECT SUM(CASE WHEN ITEM_ID = :b THEN 1 ELSE 0 END), SUM(CASE WHEN ITEM_ID = :a THEN 1 ELSE 0 END) "
                    f"FROM SCM_MGR.{t} WHERE ITEM_ID IN (:b, :a)", b=b, a=a)
        r = cur.fetchone()
        snap[t] = (r[0] or 0, r[1] or 0)
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.DM_DNM_ITEM_CODE_CHANGE_HISTORY")
    snap["#HISTORY"] = cur.fetchone()[0]
    return snap


def main():
    b, a = sys.argv[1], sys.argv[2]
    src = open(os.path.join(HERE, "01_PKG_DMF0005_BODY.sql"), encoding="utf-8").read()
    tabs = re.findall(r"CHANGE_TABLE\('(\w+)',", src)
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-RR' NLS_DATE_LANGUAGE='AMERICAN'")
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    print("DB", d, cur.fetchone())
    # 안전 장치: SCM_MST_SITE_ITEM 에서 실제로 키가 겹치는 쌍인지 먼저 확인 (아니면 호출하지 않는다)
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SITE_ITEM X JOIN SCM_MGR.SCM_MST_SITE_ITEM Y
                   ON Y.DIVISION_ID = X.DIVISION_ID AND Y.PROJECT_CODE = X.PROJECT_CODE AND Y.SCM_SITE_ID = X.SCM_SITE_ID
                   WHERE X.DIVISION_ID = '40' AND X.ITEM_ID = :b AND Y.ITEM_ID = :a""", b=b, a=a)
    n = cur.fetchone()[0]
    if n == 0:
        sys.exit("ABORT: 키가 겹치지 않는 변경쌍 — 호출하면 실제로 변경·COMMIT 되므로 중단")
    print("SCM_MST_SITE_ITEM 겹치는 키", n, "건")
    before = snapshot(cur, tabs, b, a)
    out = cur.var(oracledb.DB_TYPE_CURSOR)
    data = json.dumps([{"ITEM_ID_BEFORE": b, "ITEM_ID_AFTER": a}])
    try:
        cur.callproc("SCM_MGR.PKG_DMF0005.P_DMF0005_SAVE_MODEL_CHANGE_POPUP", [data, "minyonglee1", out])
        rows = out.getvalue().fetchall()
        print("RESULT CURSOR:", rows)
        ok = rows and rows[0][0] == "-1" and "이미 등록되어" in rows[0][1]
    except Exception as e:
        print("EXCEPTION:", str(e).replace("\n", " / ")[:400])
        ok = False
    con.rollback()
    after = snapshot(cur, tabs, b, a)
    same = before == after
    print("데이터 불변(38개 테이블 행 수 + 이력 건수):", same, "| 변경 전 Model 행 합계", sum(v[0] for k, v in before.items() if k != "#HISTORY"))
    cur.execute("SELECT * FROM ( SELECT TO_CHAR(EVENT_DATE,'HH24:MI:SS'), LOG_TYPE, SUBSTR(REPLACE(DESCRIPTION, CHR(10), ' '), 1, 150) "
                "FROM SCM_MGR.SCM_SYS_LOG_BATCH WHERE PROGRAM_NAME = 'PKG_DMF0005' ORDER BY EVENT_DATE DESC ) WHERE ROWNUM <= 2")
    for r in cur.fetchall():
        print("   LOG", r)
    print("RESULT", "PASS" if ok and same else "FAIL")
    sys.exit(0 if ok and same else 1)


if __name__ == "__main__":
    main()
