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
import collections
HERE = os.path.dirname(os.path.abspath(__file__))
H = json.load(open(os.path.join(os.path.dirname(HERE), 'Harness', 'harness.json'), encoding='utf-8-sig'))
OUT_DIR = os.path.join(os.path.dirname(H['genOutDir']), 'golden')
WRITE = '--write' in sys.argv
args = [a for a in sys.argv[1:] if not a.startswith('--')]
only_case = None
if '--case' in sys.argv: only_case = sys.argv[sys.argv.index('--case') + 1]; args = [a for a in args if a != only_case]
MAX_ROWS = 200000  # 2026-10-28: 5000 상한이 양쪽의 '앞 5000행' 창을 달리 잘라 395/395행 허위 차이를 만들던 결함 — 전량 비교(상한 도달 시 md 에 표기)

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
            if val is None:  # 이름이 조금 다른 인자(AS-IS p_valid ↔ TO-BE P_VALID_YN) — 접두 일치로 잇는다(2026-10-26)
                cand = [v for k2, v in lp.items() if k2 and (k.startswith(k2) or k2.startswith(k))]
                val = cand[0] if len(cand) == 1 else None
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

def _rows_of(sets):
    try: return sum(len(x[-1]) for x in (sets or []) if not (len(x) == 3 and re.search(r'RESULT_CURSOR$', str(x[0])))) if sets else ''  # TO-BE 상태 커서(O_RESULT_CURSOR 1행)는 건수에서 제외(2026-10-28: 5000↔5001 · 1↔2 허위 건수 차이)  # AS-IS (cols, rows) · TO-BE (name, cols, rows) 모두 마지막 원소가 행
    except Exception: return ''

SENTINEL = ('', '-', '/')  # 빈 값 센티널(AS-IS '' ↔ TO-BE '-'/'/') 은 같은 값으로 본다(2026-10-15 지시)
def snorm(v): return '' if v in SENTINEL else v
ORDERPROF = []  # compare() 가 결과셋별 데이터 기준(공통/전용)·실제 순서 대조를 쌓는다 → <sp>.order.csv (A6 실측 순서 · A1 데이터 기준)


