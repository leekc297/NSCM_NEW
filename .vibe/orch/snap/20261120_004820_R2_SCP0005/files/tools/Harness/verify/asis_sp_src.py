# -*- coding: utf-8 -*-
"""AS-IS SP 원문(Doc/asisfacts/db/modules/<schema>.<SP>.sql) 판독 공용 함수 (2026-11-18 미검증 해소)

  sp_declared_defaults(sp)   선언부 '@인자 형식 = 값' → {인자(소문자, @ 제외): (값, '파일:행')} · 값 NULL 이면 None
  blank_means_all(sp, name)  본문이 '@인자 = ''' 비교로 빈 값을 전체로 다루는가(별칭 지역 변수 포함 · 'ALL' 비교도 있으면 False)
  쓰는 곳: gen_param_map.py(차등 검증 인자 default) · tools/DbConn/golden.py(골든 실행 파라미터 미정 판단)
"""
import glob
import os
import re

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..'))
_TXT = {}


def _sp_file(sp):
    name = (sp or '').split('.')[-1].strip('[]')
    fs = glob.glob(os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'modules', f'*.{name}.sql')) if name else []
    return fs[0] if len(fs) == 1 else None


def _text(sp):
    f = _sp_file(sp)
    if not f:
        return None, None
    if f not in _TXT:
        try:
            _TXT[f] = open(f, encoding='utf-8-sig', errors='replace').read()
        except OSError:
            _TXT[f] = None
    return f, _TXT[f]


def _strip_comments(txt):
    t = re.sub(r'/\*[\s\S]*?\*/', lambda m: '\n' * m.group(0).count('\n'), txt)
    return re.sub(r'--[^\n]*', '', t)


def sp_declared_defaults(sp):
    f, txt = _text(sp)
    if not txt:
        return {}
    nc = _strip_comments(txt)
    m = re.search(r'\b(?:CREATE|ALTER)\s+(?:PROC|PROCEDURE)\s+[^\s(]+', nc, re.I)
    if not m:
        return {}
    e = re.search(r'\bAS\b\s*(?:BEGIN\b|SET\b|DECLARE\b|IF\b|SELECT\b|WITH\b|$)', nc[m.end():], re.I)
    head = nc[m.end(): m.end() + (e.start() if e else 4000)]
    out = {}
    for pm in re.finditer(r"@(\w+)\s+[\w\[\]]+(?:\s*\([^)]*\))?\s*=\s*(N?'(?:[^']|'')*'|-?\d+(?:\.\d+)?|NULL)", head, re.I):
        v = pm.group(2)
        if v.upper() == 'NULL':
            v = None
        elif v[0] in "Nn'":
            v = v[v.index("'") + 1:-1].replace("''", "'")
        line = nc[:m.end() + pm.start()].count('\n') + 1
        out[pm.group(1).lower()] = (v, f'{os.path.relpath(f, ROOT)}:{line}')
    return out


def blank_means_all(sp, pname):
    _, t = _text(sp)
    if not t:
        return False
    n = re.escape(pname.lstrip('@'))
    names = [n] + [re.escape(m.group(1)) for m in re.finditer(rf"(?i)DECLARE\s+@(\w+)[^;\n]*?=\s*@{n}\b", t)]
    names += [re.escape(m.group(1)) for m in re.finditer(rf"(?i)\bSET\s+@(\w+)\s*=\s*@{n}\b", t)]
    blank = any(re.search(rf"(?i)@{x}\s*(=|<>|!=)\s*N?''", t) for x in names)
    al = any(re.search(rf"(?i)@{x}\s*(=|<>|!=)\s*N?'ALL'", t) for x in names)
    return blank and not al


def selftest():
    bad = []
    d = sp_declared_defaults('SCP0096_GET_SHIPMENT_WORKING_DAY_OSP')
    if not _sp_file('SCP0096_GET_SHIPMENT_WORKING_DAY_OSP'):
        return bad  # 원문 없는 환경은 건너뜀
    if (d.get('debug_mode') or (None,))[0] != 'F':
        bad.append(f'debug_mode 기본값 {d.get("debug_mode")}(기대 F)')
    if 'p_division_id' in d:
        bad.append('기본값 없는 인자를 기본값 있음으로 읽음')
    return bad


if __name__ == '__main__':
    import sys
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest':
        b = selftest(); print('selftest', 'OK' if not b else 'FAIL', *b, sep='\n'); sys.exit(1 if b else 0)
    for sp in sys.argv[1:]:
        print(sp, sp_declared_defaults(sp), {p: blank_means_all(sp, p) for p in ('p_plant_site_id',)})
