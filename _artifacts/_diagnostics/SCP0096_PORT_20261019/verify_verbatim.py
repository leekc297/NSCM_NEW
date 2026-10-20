# -*- coding: utf-8 -*-
"""하네스 PKG 파일이 사내 현행 PKG_SCP0096 본문(헬퍼·GET·SAVE)을 1바이트 무변경으로 보존했는지 대조"""
import os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
live = open(os.path.join(HERE, 'DB_PKG_SCP0096_PACKAGE_BODY.sql'), encoding='utf-8').read()
new = open(os.path.join(HERE, '..', '..', '..', 'Doc', 'gen', 'SCP0096', 'SCP0096_PKG.sql'), encoding='utf-8').read()

def seg(txt, start, end):
    i = txt.index(start); j = txt.index(end, i) + len(end)
    return txt[i:j]

checks = [
    ('helpers', '    TYPE T_TOKEN_TAB IS TABLE OF', '    END F_TO_NUM;'),
    ('GET',     '    /*==================================================================================================*\n     * 출하일 관리 조회', '    END P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP;'),
    ('SAVE',    '    /*==================================================================================================*\n     * 출하일 관리 저장', '    END P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP;'),
]
ok = True
for name, s, e in checks:
    a, b = seg(live, s, e), seg(new, s, e)
    same = a == b
    ok &= same
    print(f'{name:8s} live={len(a):6d}B file={len(b):6d}B  {"SAME" if same else "DIFF"}')
    if not same:
        import difflib
        for l in difflib.unified_diff(a.splitlines(), b.splitlines(), 'live', 'file', lineterm='', n=1): print(l)
# spec: 기존 2개 시그니처 보존
livespec = open(os.path.join(HERE, 'DB_PKG_SCP0096_PACKAGE.sql'), encoding='utf-8').read()
for name, s, e in [('spec GET', '    PROCEDURE P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP\n', '    );'), ('spec SAVE', '    PROCEDURE P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP\n', '    );')]:
    a, b = seg(livespec, s, e), seg(new, s, e)
    same = a == b; ok &= same
    print(f'{name:9s} {"SAME" if same else "DIFF"}')
print('RESULT', 'PASS' if ok else 'FAIL')
sys.exit(0 if ok else 1)
