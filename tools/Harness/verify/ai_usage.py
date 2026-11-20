# -*- coding: utf-8 -*-
"""AI 사용량·효과 취합 — AI 적용 지점(tools/Harness/rules/ai_points.csv)별 호출 수·시간·토큰·반영 건수 (2026-11-20 사용자 지시 '불필요한 AI 사용 제거')

  python tools/Harness/verify/ai_usage.py                 전체 → Doc/verify/_ai_usage.md
  python tools/Harness/verify/ai_usage.py --since 2026-11-20 --menu SCP0028
  python tools/Harness/verify/ai_usage.py --selftest

  원천
    Doc/verify/_llm_usage.csv     스크립트의 claude -p 호출(llm_call.ask) — 종류 = 지점
    Doc/verify/_llm_effect.csv    지점별 반영 건수 · 바꾼 것 없는 호출 수(llm_call.log_effect)
    .vibe/orch/events.jsonl        VM Claude 세션(claude.result · claude.end) — 체인 단계 이름으로 지점(resolve · repair · port 등)을 가른다
  비용(USD)은 표시하지 않는다(사용자 지시 2026-11-20 · 원천 파일에만 남음). 시간·호출 수·토큰·반영 건수만 쓴다.
"""
import argparse
import collections
import csv
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
csv.field_size_limit(10 ** 8)
SESSION_POINT = [(re.compile(r'검증 보완|미검증 해소'), 'resolve'), (re.compile(r'자동 보완|🧯'), 'repair'), (re.compile(r'수선|이식|FE TODO|PKG'), 'port'),
                 (re.compile(r'개선안|자가진단|사건|incident', re.I), 'orch')]


def read_csv(p):
    try:
        with open(p, encoding='utf-8-sig', newline='') as f:
            return list(csv.DictReader(f))
    except OSError:
        return []


def num(v):
    try:
        return float(v or 0)
    except ValueError:
        return 0.0


def session_point(label, src):
    for rx, pt in SESSION_POINT:
        if rx.search(label or ''):
            return pt
    return 'orch' if src == 'orch' else 'chat'


def collect(since='', menu=''):
    A = collections.defaultdict(lambda: {'calls': 0, 'cached': 0, 'fail': 0, 'ms': 0.0, 'in': 0.0, 'out': 0.0, 'applied': 0, 'nochange': 0, 'eff_calls': 0})
    for r in read_csv(os.path.join(ROOT, 'Doc', 'verify', '_llm_usage.csv')):
        if since and (r.get('at') or '') < since or (menu and r.get('menu_id') != menu) or (r.get('menu_id') or '').startswith('_SELFTEST'):
            continue
        a = A[r.get('kind') or '?']
        if r.get('cached') == 'Y':
            a['cached'] += 1; continue
        a['calls'] += 1; a['fail'] += 1 if (r.get('why') or '').strip() else 0
        a['ms'] += num(r.get('ms')); a['in'] += num(r.get('input_tokens')) + num(r.get('cache_read_tokens')) + num(r.get('cache_creation_tokens')); a['out'] += num(r.get('output_tokens'))
    for r in read_csv(os.path.join(ROOT, 'Doc', 'verify', '_llm_effect.csv')):
        if since and (r.get('at') or '') < since or (menu and r.get('menu_id') != menu) or (r.get('menu_id') or '').startswith('_SELFTEST'):
            continue
        a = A[r.get('kind') or '?']
        a['applied'] += int(num(r.get('applied'))); a['nochange'] += int(num(r.get('nochange_calls'))); a['eff_calls'] += int(num(r.get('calls')))
    S = collections.defaultdict(lambda: {'sessions': set(), 'ms': 0.0, 'turns': 0, 'fail': 0})
    ev = os.path.join(ROOT, '.vibe', 'orch', 'events.jsonl')
    try:
        fh = open(ev, encoding='utf-8')
    except OSError:
        fh = []
    for ln in fh:
        try:
            e = json.loads(ln)
        except ValueError:
            continue
        if e.get('type') not in ('claude.result', 'claude.end'):
            continue
        at = (e.get('at') or '').replace('T', ' ')[:19]
        if since and at < since or (menu and (e.get('screen') or '') != menu):
            continue
        pt = session_point(e.get('label') or '', e.get('src') or '')
        s = S[pt]
        if e['type'] == 'claude.end':
            s['ms'] += num(e.get('ms_run')); s['fail'] += 1 if e.get('exit') not in (0, None) else 0
            s['sessions'].add(e.get('session') or f"{e.get('pid')}:{e.get('ms')}")
        else:
            s['turns'] += int(num(e.get('turns')))
    return A, S


