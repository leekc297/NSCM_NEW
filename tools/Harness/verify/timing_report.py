"""CheckList 소요 시간 집계 (2026-11-06 속도 개선 ① 계측) — 측정값만 읽어 요약한다(추정 없음).

입력(화면 폴더 Doc/verify/<ID>/):
  _timing.csv          run_verify.py 가 실행마다 덧붙임 — run_at,stage,tool,start,sec,rc
  _test_timing.jsonl   Playwright 픽스처(tools/E2E/fixtures/test.ts)가 테스트마다 덧붙임
  llm_usage.csv        AI 검토 세션마다 1행(at = 끝 시각, ms = 소요 → 시작 = at - ms) · kind 별 합(2026-11-26 R234)
  .vibe/orch/events.jsonl  VM 체인 기록 — 그 화면 chain.start·chain.end(실제 경과), step.end·step.sub(단계 소요), claude.end(AI 세션)
                       체인 실제 경과 - 단계 합 = '단계 밖' 시간(2026-11-26 R234)
                       ms{total,login,open,search,wait,miss,body} · n{…횟수} · parts{로그인·화면 열기 내부 구간} · sites{종류@파일:줄 → ms}
사용:
  python tools/Harness/verify/timing_report.py SCP0016            # 가장 최근 실행
  python tools/Harness/verify/timing_report.py SCP0016 --all      # 기록된 실행 전부(실행별)
주의: wait(고정 대기)·miss(시간초과로 끝난 탐침)는 open·search 안의 것과 겹친다. miss 는 Promise.race 에서 진 쪽도 잡혀
      실제 시간을 쓰지 않은 것이 섞일 수 있다(후보 위치로만 읽는다).
"""
import collections
import csv
import datetime
import glob
import json
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))


def stage_part(d, every):
    p = os.path.join(d, '_timing.csv')
    if not os.path.exists(p):
        print('  (_timing.csv 없음 — 계측 반영 후 CheckList 실행 기록 없음)')
        return
    with open(p, encoding='utf-8-sig') as f:
        rows = list(csv.DictReader(f))
    runs = sorted({r['run_at'] for r in rows})
    for ra in (runs if every else runs[-1:]):
        rr = [r for r in rows if r['run_at'] == ra]
        tot = collections.OrderedDict()
        for r in rr:
            tot[r['stage']] = tot.get(r['stage'], 0) + float(r['sec'] or 0)
        print(f"■ 실행 {ra} — 도구 {len(rr)}개 · 합 {sum(tot.values()) / 60:.1f}분")
        print('  단계: ' + ' · '.join(f"{k} {v / 60:.1f}분" for k, v in tot.items()))
        for r in sorted(rr, key=lambda x: -float(x['sec'] or 0))[:12]:
            print(f"    {float(r['sec']) / 60:5.1f}분  [{r['stage']}] {r['tool']} (시작 {r['start']} · rc={r['rc']})")


def wall_part(d, every):
    """2026-11-21 VMO VISION_4: run_timing.json 실제 경과·단계 합·단계 밖 시간·E2E 시험 수 + delta_scope_hist.jsonl 부분 재측정 판정 이력"""
    p = os.path.join(d, 'run_timing.json')
    try:
        hist = json.load(open(p, encoding='utf-8'))
    except (OSError, ValueError):
        hist = []
    if not hist:
        print('  (run_timing.json 없음)')
    for h in (hist if every else hist[-1:]):
        un = h.get('unattributed_min')
        if un is None and h.get('wall_min') is not None:   # 반영 전 기록 = 단계 합으로 계산
            un = round(h['wall_min'] - sum((h.get('stage_min') or {}).values()), 1)
        print(f"■ 경과 {h.get('run_at')} — 실제 {h.get('wall_min')}분 · 단계 합 {h.get('stage_sum_min', round(sum((h.get('stage_min') or {}).values()), 1))}분"
              f" · 단계 밖 {un}분 · E2E 시험 {h.get('e2e_tests', '미기록')}건(재시도 {h.get('e2e_retries', '미기록')})")
    hp = os.path.join(d, 'delta_scope_hist.jsonl')
    rows = []
    try:
        with open(hp, encoding='utf-8') as f:
            for ln in f:
                try:
                    rows.append(json.loads(ln))
                except ValueError:
                    pass
    except OSError:
        pass
    print(f"■ 부분 재측정 판정 이력 {len(rows)}회" + ('' if rows else ' (delta_scope_hist.jsonl 없음)'))
    for r in (rows if every else rows[-5:]):
        print(f"    {r.get('at')} {r.get('mode')} · 규칙 {r.get('rules_n', 0)} · 행 {r.get('rows_in', 0)}(유지 {r.get('rows_keep', 0)}) · 바뀐 시험 {r.get('changed_tests', 0)} · {str(r.get('why') or '')[:120]}")


