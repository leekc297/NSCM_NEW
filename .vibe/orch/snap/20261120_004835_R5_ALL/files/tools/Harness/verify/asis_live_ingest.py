# -*- coding: utf-8 -*-
"""AS-IS 실측(Doc/asislive/<ID>/latest.json) → 검증 엔진 입력 (2026-11-12 · 승인 플랜 velvet-conjuring-lake P2)

  python tools/Harness/verify/asis_live_ingest.py <ID>
산출: Doc/verify/<ID>/asis_live/
  live_calls.csv        화면 로드·조회 때 AS-IS 가 실제로 부른 SP(순번·구간·SP·건수·ms·인자)
  live_vs_static.csv    정적 사실(endpoints.csv · controls.csv · grid_columns_asis.csv) ↔ 실측 대조 — 불일치는 화면 FAIL 이 아니라 사실·검사기 결함 후보
  live_vs_diff.csv      차등 검증(diff_summary.csv) 상태 ↔ 실측 — 차등 검증이 건너뛴 SP 를 실측이 채울 수 있는지
  param_hint.csv        param_map.csv 의 미해결·AS-IS 전용 인자에 대해 실측에서 관찰된 값(값을 자동으로 채우지 않는다 — 후보 제시)
  asis_live_ingest.json 요약(건수 · 실측 시각 · 한계)
원장 행은 만들지 않는다: 같은 조건으로 TO-BE 와 맞춘 실측(조건 시나리오)이 생기기 전에는 판정할 기대값·전제가 없어 허위 FAIL·분모 왜곡이 된다(플랜 P5 에서 추가).
종료코드: 0 정상 · 3 미측정(실측 없음 — S1.live 먼저) · 2 인자 오류
"""
import csv, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
csv.field_size_limit(10 ** 8)
for _s in (sys.stdout, sys.stderr):
    try: _s.reconfigure(encoding='utf-8', errors='replace')
    except Exception: pass


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def wr(p, cols, rows):
    with open(p + '.tmp', 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=cols, extrasaction='ignore'); w.writeheader(); w.writerows(rows)
    os.replace(p + '.tmp', p)


def jl(p, d=None):
    try:
        with open(p, encoding='utf-8') as f: return json.load(f)
    except (OSError, ValueError):
        return d


FRAMEWORK_SP = re.compile(r'^(UP_FX_|SCM_SYS_GET_SPREAD_TITLE$|SCP0009_GET_SHEET_CALENDAR|UI_FP_COMMON$|FP_SQL_LOG)', re.I)  # 공통 프레임워크 호출(화면 고유 SP 아님)


INLINE_SQL = re.compile(r'^\s*(SELECT|INSERT|UPDATE|DELETE|MERGE|WITH|DECLARE|SET|IF|BEGIN)\b', re.I)
FP_LOG = re.compile(r'TH_UIS_SQL_LOG|^PR_UI_SQL_LOG$', re.I)          # FP 공통 서비스가 호출마다 남기는 로그 기록
FP_DISPATCH = re.compile(r'^PR_UI_GENERAL_COMMAND\d*$', re.I)          # FP 공통 분배 프로시저 — 실제 대상은 인자 p_proc_name


def norm_sp(s):
    """2026-11-13 보정(FP 실측 반영 때 확인): 인라인 SQL 은 마지막 '.' 뒤 조각(PROGRAM_ID 등)을 SP 이름으로 오인했다 → 문장 앞부분을 그대로 둔다."""
    s = (s or '').strip()
    if FP_LOG.search(s): return 'FP_SQL_LOG(로그 기록)'
    if INLINE_SQL.match(s) or ' ' in s: return 'SQL: ' + re.sub(r'\s+', ' ', s)[:50]
    return s.split('.')[-1].strip('[]').upper()


