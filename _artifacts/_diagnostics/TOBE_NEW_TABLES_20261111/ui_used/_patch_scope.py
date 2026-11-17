# -*- coding: utf-8 -*-
"""2026-11-11 재실행용 패치 — 범위(DM 화면 추가) · 산출 경로(작업 폴더) · 파일명 일자"""
import re, pathlib
D = pathlib.Path(__file__).resolve().parent
OLD = '"DMF0035 DMF0040 DMF0068 DMF0053").split(),'
NEW = ('"DMF0035 DMF0040 DMF0068 DMF0053 DMF0003_01 DMF0005_01 DMF0020_01 DMF0083 "   # 2026-11-11 메뉴 실측 추가 4 (Demand 폴더)\n'
       '           "DMF0022 DMF0045").split(),   # 2026-11-11 Demand 폴더 밖 DMF 화면 2 (Report>Waterfall · Shipping>Shipping_Schedule)')
for f in ('03_entry.py', '06_build.py', '07_build3.py'):
    s = (D / f).read_text(encoding='utf-8')
    assert s.count(OLD) == 1, f
    s = s.replace(OLD, NEW).replace('20261014', '20261111')
    if f == '03_entry.py':
        a = '    assert sorted(SCOPE[g]) == live, (g, sorted(set(live) ^ set(SCOPE[g])))'
        assert s.count(a) == 1
        s = s.replace(a, '    OUTSIDE = {"DMF0022", "DMF0045"}   # Demand 폴더 밖 DMF 화면(메뉴 실측 2026-11-11)\n'
                         '    assert sorted(set(SCOPE[g]) - OUTSIDE) == live, (g, sorted(set(live) ^ (set(SCOPE[g]) - OUTSIDE)))')
    if f == '06_build.py':
        a = 'OUTDIR = pathlib.Path(r"C:\\Projects\\NSCM\\Doc\\화면분석서")'
        assert s.count(a) == 1
        s = s.replace(a, 'OUTDIR = D   # 2026-11-11 재실행본은 작업 폴더에만 둔다\nDOCDIR = pathlib.Path(r"C:\\Projects\\NSCM\\Doc\\화면분석서")')
        assert s.count('v23 = OUTDIR / ') == 1
        s = s.replace('v23 = OUTDIR / ', 'v23 = DOCDIR / ')
    if f == '07_build3.py':
        a = 'OUT = pathlib.Path(r"C:\\Projects\\NSCM\\Doc\\화면분석서\\TOBE_UI사용_TABLE_VIEW_SYSTEM_ADMIN_DM_AUTH_20261111.xlsx")'
        assert s.count(a) == 1, 'OUT'
        s = s.replace(a, 'OUT = D / "TOBE_UI사용_TABLE_VIEW_SYSTEM_ADMIN_DM_AUTH_20261111.xlsx"')
    (D / f).write_text(s, encoding='utf-8')
    print(f, 'patched')