def _order_check(setno, a, t, ac, tc, common, ai, ti, md):
    """같은 인자로 받은 두 결과의 ① 데이터 기준(공통·한쪽 전용 행) ② 공통·유일 행의 상대 순서 — 2026-10-28 사용자: 'AS-IS 와 TO-BE 의 데이터가 조회되는 기준이 달라 비교 불가 → 정합검증에 추가'"""
    A = [tuple(r[j] for j in ai) for r in a[1]]; T = [tuple(r[j] for j in ti) for r in t[2]]
    An = [tuple(snorm(v) for v in r) for r in A]; Tn = [tuple(snorm(v) for v in r) for r in T]
    ca, ct_ = collections.Counter(An), collections.Counter(Tn)
    both = [k for k in ca if k in ct_]
    common_rows = sum(min(ca[k], ct_[k]) for k in both)
    uniq = {k for k in both if ca[k] == 1 and ct_[k] == 1}
    seqA = [k for k in An if k in uniq]; seqT = [k for k in Tn if k in uniq]
    first = next((i for i in range(min(len(seqA), len(seqT))) if seqA[i] != seqT[i]), -1)
    # 센티널 차이 — 같은 행(정규화 일치)에서 원값이 ''↔'-'/'/' 로 다른 컬럼과 행수(AS-IS '' 행이 MSSQL 에서는 '-' 행보다 앞에 정렬되므로 순서 차이의 원인이 된다)
    rawA = {}; rawT = {}
    for r, rn in zip(A, An):
        if rn in uniq: rawA[rn] = r
    for r, rn in zip(T, Tn):
        if rn in uniq: rawT[rn] = r
    sent_cnt = collections.Counter()
    for k in uniq:
        ra, rt = rawA[k], rawT[k]
        for idx in range(len(common)):
            if ra[idx] != rt[idx] and ra[idx] in SENTINEL and rt[idx] in SENTINEL: sent_cnt[ac[common[idx]]] += 1
    sent_cols = [f"{c}({n}행 AS-IS '{next(rawA[k][common.index(nkey(c))] for k in uniq if rawA[k][common.index(nkey(c))] != rawT[k][common.index(nkey(c))])}'↔TO-BE '{next(rawT[k][common.index(nkey(c))] for k in uniq if rawA[k][common.index(nkey(c))] != rawT[k][common.index(nkey(c))])}')" for c, n in sent_cnt.most_common(6)]
    # NULL/빈 값 정렬 위치 — MSSQL 은 '' 를 맨 앞, Oracle 은 ''=NULL 을 맨 뒤(NULLS LAST)에 둔다(2026-10-28 SCP0007 CUSTOMER 110행 실측) → 같은 ORDER BY 라도 실제 순서가 달라지는 원인
    null_cols = []
    for idx, k in enumerate(common):
        ea = [i for i, r in enumerate(A) if r[idx] == '']; et = [i for i, r in enumerate(T) if r[idx] == '']
        if len(ea) >= 2 and len(et) >= 2 and len(ea) < len(A) and len(et) < len(T):
            ra = sum(ea) / len(ea) / max(1, len(A) - 1); rt = sum(et) / len(et) / max(1, len(T) - 1)
            if (ra < 0.35 and rt > 0.65) or (ra > 0.65 and rt < 0.35): null_cols.append(f"{ac[k]}(빈 값 {len(ea)}행 AS-IS {'앞' if ra < 0.5 else '뒤'}↔TO-BE {'앞' if rt < 0.5 else '뒤'})")
    cap = len(a[1]) >= MAX_ROWS or len(t[2]) >= MAX_ROWS
    verdict = 'NA' if len(uniq) < 2 else ('PASS' if first < 0 and len(seqA) == len(seqT) else 'DIFF')
    ex = ''
    if first >= 0:
        ex = f"r{first}: AS-IS={[x[:20] for x in seqA[first][:6]]} ↔ TO-BE={[x[:20] for x in seqT[first][:6]]}"
    md.append(f"- 데이터 기준: 공통 {common_rows}행 · AS-IS 전용 {len(A) - common_rows}행 · TO-BE 전용 {len(T) - common_rows}행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급){' · ⚠ 행 상한 ' + str(MAX_ROWS) + ' 도달' if cap else ''}")
    md.append(f"- 실제 순서(공통·유일 {len(uniq)}행의 상대 순서): " + ('일치' if verdict == 'PASS' else ('불일치 — 첫 차이 ' + ex) if verdict == 'DIFF' else '비교 불가(공통 행 2 미만)')
              + (f" · 센티널 차이 컬럼 {', '.join(sent_cols[:6])} — 빈 값 표기가 달라 정렬 위치가 달라질 수 있음(TO-BE 센티널 정책 2026-10-15)" if sent_cols else '')
              + (f" · NULL 정렬 위치 차이 {', '.join(null_cols[:4])} — MSSQL '' 맨 앞 ↔ Oracle NULL 맨 뒤(NULLS LAST): PKG ORDER BY 에 NULLS FIRST 또는 NVL 센티널 적용 대상" if null_cols else ''))
    ORDERPROF.append({'set': setno, 'asis_rows': len(A), 'tobe_rows': len(T), 'common_rows': common_rows, 'asis_only': len(A) - common_rows, 'tobe_only': len(T) - common_rows,
                      'uniq_rows': len(uniq), 'order': verdict, 'first_mismatch': ex[:400], 'sentinel_cols': ','.join(sent_cols), 'null_order_cols': ','.join(null_cols), 'capped': 'Y' if cap else ''})


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
        _order_check(i + 1, a, t, ac, tc, common, ai, ti, md)  # 데이터 기준 · 실제 순서(2026-10-28)
        # A7 컬럼별 결과 값 (2026-10-27) — DEV↔사내 데이터가 달라 행 값 직접 비교는 차이가 많다 → 데이터 무관 판정 2가지
        #   ① 공란 컬럼: AS-IS 에 값이 있는 컬럼이 TO-BE 전 행 공란이면 FAIL (예: DM-169 Version 컬럼 공란)
        #   ② 같은 키 행 대조: 키 후보 복합 키로 겹치는 행의 컬럼별 불일치 — 1행이라도 있으면 REVIEW(예시 포함)
        def filled(rows_, j):
            return sum(1 for r in rows_ if nval(r[j]) not in ('', '-', '/')) / max(len(rows_), 1)  # 센티널 '-'·'/' = 공란
        # 키 = 키 후보(_ID·CODE·NO·YYYYMMDD·이름) 컬럼을 고유값 많은 순으로 더해 AS-IS 행이 유일해지는 복합 키(EG040 · 2026-11-02 — 단일 키는 복합 키 화면에서 대조 행 0)
        keyc = []
        if a[1]:
            kc = [k for k in common if re.search(r'(id|code|no|yyyymmdd|name|type|measure|site)$', k)]
            kc.sort(key=lambda k: -len({nval(r[a[0].index(ac[k])]) for r in a[1]}))
            for k in kc[:8]:
                keyc.append(k)
                ja_ = [a[0].index(ac[x]) for x in keyc]
                if len({tuple(nval(r[j]) for j in ja_) for r in a[1]}) / len(a[1]) >= 0.99:
                    break
            else:
                keyc = []  # 8개로도 유일하지 않으면 같은 행을 특정할 수 없다
        amap = tmap = {}
        if keyc:
            ka, kt = [a[0].index(ac[k]) for k in keyc], [t[1].index(tc[k]) for k in keyc]
            amap = {tuple(nval(r[j]) for j in ka): r for r in a[1]}
            tmap = {tuple(nval(r[j]) for j in kt): r for r in t[2]}
        both = [k for k in amap if k in tmap]
        for k in common:
            ja, jt = a[0].index(ac[k]), t[1].index(tc[k])
            fa, ft = filled(a[1], ja), filled(t[2], jt)
            misk = [kk for kk in both if nval(amap[kk][ja]) != nval(tmap[kk][jt])]; mis = len(misk)
            mex = ' 예: ' + ' / '.join(f"{'|'.join(str(x)[:18] for x in kk[:3])}: '{str(nval(amap[kk][ja]))[:18]}'↔'{str(nval(tmap[kk][jt]))[:18]}'" for kk in misk[:2]) if misk else ''
            if fa >= 0.05 and ft == 0 and len(t[2]) > 0:
                v, note = 'FAIL', f"공란 컬럼 — AS-IS 값 있음 {fa:.1%} ↔ TO-BE 전 행 공란"
            elif fa > 0 and ft == 0 and len(t[2]) > 0:
                v, note = 'REVIEW', f"AS-IS 소수 행만 값 있음({fa:.2%}) ↔ TO-BE 전 행 공란 — DEV·사내 데이터 차이일 수 있음(같은 키 행 확인)"
            elif len(both) >= 1 and mis >= 1 and k not in keyc:  # 소수 행 차이도 근거와 함께 남긴다 — DEV↔사내 데이터 차이일 수 있어 FAIL 로 단정하지 않는다
                v, note = 'REVIEW', f"같은 키({'+'.join(keyc[:4])}) {len(both)}행 중 {mis}행 값 다름({mis / len(both):.0%}){mex}"
            else:
                v, note = 'PASS', f"채움 AS-IS {fa:.0%} ↔ TO-BE {ft:.0%}" + (f" · 같은 키 {len(both)}행 중 다름 {mis}" if both else '')
            COLPROF.append({'set': i + 1, 'column': ac[k], 'asis_fill': f"{fa:.3f}", 'tobe_fill': f"{ft:.3f}", 'key_rows': len(both), 'mismatch': mis, 'verdict': v, 'note': note})
        empties = [p['column'] for p in COLPROF if p['set'] == i + 1 and p['verdict'] == 'FAIL']
        if empties:
            md.append(f"- A7 공란 컬럼(AS-IS 값 있음 · TO-BE 전 행 공란): {', '.join(empties)}")
    return verdict, md