def test_part(d, every):
    p = os.path.join(d, '_test_timing.jsonl')
    if not os.path.exists(p):
        print('  (_test_timing.jsonl 없음)')
        return
    rows = []
    with open(p, encoding='utf-8') as f:
        for ln in f:
            try:
                rows.append(json.loads(ln))
            except ValueError:
                pass
    runs = sorted({r['run'] for r in rows})
    for ra in (runs if every else runs[-1:]):
        rr = [r for r in rows if r['run'] == ra]
        print(f"■ Playwright 실행 {ra} — 테스트 {len(rr)}건")
        agg = collections.Counter(); cnt = collections.Counter(); sites = collections.Counter()
        for r in rr:
            for k, v in r['ms'].items():
                agg[k] += v
            for k, v in (r.get('n') or {}).items():
                cnt[k] += v
            for k, v in (r.get('sites') or {}).items():
                sites[k] += v
        m = lambda k: f"{agg[k] / 60000:.1f}분"
        print(f"  합 {m('total')} · 로그인 {m('login')}({cnt['login']}회) · 화면 열기 {m('open')}({cnt['open']}회) · 조회 {m('search')}({cnt['search']}회)"
              f" · 고정 대기 {m('wait')}({cnt['wait']}회) · 시간초과 탐침 {m('miss')}({cnt['miss']}회) · 나머지 {m('body')}")
        print('  느린 테스트:')
        for r in sorted(rr, key=lambda x: -x['ms']['total'])[:10]:
            t = r['ms']
            print(f"    {t['total'] / 60000:5.1f}분  {r['title'][:70]} [{r['status']}{' r' + str(r['retry']) if r.get('retry') else ''}]"
                  f" — 열기 {t['open'] / 1000:.0f}s · 조회 {t['search'] / 1000:.0f}s · 대기 {t['wait'] / 1000:.0f}s")
        print('  시간을 쓴 위치(종류@파일:줄, 테스트별 상위 15곳 합산):')
        for k, v in sites.most_common(15):
            print(f"    {v / 60000:5.1f}분  {k}")


def load_events(mid, root=None):
    """events.jsonl(+ 돌려 쓴 events_*.jsonl) 중 그 화면 체인·단계·AI 세션 기록"""
    d = os.path.join(root or ROOT, '.vibe', 'orch'); out = []
    for fp in sorted(glob.glob(os.path.join(d, 'events_*.jsonl'))) + [os.path.join(d, 'events.jsonl')]:
        try:
            with open(fp, encoding='utf-8') as f:
                for ln in f:
                    if mid not in ln:
                        continue
                    try:
                        e = json.loads(ln)
                    except ValueError:
                        continue
                    if e.get('screen') == mid and e.get('type') in ('chain.start', 'chain.end', 'step.end', 'step.sub', 'claude.end'):
                        out.append(e)
        except OSError:
            pass
    return sorted(out, key=lambda e: e.get('ms') or 0)


def chains_of(ev):
    """[(runId, 시작 ms, 끝 ms 또는 None, 체인 실제 경과 ms 또는 None, step.end 목록, step.sub 목록)] · runId 없는 단계는 시각 구간으로 붙임"""
    out = collections.OrderedDict()
    for e in ev:
        if e['type'] == 'chain.start':
            out[e.get('runId') or str(e.get('ms'))] = {'t0': e.get('ms'), 't1': None, 'wall': None, 'steps': [], 'subs': []}
    for e in ev:
        if e['type'] == 'chain.end':
            c = out.get(e.get('runId') or '') or next((c for c in reversed(list(out.values())) if c['t0'] and c['t0'] <= (e.get('ms') or 0) and c['t1'] is None), None)
            if c:
                c['t1'] = e.get('ms'); c['wall'] = e.get('ms_run') or ((e.get('ms') or 0) - (c['t0'] or 0))
        elif e['type'] in ('step.end', 'step.sub'):
            c = out.get(e.get('runId') or '') or next((c for c in reversed(list(out.values())) if c['t0'] and c['t0'] <= (e.get('ms') or 0)), None)
            if c:
                c['steps' if e['type'] == 'step.end' else 'subs'].append(e)
    return [(k, c['t0'], c['t1'], c['wall'], c['steps'], c['subs']) for k, c in out.items()]


def fmt_ms(ms):
    return datetime.datetime.fromtimestamp(ms / 1000).strftime('%m-%d %H:%M:%S') if ms else '-'


