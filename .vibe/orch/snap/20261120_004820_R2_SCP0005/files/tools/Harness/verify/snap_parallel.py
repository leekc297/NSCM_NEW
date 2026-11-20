# -*- coding: utf-8 -*-
"""스냅샷 행 ↔ 구 프로브 행 병행 대조(2026-11-06 플랜 3-5) — 같은 규칙(G4·K4·A5·H6·H4·H5·SC1)의 기존 실측 판정과 스냅샷 판정을 나란히 놓는다.
  python tools/Harness/verify/snap_parallel.py <ID>   # → Doc/verify/<ID>/snap/_parallel.csv (불일치 = 사용자 확인 목록) · 원장은 바꾸지 않는다
"""
import csv, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
csv.field_size_limit(10 ** 8)
KIND_RULES = {'조회조건': ('G4', 'SC1', 'H5', 'SC2'), '버튼': ('K4', 'J2'), '헤더': ('A5', 'H5', 'A9'), '팝업': ('H6', 'G4'), '화면샷': ('H4',)}


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def main():
    if len(sys.argv) < 2:
        print(__doc__); return 2
    mid = sys.argv[1].upper()
    rows = rd(P('Doc', 'verify', mid, 'verify_ledger.csv'))
    snaps = [r for r in rows if '스냅샷' in (r.get('target') or '')]
    if not snaps:
        print(f'[snap_parallel] {mid}: 원장에 스냅샷 행 없음(ledger.py 스냅샷 행 생성 뒤)'); return 0
    out = []
    for s in snaps:
        m = re.search(r'스냅샷 (\S+) (.+)$', s['target']); kind = m.group(1) if m else ''; scope = m.group(2) if m else ''
        rules = KIND_RULES.get(kind, ())
        old = [r for r in rows if r['rule_id'] in rules and '스냅샷' not in (r.get('target') or '') and r['source'] in ('RULE_SCREEN', 'SEARCH', 'COLUMN', 'TRACE') and r['result'] in ('PASS', 'FAIL', '판정필요', 'ERROR', 'NA')]
        cnt = {}
        for r in old: cnt[r['result']] = cnt.get(r['result'], 0) + 1
        old_fail = [r for r in old if r['result'] == 'FAIL']
        agree = ('일치' if (s['result'] == 'PASS' and not old_fail) or (s['result'] == 'FAIL' and old_fail) else '확인 필요') if s['result'] in ('PASS', 'FAIL') else '스냅샷 미확정'
        out.append({'snap_row': s['row_id'], 'kind': kind, 'scope': scope, 'snap_result': s['result'], 'old_rules': ','.join(rules), 'old_counts': ' '.join(f'{k}:{v}' for k, v in sorted(cnt.items())),
                    'old_fail_rows': ' '.join(f"{r['row_id']}({r['rule_id']} {r['target'][:30]})" for r in old_fail[:6]), 'agree': agree, 'snap_evidence': (s.get('evidence') or '')[:200]})
    sd = P('Doc', 'verify', mid, 'snap'); os.makedirs(sd, exist_ok=True)
    with open(os.path.join(sd, '_parallel.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(out[0].keys())); w.writeheader(); w.writerows(out)
    n = sum(1 for o in out if o['agree'] == '확인 필요')
    print(f"[snap_parallel] {mid}: 스냅샷 {len(out)}행 ↔ 구 프로브 대조 · 확인 필요 {n} → Doc/verify/{mid}/snap/_parallel.csv")
    for o in out:
        if o['agree'] == '확인 필요': print(f"   ? {o['snap_row']} {o['kind']} {o['scope']}: 스냅샷 {o['snap_result']} ↔ 구 {o['old_counts']} {o['old_fail_rows'][:100]}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
