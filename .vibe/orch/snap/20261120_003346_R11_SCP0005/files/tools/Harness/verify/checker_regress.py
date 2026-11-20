# -*- coding: utf-8 -*-
"""검사기 자체 회귀(P3 · 2026-11-06 근본 보완 · W8 플랜 1-6 확장) — 골든 화면의 원장 판정 스냅숏을 기준으로, 검사기·공용 컴포넌트를 고친 뒤 판정이 어떻게 바뀌었는지 대조한다.

  python tools/Harness/verify/checker_regress.py <ID>                       # 기준(Doc/verify/_checker_golden/<ID>.csv)과 현재 원장 대조 → Doc/verify/<ID>/_checker_regress.md
  python tools/Harness/verify/checker_regress.py <ID> --baseline [--only 문자열]   # 현재 원장을 기준으로 저장(--only: target 에 문자열이 있는 행만 갱신 · 나머지 기준 행 보존)
  python tools/Harness/verify/checker_regress.py <ID> --approve [--by 이름]       # 차이가 났던 received(.received.csv) 를 기준으로 승격(ApprovalTests 규약 차용)
  python tools/Harness/verify/checker_regress.py <ID> --strict                    # 악화 ≥1 이면 exit 2(기본은 경고만)
종료코드: 기본 0(경고) · --strict 악화 → 2 · 기준이 승인된 스냅샷 행(target '스냅샷' · 기준 PASS)이 FAIL 로 바뀌면 항상 2(run_verify GATE_WARN)
자동 승인: 사용자 판정 행(tobe_ref '수동 사용자판정' 또는 _user_verdicts_direct.csv) 은 대조 때 기준을 그 값으로 갱신한다(approved_by=사용자) — '사용자 판정 = 승인'
"""
import csv, datetime, os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
csv.field_size_limit(10 ** 8)
GOLD = os.path.join(ROOT, 'Doc', 'verify', '_checker_golden')
BAD = ('FAIL',)
COLS = ['row_id', 'rule_id', 'target', 'result', 'evidence_head', 'saved_at', 'approved_by', 'approved_at', 'verdict_src']


def rd(p):
    if not os.path.exists(p): return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def wr(p, rows):
    os.makedirs(os.path.dirname(p), exist_ok=True)
    tmp = f'{p}.{os.getpid()}.tmp'
    with open(tmp, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS); w.writeheader(); w.writerows([{k: r.get(k, '') for k in COLS} for r in rows])
    os.replace(tmp, p)


def snap_row(r, now, by='', src=''):
    return {'row_id': r['row_id'], 'rule_id': r['rule_id'], 'target': (r.get('target') or '')[:80], 'result': r['result'], 'evidence_head': (r.get('evidence') or '')[:80].replace('\n', ' '),
            'saved_at': now, 'approved_by': by, 'approved_at': now if by else '', 'verdict_src': src}