def report(since='', menu=''):
    A, S = collect(since, menu)
    pts = {r['point']: r for r in read_csv(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'ai_points.csv'))}
    L = [f"# AI 사용량·효과 ({'전체' if not since else since + ' 이후'}{' · ' + menu if menu else ''})", '',
         '원천 Doc/verify/_llm_usage.csv · _llm_effect.csv · .vibe/orch/events.jsonl. 비용은 원천 파일에만 있음.', '',
         '## 스크립트 호출(claude -p)', '', '| 지점 | 종류 | 호출 | 기억 재사용 | 실패 | 시간(분, 호출 합) | 입력 토큰 | 출력 토큰 | 반영 | 바꾼 것 없는 호출 |', '|---|---|---|---|---|---|---|---|---|---|']
    for k in sorted(A):
        a = A[k]; p = pts.get(k, {})
        L.append(f"| {k} | {p.get('kind', '')} | {a['calls']} | {a['cached']} | {a['fail']} | {a['ms'] / 60000:.1f} | {int(a['in'])} | {int(a['out'])} | {a['applied']} | {a['nochange']}/{a['eff_calls']} |")
    L += ['', '## VM Claude 세션', '', '| 지점 | 세션 | 시간(분) | 턴 | 비정상 종료 |', '|---|---|---|---|---|']
    for k in sorted(S):
        s = S[k]
        L.append(f"| {k} | {len(s['sessions'])} | {s['ms'] / 60000:.1f} | {s['turns']} | {s['fail']} |")
    warn = [k for k, a in A.items() if a['eff_calls'] >= 2 and a['nochange'] * 2 > a['eff_calls']]
    if warn:
        L += ['', '## 점검 대상', '', *[f"- {k}: 바꾼 것 없는 호출 {A[k]['nochange']}/{A[k]['eff_calls']} — 호출 대상 조건 재검토" for k in sorted(warn)]]
    out = os.path.join(ROOT, 'Doc', 'verify', '_ai_usage.md')
    open(out, 'w', encoding='utf-8').write('\n'.join(L) + '\n')
    print('\n'.join(L[:40]))
    print(f'→ {os.path.relpath(out, ROOT)}')
    return 0


def selftest():
    ok = True

    def chk(n, c):
        nonlocal ok
        print(('  [OK] ' if c else '  [FAIL] ') + n); ok = ok and bool(c)
    chk('세션 지점 — 검증 보완', session_point('[2/2] 2. 검증 보완 (미검증 …)', 'vm') == 'resolve')
    chk('세션 지점 — 자동 보완', session_point('🧯 자동 보완', 'vm') == 'repair')
    chk('세션 지점 — VMO', session_point('개선안 반영', 'orch') == 'orch')
    chk('세션 지점 — 그 밖 = 대화', session_point('질문', 'vm') == 'chat')
    pts = read_csv(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'ai_points.csv'))
    chk('지점 원장 — 열·행', len(pts) >= 10 and all(p.get('point') and p.get('machine_check') for p in pts))
    print('SELFTEST ' + ('OK' if ok else 'FAIL'))
    return 0 if ok else 1


def main():
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest':
        return selftest()
    ap = argparse.ArgumentParser(); ap.add_argument('--since', default=''); ap.add_argument('--menu', default='')
    a = ap.parse_args()
    return report(a.since, a.menu.upper())


if __name__ == '__main__':
    sys.exit(main())