def chain_part(mid, every, root=None):
    """2026-11-26 개선안 20261126083526_SELF_2(R234): VM 체인 실제 경과 · 단계별 소요 · AI 세션 · 단계 밖 시간"""
    ev = load_events(mid, root)
    ch = chains_of(ev)
    if not ch:
        print('  (events.jsonl 에 이 화면 체인 기록 없음)')
        return []
    shown = ch if every else ch[-1:]
    for rid, t0, t1, wall, steps, subs in shown:
        ssum = sum((x.get('ms_run') or 0) for x in steps)
        end = t1 or max([(x.get('ms') or 0) for x in steps] or [t0 or 0])
        wall_ms = wall if wall is not None else (end - (t0 or end))
        out_ms = wall_ms - ssum
        print(f"■ 체인 {rid} {fmt_ms(t0)} ~ {fmt_ms(t1) if t1 else '끝 기록 없음(마지막 단계 ' + fmt_ms(end) + ')'} — 실제 경과 {wall_ms / 60000:.1f}분 · 단계 {len(steps)}개 합 {ssum / 60000:.1f}분 · 단계 밖 {out_ms / 60000:.1f}분")
        for x in sorted(steps, key=lambda x: -(x.get('ms_run') or 0))[:12]:
            print(f"    {(x.get('ms_run') or 0) / 60000:5.1f}분  [{x.get('no')}] {str(x.get('name') or x.get('task') or '')[:70]} ({x.get('actor', '')} · {x.get('status', '')} · 끝 {fmt_ms(x.get('ms'))})")
        for x in subs[:20]:
            print(f"      하위 {(x.get('ms_run') or 0) / 60000:5.1f}분  {str(x.get('name') or x.get('label') or '')[:70]}")
        cl = [e for e in ev if e['type'] == 'claude.end' and (t0 or 0) <= (e.get('ms') or 0) <= (end or 0)]
        if cl:
            print(f"  AI 세션(claude.end) {len(cl)}건 합 {sum((e.get('ms_run') or 0) for e in cl) / 60000:.1f}분(단계 시간 안에 겹쳐 있음)")
            for e in sorted(cl, key=lambda e: -(e.get('ms_run') or 0))[:8]:
                print(f"    {(e.get('ms_run') or 0) / 60000:5.1f}분  {str(e.get('label') or '')[:80]} (끝 {fmt_ms(e.get('ms'))} · exit {e.get('exit')})")
    return [(t0, t1 or max([(x.get('ms') or 0) for x in steps] or [t0 or 0])) for _r, t0, t1, _w, steps, _s in shown]


def llm_part(d, windows):
    """llm_usage.csv — 시작 = at - ms. 체인 구간이 있으면 그 구간에서 시작한 세션만, 없으면 마지막 기록일 하루"""
    p = os.path.join(d, 'llm_usage.csv')
    if not os.path.exists(p):
        print('  (llm_usage.csv 없음)')
        return
    rows = []
    with open(p, encoding='utf-8-sig') as f:
        for r in csv.DictReader(f):
            try:
                end = datetime.datetime.strptime(r['at'], '%Y-%m-%d %H:%M:%S').timestamp() * 1000
            except (KeyError, ValueError):
                continue
            ms = float(r.get('ms') or 0)
            rows.append((end - ms, end, ms, r))
    if not rows:
        print('  (llm_usage.csv 기록 0행)')
        return
    wins = [w for w in windows if w[0]] or [(max(x[1] for x in rows) - 86400000, max(x[1] for x in rows))]
    for a, b in wins:
        sel = [x for x in rows if a <= x[0] <= b]
        agg = collections.OrderedDict()
        for st, en, ms, r in sel:
            k = r.get('kind') or '?'
            g = agg.setdefault(k, {'n': 0, 'ms': 0.0, 'cached': 0, 't0': st, 't1': en})
            g['n'] += 1; g['ms'] += ms; g['cached'] += 1 if r.get('cached') == 'Y' else 0
            g['t0'] = min(g['t0'], st); g['t1'] = max(g['t1'], en)
        print(f"■ AI 검토 세션(llm_usage.csv) {fmt_ms(a)} ~ {fmt_ms(b)} — {len(sel)}건 · 소요 합 {sum(x[2] for x in sel) / 60000:.1f}분")
        for k, g in sorted(agg.items(), key=lambda kv: -kv[1]['ms']):
            print(f"    {g['ms'] / 60000:5.1f}분  {k} {g['n']}건(캐시 {g['cached']}) · 처음 시작 {fmt_ms(g['t0'])} · 마지막 끝 {fmt_ms(g['t1'])}")


def main():
    a = [x for x in sys.argv[1:] if not x.startswith('--')]
    if not a:
        print(__doc__)
        return 2
    mid = a[0].upper(); every = '--all' in sys.argv
    d = os.path.join(ROOT, 'Doc', 'verify', mid)
    print(f"== CheckList 시간 집계 {mid} ({os.path.relpath(d, ROOT)})")
    stage_part(d, every)
    wall_part(d, every)
    test_part(d, every)
    wins = chain_part(mid, every)
    llm_part(d, wins)
    return 0


if __name__ == '__main__':
    sys.exit(main())
