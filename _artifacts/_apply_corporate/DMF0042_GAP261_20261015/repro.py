# GAP 261 재현 — Replace SP 직접 호출 후 ROLLBACK (SP 내부 COMMIT 없음 · 로그만 자율 트랜잭션). 원장 무변경 확인 포함.
import sys, oracledb
sys.path.insert(0, '_artifacts/_diagnostics'); import ora
u, p, d = ora.conn_info(); cn = oracledb.connect(user=u, password=p, dsn=d); cur = cn.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL"); print('HOST', cur.fetchone()[0])
VER = sys.argv[1] if len(sys.argv) > 1 else 'BP_M_20260814_V002'
def led(f, t):
    cur.execute("SELECT COUNT(*), SUM(QTY) FROM DM_PLN_BP_FCST WHERE DIVISION_ID='40' AND YYYYMM BETWEEN :f AND :t", f=f, t=t); return cur.fetchone()
for f, t in (('202401', '202412'), ('202609', '202702')):
    before = led(f, t)
    r1, r2 = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
    try:
        cur.callproc('PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF', ['40', 'BP_M', f, t, 'minyonglee1', VER, r1, r2])
        res = r1.getvalue().fetchall(); mid = led(f, t)
        print(f'{f}~{t}', 'RESULT', res, 'ledger before', before, 'after(uncommitted)', mid)
    except oracledb.DatabaseError as e:
        print(f'{f}~{t}', 'ERROR', str(e)[:700])
    cn.rollback()
    print('   rollback -> ledger', led(f, t), 'same' if led(f, t) == before else 'DIFF!!')
