# -*- coding: utf-8 -*-
"""
golden — As-is SP(MSSQL) 와 To-Be PKG.PROC(Oracle) 를 같은 파라미터로 실행해 결과셋을 대조한다.
  python golden.py                 golden_cases.csv 전체(GET 만; SAVE 류는 --write 없으면 건너뜀)
  python golden.py DMF0003         화면 하나
  python golden.py --case DMF0003:DMF0003_GET_BUCKET_TYPE_CODE
  옵션 --write : SAVE 류도 실행(To-Be 는 실행 후 ROLLBACK, As-is 는 readOnly 접속이라 실행 자체를 거부)
  출력: Doc\golden\<screen>\<sp>.md (컬럼/행수/키별 차이), Doc\golden\_summary.csv, _summary.md
판정: PASS(행수·컬럼·값 일치) / COLS(컬럼 차이) / ROWS(행수 차이) / DIFF(값 차이) / ERR(실행 오류) / SKIP
컬럼 비교는 대소문자·언더스코어 무시(camel ↔ snake). 숫자는 소수 6자리 반올림, 날짜는 'YYYY-MM-DD HH:MM:SS' 문자열.
"""
import sys as _sys
try: _sys.stdout.reconfigure(encoding='utf-8', errors='replace'); _sys.stderr.reconfigure(encoding='utf-8', errors='replace')
except Exception: pass
import sys, os, csv, json, re, datetime, decimal
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dbconn
HERE = os.path.dirname(os.path.abspath(__file__))
H = json.load(open(os.path.join(os.path.dirname(HERE), 'Harness', 'harness.json'), encoding='utf-8-sig'))
OUT_DIR = os.path.join(os.path.dirname(H['genOutDir']), 'golden')
WRITE = '--write' in sys.argv
args = [a for a in sys.argv[1:] if not a.startswith('--')]
only_case = None
if '--case' in sys.argv: only_case = sys.argv[sys.argv.index('--case') + 1]; args = [a for a in args if a != only_case]
MAX_ROWS = 5000

def nkey(c): return re.sub(r'[^a-z0-9]', '', str(c).lower())
def nval(v):
    if v is None: return ''
    if isinstance(v, (float, decimal.Decimal)): return f'{round(float(v), 6):.6f}'.rstrip('0').rstrip('.')
    if isinstance(v, (datetime.datetime, datetime.date)): return v.strftime('%Y-%m-%d %H:%M:%S')[:19] if isinstance(v, datetime.datetime) else v.strftime('%Y-%m-%d')
    if hasattr(v, 'read'): v = v.read()
    s = str(v).strip()
    return s

def run_asis(cx, sp, params):
    cur = cx.cursor()
    ps = list(params.items())
    sql = f"EXEC dbo.[{sp}] " + ', '.join(f'@{k}=?' for k, _ in ps)
    cur.execute(sql, [v for _, v in ps]) if ps else cur.execute(f"EXEC dbo.[{sp}]")
    sets = []
    while True:
        if cur.description:
            cols = [d[0] for d in cur.description]
            rows = cur.fetchmany(MAX_ROWS)
            sets.append((cols, [[nval(v) for v in r] for r in rows]))
        if not cur.nextset(): break
    return sets

