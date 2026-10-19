# GAP 261 검증 — 전부 ROLLBACK (원장·컷오프 무변경 확인 포함)
#  V1 회귀: 202401~202412 / 202609~202702 Replace 건수 = 수정 전 재현(110,908 / 68,534)
#  V2 클라우드 모사: 같은 트랜잭션에서 _C 의 2024 빈 INCOTERMS('-') 를 NULL 로 바꾼 뒤 Replace → 오류 없음 + 원장 INCOTERMS '/' 로 적재
import sys, oracledb
sys.path.insert(0, '_artifacts/_diagnostics'); import ora
u, p, d = ora.conn_info(); cn = oracledb.connect(user=u, password=p, dsn=d); cur = cn.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL"); print('HOST', cur.fetchone()[0])
VER = 'BP_M_20260814_V002'
def q(sql, **b): cur.execute(sql, b); return cur.fetchall()
def led(f, t): return q("SELECT COUNT(*), SUM(QTY) FROM DM_PLN_BP_FCST WHERE DIVISION_ID='40' AND YYYYMM BETWEEN :f AND :t", f=f, t=t)[0]
def call(f, t):
    r1, r2 = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
    cur.callproc('PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF', ['40', 'BP_M', f, t, 'minyonglee1', VER, r1, r2])
    return r1.getvalue().fetchall()
c_before = q("SELECT COUNT(*) FROM DM_PLN_BP_FCST_C WHERE VERSION_NO=:v AND INCOTERMS='-'", v=VER)[0]
for f, t in (('202401', '202412'), ('202609', '202702')):
    b = led(f, t)
    try: print('V1', f, t, call(f, t))
    except oracledb.DatabaseError as e: print('V1', f, t, 'ERROR', str(e)[:400])
    cn.rollback(); print('   rollback same' if led(f, t) == b else '   DIFF!!')
b = led('202401', '202412')
n = q("SELECT COUNT(*) FROM DM_PLN_BP_FCST_C WHERE VERSION_NO=:v AND DIVISION_ID='40' AND YYYYMM BETWEEN '202401' AND '202412' AND INCOTERMS='-'", v=VER)[0][0]
cur.execute("UPDATE DM_PLN_BP_FCST_C SET INCOTERMS = NULL WHERE VERSION_NO=:v AND DIVISION_ID='40' AND YYYYMM BETWEEN '202401' AND '202412' AND INCOTERMS='-'", v=VER)
print('V2 simulate NULL rows', cur.rowcount, '(expected', n, ')')
try:
    print('V2 call', call('202401', '202412'))
    print('V2 ledger INCOTERMS dist', q("SELECT INCOTERMS, COUNT(*) FROM DM_PLN_BP_FCST WHERE DIVISION_ID='40' AND YYYYMM BETWEEN '202401' AND '202412' AND INCOTERMS IN ('-','/') GROUP BY INCOTERMS"))
except oracledb.DatabaseError as e: print('V2 ERROR', str(e)[:500])
cn.rollback()
print('   rollback ledger same' if led('202401', '202412') == b else '   DIFF!!', '| _C dash', q("SELECT COUNT(*) FROM DM_PLN_BP_FCST_C WHERE VERSION_NO=:v AND INCOTERMS='-'", v=VER)[0], 'before', c_before)
