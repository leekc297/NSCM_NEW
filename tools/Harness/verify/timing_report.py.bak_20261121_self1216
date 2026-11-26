"""CheckList 소요 시간 집계 (2026-11-06 속도 개선 ① 계측) — 측정값만 읽어 요약한다(추정 없음).

입력(화면 폴더 Doc/verify/<ID>/):
  _timing.csv          run_verify.py 가 실행마다 덧붙임 — run_at,stage,tool,start,sec,rc
  _test_timing.jsonl   Playwright 픽스처(tools/E2E/fixtures/test.ts)가 테스트마다 덧붙임
                       ms{total,login,open,search,wait,miss,body} · n{…횟수} · parts{로그인·화면 열기 내부 구간} · sites{종류@파일:줄 → ms}
사용:
  python tools/Harness/verify/timing_report.py SCP0016            # 가장 최근 실행
  python tools/Harness/verify/timing_report.py SCP0016 --all      # 기록된 실행 전부(실행별)
주의: wait(고정 대기)·miss(시간초과로 끝난 탐침)는 open·search 안의 것과 겹친다. miss 는 Promise.race 에서 진 쪽도 잡혀
      실제 시간을 쓰지 않은 것이 섞일 수 있다(후보 위치로만 읽는다).
"""
import collections
import csv
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


def main():
    a = [x for x in sys.argv[1:] if not x.startswith('--')]
    if not a:
        print(__doc__)
        return 2
    mid = a[0].upper(); every = '--all' in sys.argv
    d = os.path.join(ROOT, 'Doc', 'verify', mid)
    print(f"== CheckList 시간 집계 {mid} ({os.path.relpath(d, ROOT)})")
    stage_part(d, every)
    test_part(d, every)
    return 0


if __name__ == '__main__':
    sys.exit(main())