def live_key(c):
    """실측 호출 1건의 대조 키 — FP 분배 프로시저는 인자의 실제 프로시저 이름으로 푼다."""
    k = norm_sp(c.get('sp'))
    if FP_DISPATCH.match(k):
        ps = c.get('params') if isinstance(c.get('params'), dict) else {}
        tgt = (ps.get('p_proc_name') or '').strip()
        if tgt: return norm_sp(tgt)
    return k


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    if not args:
        print(__doc__); return 2
    mid = args[0].upper()
    latest = jl(P('Doc', 'asislive', mid, 'latest.json'))
    if not latest:
        print(f'[asis_live_ingest] {mid}: AS-IS 실측 없음(미측정) — VM "🎥 AS-IS Live Run"(S1.live) 먼저'); return 3
    rdir = P(*latest['run_dir'].split('/'))
    run = jl(os.path.join(rdir, 'run.json'), {}); calls_j = jl(os.path.join(rdir, 'calls.json'), {})
    ctl_j = jl(os.path.join(rdir, 'controls.json'), {}); grid_j = jl(os.path.join(rdir, 'grids.json'), {})
    if run.get('status') != 'OK':
        print(f"[asis_live_ingest] {mid}: 최근 실측 상태 {run.get('status')}({run.get('why', '')}) — 미측정"); return 3
    out = P('Doc', 'verify', mid, 'asis_live'); os.makedirs(out, exist_ok=True)
    calls = [c for c in calls_j.get('calls') or [] if c.get('phase') in ('load', 'find')]

    # ── 1. 실측 호출 목록 ──
    rows = []
    for i, c in enumerate(calls, 1):
        rows.append({'seq': i, 'at': c.get('at'), 'phase': c.get('phase'), 'service': c.get('service'), 'foxquery_id': c.get('foxquery_id'), 'sp': c.get('sp'),
                     'framework': 'Y' if FRAMEWORK_SP.match(c.get('sp') or '') else '', 'exec_type': c.get('exec_type'), 'rows': c.get('rows'), 'rows_kind': c.get('rows_kind'),
                     'ms': c.get('ms'), 'params': json.dumps(c.get('params') or {}, ensure_ascii=False)})
    wr(os.path.join(out, 'live_calls.csv'), ['seq', 'at', 'phase', 'service', 'foxquery_id', 'sp', 'framework', 'exec_type', 'rows', 'rows_kind', 'ms', 'params'], rows)
    live_sp = {}
    for c in calls:
        live_sp.setdefault(live_key(c), []).append(c)

    # ── 2. 정적 사실 ↔ 실측 ──
    fs = P('Doc', 'asisfacts', 'screens', mid); cmp_rows = []
    def add(kind, item, static, live, verdict, note=''):
        cmp_rows.append({'kind': kind, 'item': item, 'static': static, 'live': live, 'verdict': verdict, 'note': note})
    # 2-a SP: 정적 호출 지점(endpoints.csv) ↔ 실측 호출
    eps = rd(os.path.join(fs, 'endpoints.csv')); static_sp = {}
    for e in eps:
        if (e.get('variant') or '') not in ('current', 'only', 'current(sln미등록)'): continue
        m = re.match(r'SP\s+(\S+)', e.get('sp_or_sql') or '')
        if m: static_sp.setdefault(norm_sp(m.group(1)), []).append(f"{os.path.basename(e.get('file') or '')}:{e.get('line')} {e.get('member')}")
    if not eps:
        add('SP', '(endpoints.csv)', '없음', f'{len(live_sp)}종', 'ERROR', '정적 사실 파일 없음(미측정) — Fact Pack 먼저')
    for sp, cs in sorted(live_sp.items()):
        if sp in static_sp: add('SP', sp, static_sp[sp][0], f"{len(cs)}회 · 구간 {'/'.join(sorted({c['phase'] for c in cs}))}", 'MATCH')
        elif FRAMEWORK_SP.match(sp): add('SP', sp, '', f'{len(cs)}회', 'FRAMEWORK', '공통 프레임워크 호출 — 화면 소스의 직접 호출이 아님')
        elif sp.startswith('SQL: ') or not re.match(r'^[A-Z0-9_]+$', sp): add('SP', sp[:60], '', f'{len(cs)}회', 'INLINE', '인라인 SQL(이름 없는 호출)')
        else: add('SP', sp, '', f"{len(cs)}회 · 구간 {'/'.join(sorted({c['phase'] for c in cs}))}", 'LIVE_ONLY', '실측에는 있는데 정적 사실(endpoints.csv)에 없음 — 공통 클래스 경유 호출이거나 정적 추출 누락 후보')
    for sp, sites in sorted(static_sp.items()):
        if sp not in live_sp: add('SP', sp, sites[0], '0회', 'NOT_CALLED', '로드·조회에서는 호출되지 않음(버튼·더블클릭·저장 등 다른 동작의 SP — 누락 아님)')
    # 2-b 컨트롤: Designer 선언(controls.csv) ↔ 실측 컨트롤 트리
    sc = {r['name'] for r in rd(os.path.join(fs, 'controls.csv')) if r.get('name') and (r.get('variant') or '') in ('current', 'only', 'current(sln미등록)')}
    lc = {c['name'] for c in ctl_j.get('controls') or [] if c.get('name')}
    if sc:
        add('CONTROL', '(선언 ↔ 실측)', f'{len(sc)}개', f'{len(lc)}개', 'INFO', f'공통 {len(sc & lc)} · 선언만 {len(sc - lc)} · 실측만 {len(lc - sc)}')
        for n in sorted(lc - sc)[:60]: add('CONTROL', n, '', '있음', 'LIVE_ONLY', '실행 중 생성(코드로 추가)됐거나 상위 클래스·사용자 컨트롤 내부 컨트롤')
    # 2-c 조회조건: 실측 라벨(필수 * 포함)
    for it in ctl_j.get('layout_items') or []:
        if it.get('control'):
            add('CONDITION', it.get('control'), 'Y' if it.get('control') in sc else '', (it.get('label') or '') + (' [필수]' if it.get('required') else ''), 'LIVE',
                f"layout={it.get('layout')} visible={it.get('visible')}")
    # 2-d 그리드: 실측 시트·컬럼 수 ↔ 정적 컬럼 사실 행 수
    gcs = rd(os.path.join(fs, 'grid_columns_asis.csv'))
    for g in grid_j.get('grids') or []:
        for s in g.get('sheets') or []:
            cols = s.get('columns') or []; vis = [c for c in cols if str(c.get('visible')) != 'False']
            st = [r for r in gcs if (r.get('sheet') or '') in ('', s.get('name'))]
            add('GRID', f"{g.get('name')}/{s.get('name')}", f'정적 컬럼 사실 {len(st)}행(시트 미지정 포함)', f"컬럼 {len(cols)}(보임 {len(vis)}) · 헤더 {s.get('header_rows')}단 · 행 {s.get('rows')} · 고정 {s.get('frozen_cols')}",
                'LIVE', '실측 = 메타·코드가 실제로 만든 최종 컬럼(조건 분기 적용 결과)')
    wr(os.path.join(out, 'live_vs_static.csv'), ['kind', 'item', 'static', 'live', 'verdict', 'note'], cmp_rows)

    # ── 3. 차등 검증 상태 ↔ 실측 ──
    pairs = [r for r in rd(P('tools', 'Harness', 'rules', 'sp_pair.csv')) if (r.get('menu_id') or '').upper() == mid]
    dsum = rd(P('Doc', 'verify', mid, 'diff', 'diff_summary.csv')); dv = {}
    for d in dsum:
        dv.setdefault(norm_sp(d.get('asis_sp')), []).append(d)
    dr = []
    for pr in pairs:
        sp = norm_sp(pr.get('asis_sp')); ds = dv.get(sp, []); cs = live_sp.get(sp, [])
        verds = {}
        for d in ds: verds[d.get('verdict')] = verds.get(d.get('verdict'), 0) + 1
        skip_why = sorted({(d.get('note') or '')[:80] for d in ds if d.get('verdict') == 'SKIP'})
        if cs and ds and set(verds) <= {'SKIP'}:
            gap = 'LIVE_CAN_FILL'; note = '차등 검증은 전부 건너뜀 · AS-IS 실측에 결과(건수·인자) 있음 → 같은 조건 실측(조건 시나리오)으로 대조 가능'
        elif cs and not ds:
            gap = 'LIVE_ONLY'; note = '차등 검증 호출 없음(E2E 가 이 PROC 을 부르지 않음) · AS-IS 실측에는 있음'
        elif cs:
            gap = 'BOTH'; note = '차등 검증·실측 모두 있음'
        elif ds:
            gap = 'DIFF_ONLY'; note = '실측(로드·조회)에서는 호출되지 않음 — 다른 동작의 SP'
        else:
            gap = 'NONE'; note = '차등 검증·실측 모두 없음(미검증)'
        dr.append({'asis_sp': pr.get('asis_sp'), 'tobe_proc': pr.get('tobe_proc'), 'kind': pr.get('kind'), 'diff_calls': len(ds), 'diff_verdicts': ' '.join(f'{k}:{v}' for k, v in sorted(verds.items())),
                   'diff_skip_why': ' | '.join(skip_why)[:240], 'live_calls': len(cs), 'live_phase': '/'.join(sorted({c['phase'] for c in cs})), 'live_rows': ','.join(str(c.get('rows')) for c in cs[:5]),
                   'live_params': json.dumps((cs[-1].get('params') if cs else {}) or {}, ensure_ascii=False)[:600], 'gap': gap, 'note': note})
    wr(os.path.join(out, 'live_vs_diff.csv'), ['asis_sp', 'tobe_proc', 'kind', 'diff_calls', 'diff_verdicts', 'diff_skip_why', 'live_calls', 'live_phase', 'live_rows', 'live_params', 'gap', 'note'], dr)

    # ── 4. 인자 후보 ──
    procs = {(pr.get('tobe_proc') or '').upper(): norm_sp(pr.get('asis_sp')) for pr in pairs if pr.get('tobe_proc')}
    hints = []
    for m in rd(P('tools', 'Harness', 'rules', 'param_map.csv')):
        tp = (m.get('tobe_proc') or '').upper()
        if tp not in procs or (m.get('status') or '') == 'OK' or not m.get('asis_param'): continue
        cs = live_sp.get(procs[tp], []); an = (m.get('asis_param') or '').lstrip('@')
        vals = []
        for c in cs:
            for k, v in (c.get('params') or {}).items():
                if k.lower() == an.lower() and v not in vals: vals.append(v)
        hints.append({'tobe_proc': m.get('tobe_proc'), 'asis_sp': m.get('asis_sp'), 'asis_param': m.get('asis_param'), 'status': m.get('status'), 'default': m.get('default'),
                      'live_calls': len(cs), 'live_values': json.dumps(vals, ensure_ascii=False)[:300],
                      'hint': ('실측 값 1종(상수 후보)' if len(vals) == 1 else f'실측 값 {len(vals)}종(조건 의존)' if vals else ('실측 호출 없음(미측정)' if not cs else '실측 호출에 이 인자 없음'))})
    wr(os.path.join(out, 'param_hint.csv'), ['tobe_proc', 'asis_sp', 'asis_param', 'status', 'default', 'live_calls', 'live_values', 'hint'], hints)

    cnt = {}
    for r in cmp_rows: cnt[f"{r['kind']}:{r['verdict']}"] = cnt.get(f"{r['kind']}:{r['verdict']}", 0) + 1
    gaps = {}
    for r in dr: gaps[r['gap']] = gaps.get(r['gap'], 0) + 1
    summ = {'id': mid, 'run_dir': latest['run_dir'], 'live_at': run.get('started'), 'user': run.get('user_id'), 'find': run.get('find'), 'mixed_risk': bool(run.get('other_launchers')),
            'live_calls': len(calls), 'live_sp_distinct': len(live_sp), 'static_vs_live': cnt, 'diff_gap': gaps, 'param_hints': len(hints),
            'limits': ['실측 조건 = AS-IS 화면 기본값(조건 시나리오 미적용) — TO-BE E2E 조건과 같다는 보장 없음', '호출 기록은 시간 구간 기준(다른 런처 동시 조작 시 섞임)', '원장 행 미생성(같은 조건 실측 전에는 판정 근거 없음)']}
    with open(os.path.join(out, 'asis_live_ingest.json'), 'w', encoding='utf-8') as f:
        json.dump(summ, f, ensure_ascii=False, indent=1)
    print(f"[asis_live_ingest] {mid}: 실측 {run.get('started')} · 호출 {len(calls)}건(SP {len(live_sp)}종) · 정적↔실측 {cnt} · 차등 검증 공백 {gaps} · 인자 후보 {len(hints)} → {os.path.relpath(out, ROOT)}")
    print('@@LINK 📂 AS-IS 실측 대조|' + os.path.relpath(out, ROOT).replace('\\', '/'))
    return 0


if __name__ == '__main__':
    sys.exit(main())
