"""DMF0074 케이스 E2E 를 '원장이 있는 버전'을 금주 MRF 로 임시 지정한 창에서 실행하고 반드시 원복한다.
   대상: DM_MST_VERSION (DIVISION_ID='40', VERSION_NO='SP_W_20260820_V002') ATTRIBUTE7 NULL -> 'Y' -> NULL
   감사컬럼(LAST_UPDATE_DATE 등)은 건드리지 않는다."""
import sys, subprocess
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
DIV, VER = "40", "SP_W_20260820_V002"
u, p, d = ora.conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
def flag():
    cur.execute("SELECT ATTRIBUTE7 FROM SCM_MGR.DM_MST_VERSION WHERE VERSION_TYPE='SP_W' AND DIVISION_ID=:d AND VERSION_NO=:v", d=DIV, v=VER); return cur.fetchone()[0]
before = flag(); print("before:", before); assert before is None
try:
    cur.execute("UPDATE SCM_MGR.DM_MST_VERSION SET ATTRIBUTE7='Y' WHERE VERSION_TYPE='SP_W' AND DIVISION_ID=:d AND VERSION_NO=:v", d=DIV, v=VER)
    assert cur.rowcount == 1; con.commit(); print("window open: ATTRIBUTE7='Y' ->", flag())
    r = subprocess.run([sys.executable, r"C:\Projects\NSCM\_artifacts\_diagnostics\excel_upload_case_e2e.py", "DMF0074", "--form", "DMF0074_40", "--sheet", "Metal Link Price"], capture_output=True, text=True, encoding="utf-8", errors="replace")
    print(r.stdout[-6000:]); print(r.stderr[-1500:])
finally:
    cur.execute("UPDATE SCM_MGR.DM_MST_VERSION SET ATTRIBUTE7=NULL WHERE VERSION_TYPE='SP_W' AND DIVISION_ID=:d AND VERSION_NO=:v", d=DIV, v=VER)
    con.commit(); print("window closed: ATTRIBUTE7 ->", flag())
    assert flag() is None
