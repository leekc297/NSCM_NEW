# -*- coding: utf-8 -*-
"""restore_touched_manual_20261106.sql 실행기 — 문장별 기대 행 수 일치 시에만 COMMIT, 하나라도 다르면 전체 ROLLBACK.
  python -I Doc/verify/_restore/restore_touched_manual_20261106.py [--dry]   (--dry = 실행 후 무조건 ROLLBACK)
"""
import os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect  # noqa: E402

EXPECT = [1, 1, 1, 2, 1, 3]  # [1] SCP0131 · [2] SCP0127 · [3] SCP0037 M · SCP0037 H · [4] SCP0122 M · SCP0122 H


def statements(path):
    body = '\n'.join(l for l in open(path, encoding='utf-8').read().splitlines() if not l.strip().startswith('--'))
    body = re.sub(r'--[^\n]*', '', body)
    return [s.strip() for s in body.split(';') if s.strip()]


def main():
    dry = '--dry' in sys.argv
    sts = statements(os.path.join(HERE, 'restore_touched_manual_20261106.sql'))
    if len(sts) != len(EXPECT):
        print(f'[ERROR] 문장 수 {len(sts)} ≠ 기대 {len(EXPECT)}'); return 2
    with connect('tobe') as cx:
        cur = cx.cursor(); ok = True
        for i, (s, e) in enumerate(zip(sts, EXPECT), 1):
            cur.execute(s); n = cur.rowcount
            print(f'[{i}] {"OK " if n == e else "NG "} {n}행 (기대 {e}) — {" ".join(s.split())[:110]}')
            ok = ok and n == e
        if ok and not dry:
            cx.commit(); print('COMMIT'); return 0
        cx.rollback(); print('ROLLBACK' + (' (dry)' if dry else ' — 기대 행 수 불일치')); return 0 if dry and ok else 1


if __name__ == '__main__':
    sys.exit(main())
