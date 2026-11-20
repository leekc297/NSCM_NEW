# -*- coding: utf-8 -*-
"""패치 도구: (종전 → 새) 쌍을 1회씩 적용. 새 문장이 이미 있으면 건너뜀(재실행 안전). 종전 문장이 정확히 1번 나오지 않으면 중단"""
import os, shutil


def patch(f, pairs, bak='.bak_20261120_aipts'):
    b = open(f, 'rb').read().decode('utf-8')
    crlf = '\r\n' in b
    if crlf:
        b = b.replace('\r\n', '\n')
    if bak and not os.path.exists(f + bak) and '_verify_next' not in f.replace('\\', '/'):
        shutil.copy2(f, f + bak)
    n = 0
    for old, new in pairs:
        if new in b and (old not in b or old in new):   # 이미 적용(삽입형은 새 문장이 종전 문장을 품음 · 삭제형은 종전 문장이 남아 있으면 적용)
            continue
        c = b.count(old)
        assert c == 1, (os.path.basename(f), old[:90], c)
        b = b.replace(old, new); n += 1
    if crlf:
        b = b.replace('\n', '\r\n')
    with open(f, 'r+b') as fh:
        fh.seek(0); fh.write(b.encode('utf-8')); fh.truncate()
    print(f'ok {os.path.basename(f)} ({n} 변경)')