def main():
    a = [x for x in sys.argv[1:] if not x.startswith('--')]
    if not a:
        print(__doc__); return 2
    opt = lambda k: sys.argv[sys.argv.index(k) + 1] if k in sys.argv and sys.argv.index(k) + 1 < len(sys.argv) else ''
    mid = a[0].upper(); led = os.path.join(ROOT, 'Doc', 'verify', mid, 'verify_ledger.csv')
    if not os.path.exists(led):
        print(f'[checker_regress] {mid}: 원장 없음'); return 0
    cur = {r['row_id']: r for r in rd(led)}
    gp = os.path.join(GOLD, f'{mid}.csv'); rp = os.path.join(GOLD, f'{mid}.received.csv')
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M')
    base = {r['row_id']: r for r in rd(gp)}
    direct = {(d.get('row_id') or '').strip(): d for d in rd(os.path.join(ROOT, 'Doc', 'verify', '_user_verdicts_direct.csv')) if (d.get('menu_id') or '').upper() == mid}
    if '--baseline' in sys.argv:
        only = opt('--only')
        rows = [snap_row(r, now, by=('사용자(' + ('대화' if r['row_id'] in direct else 'CheckList') + ')') if (r.get('tobe_ref') or '').startswith('수동 사용자판정') else '', src='user' if (r.get('tobe_ref') or '').startswith('수동 사용자판정') else 'checker') for r in cur.values() if not only or only in (r.get('target') or '')]
        if only and base:
            keep = [b for rid, b in base.items() if rid not in {x['row_id'] for x in rows}]
            rows = keep + rows
        wr(gp, rows)
        print(f"[checker_regress] {mid}: 기준 저장 {len(rows)}행{(' (--only ' + only + ')') if only else ''} → {os.path.relpath(gp, ROOT)}"); return 0
    if '--approve' in sys.argv:
        rec = {r['row_id']: r for r in rd(rp)}
        if not rec:
            print(f'[checker_regress] {mid}: received 없음(차이가 난 실행이 없었다) — 승인할 것 없음'); return 0
        by = opt('--by') or '사용자'
        for rid, r in rec.items():
            r['approved_by'] = by; r['approved_at'] = now; r['verdict_src'] = 'approved'; base[rid] = r
        wr(gp, list(base.values()))
        try: os.remove(rp)
        except OSError: pass
        print(f"[checker_regress] {mid}: received {len(rec)}행 → 기준 승격(by {by}) · 기준 {len(base)}행"); return 0
    if not base:
        print(f'[checker_regress] {mid}: 기준 없음(골든 화면 아님) — 대조 생략'); return 0
    worse, better, changed, auto = [], [], [], []
    for rid, b in list(base.items()):
        c = cur.get(rid)
        if not c: continue
        user = (c.get('tobe_ref') or '').startswith('수동 사용자판정') or rid in direct
        if b['result'] == c['result']: continue
        if user:  # 사용자 판정 = 승인 → 기준을 그 값으로(검사기 결과 변화로 세지 않는다)
            base[rid] = snap_row(c, now, by='사용자(' + ('대화' if rid in direct else 'CheckList') + ')', src='user'); auto.append(rid); continue
        rec = (rid, c['rule_id'], c['target'][:60], b['result'], c['result'], (c.get('evidence') or '')[:100].replace('\n', ' '), '스냅샷' in (c.get('target') or ''), (b.get('approved_by') or ''))
        if c['result'] in BAD and b['result'] not in BAD: worse.append(rec)
        elif b['result'] in BAD and c['result'] not in BAD: better.append(rec)
        else: changed.append(rec)
    gone = [rid for rid in base if rid not in cur]; new = [rid for rid in cur if rid not in base]
    if auto:
        wr(gp, list(base.values()))
    # received = 차이가 난 행의 현재 값(승격 대기) — 차이 없으면 지운다
    diff_ids = [x[0] for x in worse + better + changed]
    if diff_ids:
        wr(rp, [snap_row(cur[rid], now, src='received') for rid in diff_ids])
    elif os.path.exists(rp):
        try: os.remove(rp)
        except OSError: pass
    snap_bad = [x for x in worse if x[6] and x[3] == 'PASS']  # 승인(기준 PASS)된 스냅샷이 FAIL 로
    saved = next(iter(base.values()), {}).get('saved_at', '')
    out = [f'# 검사기 회귀 대조 {mid} — 기준 {saved} ({len(base)}행) ↔ 현재 {now} ({len(cur)}행)', '',
           f'- 악화(기준 비FAIL → 현재 FAIL): **{len(worse)}** (그중 승인 스냅샷 {len(snap_bad)}) · 개선(FAIL → 비FAIL): {len(better)} · 그 외 변경: {len(changed)} · 사용자 판정 자동 승인 {len(auto)} · 기준에만 있는 행 {len(gone)} · 새 행 {len(new)}',
           f"- 승격 대기(received): {os.path.relpath(rp, ROOT) if diff_ids else '없음'} — 확인 뒤 `checker_regress.py {mid} --approve --by 이름`", '']
    for title, lst in (('## 악화 — 검사기 수정이 허위 FAIL 을 만들었는지 확인', worse), ('## 개선', better), ('## 그 외 변경', changed)):
        out.append(title); out.append('')
        out.append('| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |'); out.append('|---|---|---|---|---|---|---|')
        for rec in lst[:200]: out.append('| ' + ' | '.join(str(x).replace('|', '／') for x in (rec[0], rec[1], rec[2], rec[3], rec[4], rec[5], rec[7])) + ' |')
        out.append('')
    vd = os.path.join(ROOT, 'Doc', 'verify', mid); os.makedirs(vd, exist_ok=True)
    with open(os.path.join(vd, '_checker_regress.md'), 'w', encoding='utf-8') as f: f.write('\n'.join(out))
    print(f'[checker_regress] {mid}: 악화 {len(worse)}(승인 스냅샷 {len(snap_bad)}) · 개선 {len(better)} · 변경 {len(changed)} · 자동 승인 {len(auto)} → Doc/verify/{mid}/_checker_regress.md' + (' ⚠ 악화 행 확인' if worse else ''))
    if snap_bad or ('--strict' in sys.argv and worse):
        return 2
    return 0


if __name__ == '__main__':
    sys.exit(main())