def run_tobe(cx, proc, params):
    import oracledb
    cur = cx.cursor()
    pkg, _, name = proc.rpartition('.')
    cur.execute("""SELECT ARGUMENT_NAME, IN_OUT, DATA_TYPE, POSITION FROM ALL_ARGUMENTS
                    WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND NVL(PACKAGE_NAME,'~')=NVL(:p,'~') AND DATA_LEVEL=0 AND ARGUMENT_NAME IS NOT NULL ORDER BY POSITION""",
                n=name.upper(), p=(pkg.upper() or None))
    sig = cur.fetchall()
    if not sig: raise RuntimeError(f'ALL_ARGUMENTS 에 {proc} 없음')
    lp = {nkey(k): v for k, v in params.items()}
    call, outs, missing = [], [], []
    for argn, inout, dt, pos in sig:
        if 'OUT' in inout and dt == 'REF CURSOR':
            v = cur.var(oracledb.DB_TYPE_CURSOR); outs.append((argn, v)); call.append(v)
        else:
            k = nkey(re.sub(r'^P_', '', argn))
            val = lp.get(k, lp.get(nkey(argn)))
            if val is None: missing.append(argn); val = None
            if dt in ('NUMBER', 'PLS_INTEGER', 'BINARY_INTEGER') and val not in (None, ''): val = float(val) if '.' in str(val) else int(val)
            call.append(val)
    cur.callproc(proc, call)
    sets = []
    for argn, v in outs:
        rc = v.getvalue()
        if rc is None: sets.append((argn, [], [])); continue
        cols = [d[0] for d in rc.description]
        rows = rc.fetchmany(MAX_ROWS)
        sets.append((argn, cols, [[nval(x) for x in r] for r in rows]))
    return sets, missing

def compare(a_sets, t_sets):
    """As-is 결과셋 i ↔ To-Be O_RC{i} (O_RESULT_CURSOR 는 상태용이라 제외). 반환 (판정, 상세 md 라인)"""
    t_data = [s for s in t_sets if not re.search(r'RESULT_CURSOR$', s[0])]
    md, verdict = [], 'PASS'
    n = max(len(a_sets), len(t_data))
    for i in range(n):
        a = a_sets[i] if i < len(a_sets) else None
        t = t_data[i] if i < len(t_data) else None
        md.append(f"\n### 결과셋 {i+1}  As-is {len(a[1]) if a else '-'}행 ↔ To-Be {t[0] if t else '-'} {len(t[2]) if t else '-'}행")
        if not a or not t: verdict = 'ROWS'; md.append('- 한쪽에만 결과셋이 있음'); continue
        ac, tc = {nkey(c): c for c in a[0]}, {nkey(c): c for c in t[1]}
        only_a, only_t = [ac[k] for k in ac if k not in tc], [tc[k] for k in tc if k not in ac]
        common = [k for k in ac if k in tc]
        if only_a or only_t:
            verdict = 'COLS' if verdict == 'PASS' else verdict
            md.append(f"- As-is 에만 있는 컬럼: {', '.join(only_a) or '-'}"); md.append(f"- To-Be 에만 있는 컬럼: {', '.join(only_t) or '-'}")
        if len(a[1]) != len(t[2]):
            verdict = 'ROWS' if verdict in ('PASS', 'COLS') else verdict; md.append(f"- 행수 불일치 {len(a[1])} ↔ {len(t[2])}")
        # 값 비교: 공통 컬럼 기준으로 행을 정렬된 튜플 집합으로 비교(순서 무관)
        ai = [a[0].index(ac[k]) for k in common]; ti = [t[1].index(tc[k]) for k in common]
        A = sorted(tuple(r[j] for j in ai) for r in a[1]); T = sorted(tuple(r[j] for j in ti) for r in t[2])
        if A != T:
            verdict = 'DIFF'
            sa, st = set(A), set(T)
            da, dt = [r for r in A if r not in st][:10], [r for r in T if r not in sa][:10]
            md.append(f"- 값 차이: As-is 전용 {len(sa-st)}행 / To-Be 전용 {len(st-sa)}행 (공통 컬럼 {len(common)})")
            md.append('| 측 | ' + ' | '.join(ac[k] for k in common[:12]) + ' |'); md.append('|---' * (min(12, len(common)) + 1) + '|')
            for r in da: md.append('| A | ' + ' | '.join(str(x)[:30] for x in r[:12]) + ' |')
            for r in dt: md.append('| T | ' + ' | '.join(str(x)[:30] for x in r[:12]) + ' |')
        elif not only_a and not only_t and len(a[1]) == len(t[2]):
            md.append('- 일치')
    return verdict, md

