"""DMF0082 조회 — **SQL Trace(10046) 기반 구간별 정밀 프로파일**.
앞선 V$SQL 델타 방식의 2대 결함을 제거:
  ① V$SQL 은 인스턴스 전역 → 타 세션 오염     ② 스냅샷 쿼리 자체가 CPU 9초 소모(오염원)
Trace 는 **내 세션만** 기록하므로 오염이 원천 배제된다.
V$DIAG_TRACE_FILE_CONTENTS 로 trace 를 SQL 로 읽어 파싱.
"""
import sys, time, json, pathlib, re, collections
sys.path.insert(0, r'C:\Projects\NSCM\_artifacts\_diagnostics')
import oracledb
from ora import conn_info

P = ['40', 'ALL', 'ALL', 'ALL', '20260701', '20270101', 'ALL', '',
     'Current', 'N', 'minyonglee1', 'minyonglee1']
TAG = 'DMF0082PROF'

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
c = con.cursor()

c.execute(f"ALTER SESSION SET TRACEFILE_IDENTIFIER='{TAG}'")
c.execute("ALTER SESSION SET STATISTICS_LEVEL=ALL")
c.execute("ALTER SESSION SET EVENTS '10046 trace name context forever, level 8'")

out = [c.var(oracledb.CURSOR) for _ in range(6)]
t0 = time.time()
c.callproc('PKG_DMF0082.P_DMF0082_GET_MAIN_DATA', P + out)
wall = time.time() - t0
nrows = len(out[0].getvalue().fetchall())
c.execute("ALTER SESSION SET EVENTS '10046 trace name context off'")
print(f"### 실행 {wall:.2f}초 / 결과 {nrows:,}행 — trace 수집 완료")

c.execute("""SELECT VALUE FROM V$DIAG_INFO WHERE NAME='Default Trace File'""")
tf = c.fetchone()[0]
fname = tf.split('\\')[-1].split('/')[-1]
print(f"    trace: {fname}")

c.execute("""SELECT PAYLOAD FROM V$DIAG_TRACE_FILE_CONTENTS
              WHERE TRACE_FILENAME=:1 ORDER BY LINE_NUMBER""", [fname])
lines = [r[0] for r in c.fetchall()]
print(f"    trace 라인 {len(lines):,}")

# ── 10046 파싱 ────────────────────────────────────────────────────────────
cur_sql = {}          # cursor# -> sql text
agg = collections.defaultdict(lambda: {'e': 0, 'c': 0, 'cr': 0, 'cu': 0, 'p': 0, 'n': 0, 'rows': 0})
i, N = 0, len(lines)
RX_PIC = re.compile(r"^PARSING IN CURSOR #(\d+) len=(\d+) dep=(\d+)")
RX_OP = re.compile(r"^(EXEC|FETCH|PARSE) #(\d+):c=(\d+),e=(\d+),p=(\d+),cr=(\d+),cu=(\d+).*?,r=(\d+)?")
while i < N:
    ln = lines[i]
    m = RX_PIC.match(ln)
    if m:
        cid, dep = m.group(1), int(m.group(3))
        body = []
        i += 1
        while i < N and not lines[i].startswith('END OF STMT'):
            body.append(lines[i])
            i += 1
        cur_sql[cid] = (' '.join(body).strip(), dep)
        i += 1
        continue
    m = RX_OP.match(ln)
    if m:
        op, cid, cpu, ela, phy, cr, cu = (m.group(1), m.group(2), int(m.group(3)),
                                          int(m.group(4)), int(m.group(5)),
                                          int(m.group(6)), int(m.group(7)))
        r = int(m.group(8)) if m.group(8) else 0
        sql, dep = cur_sql.get(cid, ('(unknown)', 9))
        k = (sql[:200], dep)
        a = agg[k]
        a['e'] += ela; a['c'] += cpu; a['cr'] += cr; a['cu'] += cu
        a['p'] += phy; a['rows'] += r
        if op == 'EXEC':
            a['n'] += 1
    i += 1

rows = [{'sql': k[0], 'dep': k[1], 'sec': v['e']/1e6, 'cpu': v['c']/1e6,
         'cr': v['cr'], 'cu': v['cu'], 'phy': v['p'], 'ex': v['n'], 'rows': v['rows']}
        for k, v in agg.items() if v['e'] > 0]
rows.sort(key=lambda x: -x['sec'])

tot = sum(x['sec'] for x in rows if x['dep'] == 0)
totall = sum(x['sec'] for x in rows)
print(f"\n{'='*120}")
print(f"DMF0082 구간별 (SQL Trace / 내 세션 전용)  wall={wall:.2f}초  "
      f"dep=0 합계 {tot:.2f}초  전체(재귀포함) {totall:.2f}초")
print(f"{'='*120}")
print(f"{'#':>3} {'초':>7} {'CPU':>7} {'회':>5} {'논리읽기':>10} {'물리':>8} {'행':>9} {'d':>2}  SQL")
print('-'*120)
for i2, x in enumerate(rows[:28], 1):
    s = re.sub(r'\s+', ' ', x['sql'])[:66]
    print(f"{i2:>3} {x['sec']:>7.2f} {x['cpu']:>7.2f} {x['ex']:>5} {x['cr']:>10,} "
          f"{x['phy']:>8,} {x['rows']:>9,} {x['dep']:>2}  {s}")

pathlib.Path('trace_prof.json').write_text(json.dumps(
    {'wall': wall, 'rows': nrows, 'total_dep0': tot, 'total_all': totall, 'prof': rows[:60]},
    ensure_ascii=False, indent=1), encoding='utf-8')
print("\n→ trace_prof.json")
con.close()
