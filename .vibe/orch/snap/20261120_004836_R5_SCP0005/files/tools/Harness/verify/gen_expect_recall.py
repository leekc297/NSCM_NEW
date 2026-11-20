#!/usr/bin/env python3
"""gen_expect_recall.py [--write] — 자동 생성기 재현율(W8-2 합격 기준, 2026-11-04)

  손 기대 행(Doc/verify/<12종>.csv) 하나하나에 대해: 같은 화면의 자동 행(Doc/verify/<ID>/auto_expect/)에 같은 패턴 키가 있으면 '재현'.
  손 행에 패턴 키가 없으면 '패턴 없음'(아직 유형화하지 않은 행 — 사유 열에 규칙·이름). 자동 행이 없는 화면은 '생성 안 함'.
  출력: 콘솔 요약 + (--write) Doc/verify/_gen_expect_recall.csv — 숫자는 이 출력만 인용한다(감·예측 금지).
"""
import argparse
import csv
import datetime
import os
import sys
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import expect_rows as ER  # noqa: E402
import gen_expect as GEN  # noqa: E402  (생성기가 있는 파일 종류 = GEN.FILE_COLS)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--write', action='store_true')
    a = ap.parse_args()
    out = []
    for name in ER.EXPECT_FILES:
        rows, _ = ER.read_csv(os.path.join(ER.V, name))
        for r in rows:
            mid = r.get('menu_id', '')
            hk = ER.keys_of(name, r)
            auto = ER.auto_rows(name, mid, full=True)
            ak = set()
            for x in auto:
                ak |= ER.keys_of(name, x)
            # 생성 안 함 = 이 파일 종류의 생성기가 없거나 이 화면을 생성하지 않음 · 생성기가 돌았는데 같은 키가 없으면 미재현(2026-11-04 ③ 파일별 생성 뒤)
            ran = os.path.exists(os.path.join(ER.V, mid, 'auto_expect', '_gen_report.json')) and name in GEN.FILE_COLS
            if not hk:
                st = '패턴 없음'
            elif not ran:
                st = '생성 안 함'
            elif hk & ak:
                st = '재현'
            else:
                st = '미재현'
            out.append({'file': name, 'menu_id': mid, 'rule': r.get('rule') or r.get('rule_id') or '', 'name': (r.get('name') or r.get('label') or r.get('column_re') or r.get('button') or '')[:80],
                        'hand_keys': ' + '.join(sorted(hk)), 'state': st, 'auto_keys_same_screen': len(ak)})
    c = Counter(x['state'] for x in out)
    keyed = [x for x in out if x['state'] != '패턴 없음']
    rep = sum(1 for x in keyed if x['state'] == '재현')
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    print(f'[실측 {now}] 손 기대 행 {len(out)} · 상태 {dict(c)}')
    print(f'  패턴 키가 있는 손 행 {len(keyed)} 중 재현 {rep} ({(100.0 * rep / len(keyed)) if keyed else 0:.1f}%) · 전체 대비 {(100.0 * rep / len(out)) if out else 0:.1f}%')
    byf = Counter((x['file'], x['state']) for x in out)
    for (f, s), n in sorted(byf.items()):
        print(f'  {f:28s} {s:6s} {n}')
    miss = [x for x in out if x['state'] == '미재현']
    for x in miss:
        print(f"  미재현 {x['menu_id']} {x['rule']} {x['name'][:50]} ← {x['hand_keys']}")
    if a.write:
        p = os.path.join(ER.V, '_gen_expect_recall.csv')
        with open(p, 'w', encoding='utf-8-sig', newline='') as f:
            w = csv.DictWriter(f, fieldnames=list(out[0].keys()))
            w.writeheader()
            w.writerows(out)
        print('  →', os.path.relpath(p, ER.ROOT))


if __name__ == '__main__':
    main()
