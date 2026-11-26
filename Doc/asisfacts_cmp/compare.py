# -*- coding: utf-8 -*-
"""2026-11-25 Roslyn 의미 분석 전후 대조(전 모듈) — base(의미 분석 끔) vs sem(켬), 같은 코드·같은 원본
  python compare.py [화면 접두 목록 | ALL] [sem 폴더]
  모듈 = DM(DMF, DM) · SCP(SCPF, SCP) · SSP · FP(FPC, FP) · SCM · Common(화면ID 없음) · 기타(그 밖의 접두)
  모듈마다 status 건수, base 에서 맞았는데 sem 에서 사라진 매칭, sem 에서 새로 맞은 매칭을 출력
  2026-11-26 R228(개선안 20261125173941_SELF_2): 화면 접두 기본 필터(DMF) 제거, 모듈별 출력. 첫 인자에 접두 목록을 주면 그 접두만(종전 호출 호환)"""
import csv, collections, os, re, sys
H = os.path.dirname(os.path.abspath(__file__))
csv.field_size_limit(10 ** 9)

ARG = sys.argv[1] if len(sys.argv) > 1 else 'ALL'
PFX = None if ARG.upper() == 'ALL' else tuple(ARG.split(','))
SEM = sys.argv[2] if len(sys.argv) > 2 else 'sem'
MODS = ['DM', 'SCP', 'SSP', 'FP', 'SCM', 'Common', '기타']
MOD_OF = {'DMF': 'DM', 'DM': 'DM', 'SCPF': 'SCP', 'SCP': 'SCP', 'SSP': 'SSP', 'FPC': 'FP', 'FP': 'FP', 'SCM': 'SCM', '': 'Common'}


def module(sid):
    return MOD_OF.get(re.match(r'[A-Z]*', sid or '').group(0), '기타')


def load(d):
    rows = list(csv.DictReader(open(os.path.join(H, d, 'endpoint_usage.csv'), encoding='utf-8-sig')))
    return [r for r in rows if (PFX is None or r['screen_id'].startswith(PFX)) and r['active'] == '1' and r['commented'] != '1']


def dual(rows):
    g = collections.defaultdict(set)
    for r in rows:
        if r['key'].endswith('.PseudoDataClient'):
            g[(r['file'], r['line'], r['member'])].add(r['key'])
    return sum(1 for v in g.values() if len(v) > 1), len(g)


key = lambda r: (r['file'], r['line'], r['key'])
OK_ST = ('MATCH', 'MATCH_BARE', 'BIZ_MATCH')

B, S = load('base'), load(SEM)
print('대상 화면 접두', PFX or '전체', '· 비교', 'base vs', SEM)
print('활성 호출 행  base', len(B), ' sem', len(S))
summary = []
for mod in MODS:
    b = [r for r in B if module(r['screen_id']) == mod]
    s = [r for r in S if module(r['screen_id']) == mod]
    if not b and not s:
        continue
    print('\n===== 모듈 %s · 활성 호출 행 base %d  sem %d' % (mod, len(b), len(s)))
    cb, cs = collections.Counter(r['status'] for r in b), collections.Counter(r['status'] for r in s)
    print('%-22s %8s %8s %8s' % ('status', 'base', 'sem', 'diff'))
    for k in sorted(set(cb) | set(cs)):
        print('%-22s %8d %8d %+8d' % (k, cb[k], cs[k], cs[k] - cb[k]))
    print('BIZ PseudoDataClient 호출 지점: 후보 2개로 갈라진 지점 / 전체  base %d/%d  sem %d/%d' % (dual(b) + dual(s)))
    mb = {key(r) for r in b if r['status'] in OK_ST and not r['key'].endswith('FPCommonDataBLL.PseudoDataClient')}
    ms = {key(r) for r in s if r['status'] in OK_ST}
    lost = sorted(mb - ms); gained = sorted(ms - mb)
    print('base 에서 맞았는데 sem 에서 사라진 (파일,줄,키) %d건' % len(lost))
    for x in lost[:30]:
        print('  -', x)
    print('sem 에서 새로 맞은 (파일,줄,키) %d건' % len(gained))
    for x in gained[:40]:
        print('  +', x)
    fp = [r for r in s if r['key'].endswith('FPCommonDataBLL.PseudoDataClient')]
    print('sem 에 남은 FPCommonDataBLL.PseudoDataClient %d건' % len(fp))
    for r in fp[:10]:
        print('  ', r['screen_id'], r['file'][-50:], r['line'], r['candidate'][:80])
    un = [r for r in s if r['status'] in ('UNRESOLVED', 'MATCH_PATTERN')]
    print('sem UNRESOLVED·MATCH_PATTERN %d건' % len(un))
    for r in un[:50]:
        print('  ', r['status'], r['screen_id'], r['file'][-55:], r['line'], r['member'], '|', r['candidate'][:90])
    if len(un) > 50:
        print('   … 나머지 %d건 생략(목록 = %s/endpoint_usage.csv status UNRESOLVED, MATCH_PATTERN)' % (len(un) - 50, SEM))
    summary.append((mod, len(b), len(s), sum(cb[k] for k in OK_ST), sum(cs[k] for k in OK_ST), len(lost), len(gained), len(un)))

print('\n===== 모듈별 요약')
print('%-8s %8s %8s %10s %10s %8s %8s %10s' % ('모듈', 'base행', 'sem행', 'base매칭', 'sem매칭', '사라짐', '새매칭', '미해결'))
for t in summary:
    print('%-8s %8d %8d %10d %10d %8d %8d %10d' % t)