COLPROF = []  # compare() 가 결과셋 공통 컬럼별 채움·불일치 프로파일을 쌓는다 → <sp>.cols.csv

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
    a_sets = t_sets = None
    if c['kind'] == 'SAVE' and not WRITE: verdict = 'SKIP'; md.append('- SAVE 류 — `--write` 없이 건너뜀')
    elif not proc: verdict = 'SKIP'; md.append('- To-Be proc 미매칭 — golden_cases.csv 의 tobe_proc 를 지정(manual=Y)')
    elif any(v == '' for v in params.values()) and (c.get('manual') or '').upper() != 'Y': verdict = 'SKIP'; md.append('- 파라미터 값 미정 — param_defaults.json 또는 golden_cases.csv params 보완 (manual=Y 면 빈값도 의도된 값으로 실행)')
    else:
        try:
            a_sets = run_asis(ca, sp, params)
            try:
                t_sets, missing = run_tobe(ct, proc, params)
                if missing: md.append(f"- To-Be 인자 중 값 없음(NULL 전달): {', '.join(missing)}")
                COLPROF.clear(); ORDERPROF.clear(); verdict, lines = compare(a_sets, t_sets); md += lines
            finally:
                if c['kind'] == 'SAVE': ct.rollback()
        except Exception as e:
            verdict = 'ERR'; md.append(f"- 오류: {dbconn.mask(str(e), cfg).splitlines()[0][:400]}")
    os.makedirs(os.path.join(OUT_DIR, sc), exist_ok=True)
    open(os.path.join(OUT_DIR, sc, f'{sp}.md'), 'w', encoding='utf-8').write('\n'.join(md) + '\n')
    if COLPROF and a_sets is not None:  # A7 컬럼 프로파일 — 정합검증 judge 가 반입(원장 A7 행)
        with open(os.path.join(OUT_DIR, sc, f'{sp}.cols.csv'), 'w', encoding='utf-8-sig', newline='') as f:
            w = csv.DictWriter(f, fieldnames=['set', 'column', 'asis_fill', 'tobe_fill', 'key_rows', 'mismatch', 'verdict', 'note']); w.writeheader(); w.writerows(COLPROF)
        COLPROF.clear()
    if ORDERPROF and a_sets is not None:  # A6 실측 순서 · A1 데이터 기준 — judge/mapping_trace 가 반입
        with open(os.path.join(OUT_DIR, sc, f'{sp}.order.csv'), 'w', encoding='utf-8-sig', newline='') as f:
            w = csv.DictWriter(f, fieldnames=list(ORDERPROF[0].keys())); w.writeheader(); w.writerows(ORDERPROF)
    o1 = ORDERPROF[0] if ORDERPROF else {}
    summary.append({'screen': sc, 'case_id': c['case_id'], 'kind': c['kind'], 'asis_sp': sp, 'tobe_proc': proc, 'verdict': verdict, 'asis_rows': _rows_of(a_sets), 'tobe_rows': _rows_of(t_sets),
                    'common_rows': o1.get('common_rows', ''), 'asis_only': o1.get('asis_only', ''), 'tobe_only': o1.get('tobe_only', ''), 'order': o1.get('order', '')})
    ORDERPROF.clear()
    print(f"[{verdict}] {c['case_id']}")
