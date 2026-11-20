# -*- coding: utf-8 -*-
"""원장 전후 대조 (2026-11-20 CheckList 속도 개선 플랜 R0)
   속도 변경(대기 제거, AI 검토 묶기, 병렬)이 판정을 바꾸지 않았는지 row_id 별 result 로 확인한다.

  python tools/Harness/verify/ledger_diff.py <MENU_ID> --save <이름>      지금 원장을 기준선으로 보관(Doc/verify/<ID>/baseline/<이름>/)
  python tools/Harness/verify/ledger_diff.py <MENU_ID> --base <이름>      기준선과 지금 원장 대조
  python tools/Harness/verify/ledger_diff.py --files <전.csv> <후.csv>    파일 2개 직접 대조
  python tools/Harness/verify/ledger_diff.py --selftest

  출력 = 결과 분포 전후, 바뀐 행(전 → 후), 한쪽에만 있는 행. 결과 파일 Doc/verify/<ID>/ledger_diff.json
  종료코드 0 = 차이 0건 / 1 = 차이 있음 / 2 = 입력 오류
"""
import argparse, collections, csv, datetime, json, os, shutil, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
csv.field_size_limit(10 ** 8)
KEEP = ('verify_ledger.csv', '_test_timing.jsonl', 'llm_usage.csv', 'llm_review.csv', 'run_verify.result.json', 'unverified_triage.json')


def read(p):
    with open(p, encoding='utf-8-sig', newline='') as f:
        return {r['row_id']: r for r in csv.DictReader(f) if r.get('row_id')}


def diff(a, b):
    """(바뀐 행 [(row_id, rule, 전, 후)], 전에만 [row_id], 후에만 [row_id])"""
    ch = [(k, a[k].get('rule_id', ''), a[k].get('result', ''), b[k].get('result', '')) for k in sorted(a) if k in b and a[k].get('result', '') != b[k].get('result', '')]
    return ch, sorted(k for k in a if k not in b), sorted(k for k in b if k not in a)


def report(a, b, label_a, label_b):
    ch, only_a, only_b = diff(a, b)
    da = collections.Counter(r.get('result', '') for r in a.values()); db = collections.Counter(r.get('result', '') for r in b.values())
    print(f'[원장 대조] 전 {label_a} {len(a)}행 · 후 {label_b} {len(b)}행')
    print('  결과 분포 전: ' + ' · '.join(f'{k} {v}' for k, v in sorted(da.items())))
    print('  결과 분포 후: ' + ' · '.join(f'{k} {v}' for k, v in sorted(db.items())))
    mv = collections.Counter((x[2], x[3]) for x in ch)
    print(f'  바뀐 행 {len(ch)} · 전에만 {len(only_a)} · 후에만 {len(only_b)}')
    for (x, y), n in sorted(mv.items(), key=lambda t: -t[1]):
        print(f'    {x} → {y}: {n}행')
    for row in ch[:40]:
        print(f'    {row[0]} [{row[1]}] {row[2]} → {row[3]}')
    if len(ch) > 40:
        print(f'    그 밖 {len(ch) - 40}행은 ledger_diff.json 참조')
    return {'at': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), 'before': label_a, 'after': label_b, 'rows_before': len(a), 'rows_after': len(b),
            'dist_before': dict(da), 'dist_after': dict(db), 'changed': [list(x) for x in ch], 'only_before': only_a, 'only_after': only_b,
            'same': not ch and not only_a and not only_b}


