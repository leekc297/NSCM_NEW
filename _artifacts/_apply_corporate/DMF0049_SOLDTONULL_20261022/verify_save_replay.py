"""[E20261022-SOLDTONULL] 저장 실호출 검증 — SQL_LOG 실전송값(LOG_SEQ 지정, dataSeq 빈 = INSERT 경로) 재실행
신규 DATA_SEQ(max+1)로만 적재되므로 기존 원장 행은 건드리지 않는다. 검증 뒤 시험 행(C·_H)을 삭제한다.
  python verify_save_replay.py 2293331
"""
import sys, re, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

TEST_USER = "minyonglee1"
seq = int(sys.argv[1])
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL")
print("DB", d, cur.fetchone()[0])
cur.execute("SELECT PARAMS FROM SCM_COM_SQL_LOG WHERE LOG_SEQ = :s", s=seq)
prm = json.loads(cur.fetchone()[0].read())
keys = re.findall(r"#\{(\w+), mode=IN", prm["procExec"])
assert len(keys) == 36, keys
assert set(x for x in prm["dataSeq"].split("^")) == {""}, "INSERT 경로(dataSeq 빈) 아님 — 기존 행 덮어쓰기 위험, 중단"
args = [TEST_USER if k == "sesUserId" else prm.get(k) for k in keys]
ver, div = prm["versionNo"].split("^")[0], prm["divisionId"].split("^")[0]
print("versionNo", ver, "division", div, "rows", len(prm["dataSeq"].split("^")), "soldtoCode", repr(prm.get("soldtoCode")))

cur.execute("SELECT NVL(MAX(DATA_SEQ),0) FROM DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO=:v AND DIVISION_ID=:d", v=ver, d=div)
max0 = cur.fetchone()[0]
rc = cur.var(oracledb.DB_TYPE_CURSOR)
cur.callproc("PKG_DMF0049.P_DMF0049_SAVE_SALES_ETC_REPORT_C", args + [rc])
print("O_RESULT_CURSOR", rc.getvalue().fetchall())

cur.execute("""SELECT DATA_SEQ, NVL(SOLDTO_CODE,'(NULL)') S, COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C
               WHERE VERSION_NO=:v AND DIVISION_ID=:d AND DATA_SEQ > :m GROUP BY DATA_SEQ, NVL(SOLDTO_CODE,'(NULL)')""", v=ver, d=div, m=max0)
got = cur.fetchall()
print("NEW ROWS (DATA_SEQ, SOLDTO, N):", got)
cur.execute("SELECT NVL(SOLDTO_CODE,'(NULL)'), COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_H WHERE VERSION_NO=:v AND DIVISION_ID=:d AND DATA_SEQ > :m GROUP BY NVL(SOLDTO_CODE,'(NULL)')", v=ver, d=div, m=max0)
print("NEW _H ROWS:", cur.fetchall())

# 시험 행 정리 (이번 호출이 만든 DATA_SEQ 만)
cur.execute("DELETE FROM DM_PLN_SALES_ETC_REPORT_H WHERE VERSION_NO=:v AND DIVISION_ID=:d AND DATA_SEQ > :m AND CREATED_BY=:u", v=ver, d=div, m=max0, u=TEST_USER)
nh = cur.rowcount
cur.execute("DELETE FROM DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO=:v AND DIVISION_ID=:d AND DATA_SEQ > :m AND CREATED_BY=:u", v=ver, d=div, m=max0, u=TEST_USER)
nc = cur.rowcount
con.commit()
print(f"CLEANUP C {nc}행 · _H {nh}행 삭제 COMMIT")
assert got and all(s == "(NULL)" for _, s, _ in got), "FAIL — SOLDTO_CODE NULL 아님"
print("PASS — 빈 Sold-To 저장 = NULL")