cases = []
with open(os.path.join(OUT_DIR, 'golden_cases.csv'), encoding='utf-8-sig', newline='') as f:
    for r in csv.DictReader(f):
        if only_case and r['case_id'] != only_case: continue
        if args and r['screen'] not in args: continue
        cases.append(r)
cfg = dbconn.load_cfg()
print('As-is:', dbconn.describe('asis', cfg)); print('To-Be:', dbconn.describe('tobe', cfg))
ca = dbconn.connect('asis', cfg); ct = dbconn.connect('tobe', cfg)
summary = []
for c in cases:
    sc, sp, proc = c['screen'], c['asis_sp'], c['tobe_proc']
    params = json.loads(c['params'] or '{}')
    md = [f"# {sc} · {sp} ↔ {proc or '(미매칭)'}", '', f"- 실행: {datetime.datetime.now():%Y-%m-%d %H:%M:%S}", f"- 파라미터: `{json.dumps(params, ensure_ascii=False)}`", f"- 종류: {c['kind']}"]
    if c['kind'] == 'SAVE' and not WRITE: verdict = 'SKIP'; md.append('- SAVE 류 — `--write` 없이 건너뜀')
    elif not proc: verdict = 'SKIP'; md.append('- To-Be proc 미매칭 — golden_cases.csv 의 tobe_proc 를 지정(manual=Y)')
    elif any(v == '' for v in params.values()): verdict = 'SKIP'; md.append('- 파라미터 값 미정 — param_defaults.json 또는 golden_cases.csv params 보완')
    else:
        try:
            a_sets = run_asis(ca, sp, params)
            try:
                t_sets, missing = run_tobe(ct, proc, params)
                if missing: md.append(f"- To-Be 인자 중 값 없음(NULL 전달): {', '.join(missing)}")
                verdict, lines = compare(a_sets, t_sets); md += lines
            finally:
                if c['kind'] == 'SAVE': ct.rollback()
        except Exception as e:
            verdict = 'ERR'; md.append(f"- 오류: {dbconn.mask(str(e), cfg).splitlines()[0][:400]}")
    os.makedirs(os.path.join(OUT_DIR, sc), exist_ok=True)
    open(os.path.join(OUT_DIR, sc, f'{sp}.md'), 'w', encoding='utf-8').write('\n'.join(md) + '\n')
    summary.append({'screen': sc, 'case_id': c['case_id'], 'kind': c['kind'], 'asis_sp': sp, 'tobe_proc': proc, 'verdict': verdict})
    print(f"[{verdict}] {c['case_id']}")
ca.close(); ct.close()
with open(os.path.join(OUT_DIR, '_summary.csv'), 'w', encoding='utf-8-sig', newline='') as f:
    w = csv.DictWriter(f, fieldnames=['screen', 'case_id', 'kind', 'asis_sp', 'tobe_proc', 'verdict']); w.writeheader(); w.writerows(summary)
cnt = {k: sum(1 for s in summary if s['verdict'] == k) for k in ['PASS', 'COLS', 'ROWS', 'DIFF', 'ERR', 'SKIP']}
md = [f"# 골든 테스트 요약 {datetime.datetime.now():%Y-%m-%d %H:%M}", '', ' · '.join(f'{k} {v}' for k, v in cnt.items()), '', '| 화면 | As-is SP | To-Be PROC | 판정 |', '|---|---|---|---|'] + [f"| {s['screen']} | {s['asis_sp']} | {s['tobe_proc']} | {s['verdict']} |" for s in summary]
open(os.path.join(OUT_DIR, '_summary.md'), 'w', encoding='utf-8').write('\n'.join(md) + '\n')
print('요약:', ' · '.join(f'{k} {v}' for k, v in cnt.items()), '→', os.path.join(OUT_DIR, '_summary.md'))