def selftest():
    ok = True

    def chk(n, c):
        nonlocal ok
        print('PASS' if c else 'FAIL', n); ok = ok and bool(c)
    d = tempfile.mkdtemp()
    try:
        def w(name, rows):
            p = os.path.join(d, name)
            with open(p, 'w', encoding='utf-8-sig', newline='') as f:
                wr = csv.DictWriter(f, fieldnames=['row_id', 'rule_id', 'result']); wr.writeheader(); wr.writerows(rows)
            return p
        base = [{'row_id': 'V-1', 'rule_id': 'A1', 'result': 'PASS'}, {'row_id': 'V-2', 'rule_id': 'A3', 'result': 'ERROR'}, {'row_id': 'V-3', 'rule_id': 'B8', 'result': 'FAIL'}]
        a = read(w('a.csv', base)); b = read(w('b.csv', list(reversed(base))))
        chk('행 순서만 다름 = 차이 0건', diff(a, b) == ([], [], []))
        c = read(w('c.csv', [dict(base[0]), dict(base[1], result='PASS'), {'row_id': 'V-9', 'rule_id': 'K1', 'result': 'NA'}]))
        ch, oa, ob = diff(a, c)
        chk('판정 바뀐 행 1 · 전에만 1 · 후에만 1', ch == [('V-2', 'A3', 'ERROR', 'PASS')] and oa == ['V-3'] and ob == ['V-9'])
        r = report(a, c, 'a', 'c'); chk('보고 same = False · 분포 기록', r['same'] is False and r['dist_before'] == {'PASS': 1, 'ERROR': 1, 'FAIL': 1})
        chk('같은 원장 same = True', report(a, b, 'a', 'b')['same'] is True)
    finally:
        shutil.rmtree(d, ignore_errors=True)
    print('ALL PASS' if ok else 'SOME FAIL'); return 0 if ok else 1


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id', nargs='?'); ap.add_argument('--save'); ap.add_argument('--base'); ap.add_argument('--files', nargs=2); ap.add_argument('--selftest', action='store_true')
    a = ap.parse_args()
    if a.selftest:
        return selftest()
    if a.files:
        try:
            r = report(read(a.files[0]), read(a.files[1]), a.files[0], a.files[1])
        except (OSError, KeyError) as e:
            print(f'[ERROR] 원장 읽기 실패: {e}'); return 2
        return 0 if r['same'] else 1
    if not a.menu_id or not (a.save or a.base):
        print(__doc__); return 2
    mid = a.menu_id.upper(); vd = os.path.join(ROOT, 'Doc', 'verify', mid); cur = os.path.join(vd, 'verify_ledger.csv')
    if not os.path.exists(cur):
        print(f'[ERROR] 원장 없음: Doc/verify/{mid}/verify_ledger.csv'); return 2
    if a.save:
        bd = os.path.join(vd, 'baseline', a.save); os.makedirs(bd, exist_ok=True); n = 0
        for fn in KEEP:
            if os.path.exists(os.path.join(vd, fn)):
                shutil.copy2(os.path.join(vd, fn), os.path.join(bd, fn)); n += 1
        rows = read(cur); dist = collections.Counter(r.get('result', '') for r in rows.values())
        json.dump({'at': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), 'rows': len(rows), 'dist': dict(dist), 'files': n}, open(os.path.join(bd, 'baseline.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        print(f"[OK] 기준선 보관 Doc/verify/{mid}/baseline/{a.save} · 파일 {n}개 · 원장 {len(rows)}행 · " + ' · '.join(f'{k} {v}' for k, v in sorted(dist.items())))
        return 0
    bp = os.path.join(vd, 'baseline', a.base, 'verify_ledger.csv')
    if not os.path.exists(bp):
        print(f'[ERROR] 기준선 없음: Doc/verify/{mid}/baseline/{a.base}/verify_ledger.csv'); return 2
    r = report(read(bp), read(cur), f'기준선 {a.base}', '지금')
    json.dump(r, open(os.path.join(vd, 'ledger_diff.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(f"[{'OK' if r['same'] else 'DIFF'}] {'판정 차이 0건' if r['same'] else '판정 차이 있음'} → Doc/verify/{mid}/ledger_diff.json")
    return 0 if r['same'] else 1


if __name__ == '__main__':
    sys.exit(main())
