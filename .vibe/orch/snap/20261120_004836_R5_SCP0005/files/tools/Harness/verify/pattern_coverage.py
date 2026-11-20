#!/usr/bin/env python3
"""pattern_coverage.py <ID> [<ID> ...] — 화면별 결함 패턴 적용표(W8-3, 2026-11-05)

  새 화면(또는 기존 화면)에 대해 '문서에서 나온 결함 패턴 중 몇 개가 적용됐고, 시험이 몇 개 생겼고, 측정 결과가 무엇인가'를 한 표로.
  입력(모두 이미 만들어진 산출물 — 이 도구는 재측정하지 않는다):
    - Doc/verify/<ID>/auto_expect/_gen_report.json  : 패턴별 생성 행 수·생성 안 함 사유·권한 제외(auth_drop)
    - Doc/verify/<ID>/auto_expect/<파일>             : 손 행 중복 제거 뒤 실제 소비되는 자동 행
    - Doc/verify/<ID>/verify_ledger.csv              : 자동 행 측정 결과(근거·대상 글자의 '자동 생성 P##')
    - Doc/verify/doc_patterns.csv                    : 패턴이 연결된 문서 행 수(doc_patterns.py 출력)
  상태(state):
    적용·측정   = 원장에 그 패턴 행이 있고 결과 있음
    적용·미측정 = 자동 행이 소비 파일에 있는데 원장에 없음(원장이 생성보다 이전 = CheckList 재실행 전) 또는 결과 빈값
    적용·손행대체 = 생성됐지만 같은 키 손 행이 있어 전부 빠짐(손 행이 측정)
    권한 제외   = 시험 계정 그룹에 필요한 버튼 권한 없음(auth_drop)
    미적용      = 화면 사실이 패턴 조건에 안 맞음(사유 = 생성기 why_not)
  출력: Doc/verify/<ID>/pattern_coverage.csv + 콘솔 요약
"""
import collections
import csv
import datetime
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import expect_rows as ER  # noqa: E402
import gen_expect as GEN  # noqa: E402

V = ER.V
PID_RE = re.compile(r'자동 생성 (P\d\d)')
COLS = ['pattern_id', 'rule', 'title', 'state', 'generated', 'consumed', 'hand_replaced', 'auth_dropped', 'ledger_rows', 'results',
        'doc_rows_linked', 'why_not', 'applies_when']


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def mtime(p):
    return datetime.datetime.fromtimestamp(os.path.getmtime(p)) if os.path.exists(p) else None


def coverage(mid):
    d = os.path.join(V, mid)
    rp = os.path.join(d, 'auto_expect', '_gen_report.json')
    if not os.path.exists(rp):
        print(f'{mid}: [ERROR] 자동 기대 행 생성 보고서 없음({os.path.relpath(rp, ER.ROOT)}) — gen_expect.py {mid} 먼저')
        return None
    with open(rp, encoding='utf-8') as f:
        rep = json.load(f)
    # 패턴별 생성(_all = 손 행 중복 제거 전) · 소비(본 파일)
    gen_n, use_n = collections.Counter(), collections.Counter()
    for fname in GEN.FILE_COLS:
        for r in rd(os.path.join(d, 'auto_expect', '_all', fname)):
            gen_n[r.get('pattern_id', '')] += 1
        for r in rd(os.path.join(d, 'auto_expect', fname)):
            use_n[r.get('pattern_id', '')] += 1
    drop_n = collections.Counter(x.split(' ', 1)[0] for x in rep.get('auth_drop', []))
    # 원장 측정 결과
    lp = os.path.join(d, 'verify_ledger.csv')
    led = rd(lp)
    res = collections.defaultdict(collections.Counter)
    for r in led:
        m = PID_RE.search(' '.join(str(r.get(k) or '') for k in ('target', 'condition', 'evidence', 'note', 'source', 'expected')))
        if m:
            res[m.group(1)][r.get('result') or '(결과 없음)'] += 1
    lt, gt = mtime(lp), mtime(rp)
    stale = bool(lt and gt and lt < gt)
    # 문서 행 연결 수
    docs = collections.Counter()
    for x in rd(os.path.join(V, 'doc_patterns.csv')):
        if x.get('new_screen') == 'AUTO':
            for p in x['pattern_id'].split(';'):
                docs[p] += 1
    out = []
    for pid, (fn, rule, title, applies) in GEN.PATTERN_INFO.items():
        why = (rep.get('patterns', {}).get(fn) or {}).get('why_not') or []
        g, u, dr = gen_n[pid], use_n[pid], drop_n[pid]
        rc = res.get(pid, collections.Counter())
        ln = sum(rc.values())
        if ln and any(k != '(결과 없음)' for k in rc):
            st = '적용·측정'
        elif u:
            st = '적용·미측정'
        elif g and not u:
            st = '적용·손행대체'
        elif dr:
            st = '권한 제외'
        else:
            st = '미적용'
        out.append({'pattern_id': pid, 'rule': rule, 'title': title, 'state': st, 'generated': g, 'consumed': u, 'hand_replaced': g - u,
                    'auth_dropped': dr, 'ledger_rows': ln, 'results': ' '.join(f'{k}:{v}' for k, v in sorted(rc.items())),
                    'doc_rows_linked': docs[pid], 'why_not': ' · '.join(why)[:300] if st in ('미적용', '권한 제외') else '',
                    'applies_when': applies})
    op = os.path.join(d, 'pattern_coverage.csv')
    with open(op, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS)
        w.writeheader()
        w.writerows(out)
    sc = collections.Counter(x['state'] for x in out)
    tot = collections.Counter()
    for x in out:
        for kv in x['results'].split():
            k, v = kv.rsplit(':', 1)
            tot[k] += int(v)
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    print(f"[실측 {now}] {mid}(AS-IS {rep.get('asis') or '-'}) 패턴 {len(out)}개: " + ' · '.join(f'{k} {v}' for k, v in sc.most_common()))
    print(f"  자동 행 생성 {sum(gen_n.values())} · 소비 {sum(use_n.values())} · 손 행 대체 {sum(gen_n.values()) - sum(use_n.values())} · 권한 제외 {sum(drop_n.values())} · 측정 결과 {dict(tot) or '없음'}")
    print(f"  생성 {gt:%m-%d %H:%M} · 원장 {lt:%m-%d %H:%M}" + (' ⚠ 원장이 생성보다 이전 — 지금 자동 행은 아직 측정 안 됨(다음 CheckList 에서 측정)' if stale else '') if lt else f"  생성 {gt:%m-%d %H:%M} · 원장 없음(CheckList 미실행)")
    for x in out:
        if x['state'] in ('적용·측정', '적용·미측정'):
            print(f"  {x['pattern_id']} {x['rule']:4} {x['state']:6} 생성{x['generated']}/소비{x['consumed']} {x['results'] or ''} — {x['title']}")
    print('  →', os.path.relpath(op, ER.ROOT))
    return out


def main():
    ids = [a for a in sys.argv[1:] if not a.startswith('-')]
    if not ids:
        print(__doc__)
        sys.exit(2)
    rc = 0
    for mid in ids:
        if coverage(mid) is None:
            rc = 1
    sys.exit(rc)


if __name__ == '__main__':
    main()