ca.close(); ct.close()
# 2026-10-28: 화면별 병합 — 이번에 돌린 화면의 행만 바꾸고 다른 화면 행은 보존(화면마다 통째로 덮어써 다른 화면 골든 행이 사라지던 결함 · 창별 동시 실행 대비)
_sp = os.path.join(OUT_DIR, '_summary.csv'); _ran = {s['screen'] for s in summary}
_keep = []
if os.path.exists(_sp):
    with open(_sp, encoding='utf-8-sig', newline='') as f:
        _keep = [r for r in csv.DictReader(f) if r.get('screen') not in _ran]
summary_all = _keep + summary
_fn = ['screen', 'case_id', 'kind', 'asis_sp', 'tobe_proc', 'verdict', 'asis_rows', 'tobe_rows', 'common_rows', 'asis_only', 'tobe_only', 'order']
_tmp = _sp + f'.{os.getpid()}.tmp'
with open(_tmp, 'w', encoding='utf-8-sig', newline='') as f:
    w = csv.DictWriter(f, fieldnames=_fn); w.writeheader(); w.writerows([{k: s.get(k, '') for k in _fn} for s in summary_all])
os.replace(_tmp, _sp)
cnt = {k: sum(1 for s in summary_all if s['verdict'] == k) for k in ['PASS', 'COLS', 'ROWS', 'DIFF', 'ERR', 'SKIP']}
md = [f"# 골든 테스트 요약 {datetime.datetime.now():%Y-%m-%d %H:%M}", '', ' · '.join(f'{k} {v}' for k, v in cnt.items()), '', '| 화면 | As-is SP | To-Be PROC | 판정 |', '|---|---|---|---|'] + [f"| {s['screen']} | {s['asis_sp']} | {s['tobe_proc']} | {s['verdict']} |" for s in summary_all]
open(os.path.join(OUT_DIR, '_summary.md'), 'w', encoding='utf-8').write('\n'.join(md) + '\n')
print('요약:', ' · '.join(f'{k} {v}' for k, v in cnt.items()), '→', os.path.join(OUT_DIR, '_summary.md'))
