#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""PKG_DMF0044 전수 스캔 — SELECT 컬럼절(선택목록) 안의 서브쿼리 + 함수호출 인벤토리
   anti-simplification: 정규식 1개 금지 → 괄호깊이 추적 파서로 선택목록 구간을 정확히 잘라낸다.
   대상: 라이브 BODY 원문 (_tmp_LIVE_PKG_DMF0044_BODY.sql)
"""
import re, pathlib

SRC = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_diagnostics\_tmp_LIVE_PKG_DMF0044_BODY.sql")
text = SRC.read_text(encoding="utf-8")
lines = text.splitlines()

# --- 1) 주석/문자열 마스킹 (오탐 제거) -------------------------------------
def mask(s):
    out = list(s); i = 0; n = len(s)
    while i < n:
        if s[i] == "'":                              # 문자열 리터럴
            j = i + 1
            while j < n:
                if s[j] == "'":
                    if j + 1 < n and s[j+1] == "'": j += 2; continue
                    break
                j += 1
            for k in range(i, min(j+1, n)): out[k] = ' '
            i = j + 1
        elif s.startswith('--', i):                  # 라인 주석
            j = s.find('\n', i)
            j = n if j < 0 else j
            for k in range(i, j): out[k] = ' '
            i = j
        elif s.startswith('/*', i):                  # 블록 주석
            j = s.find('*/', i + 2)
            j = n if j < 0 else j + 2
            for k in range(i, j): out[k] = ' '
            i = j
        else:
            i += 1
    return "".join(out)

m = mask(text)
assert len(m) == len(text)

def lineno(pos): return text.count('\n', 0, pos) + 1

# --- 2) 프로시저 경계 ------------------------------------------------------
procs = [(mm.start(), mm.group(1)) for mm in re.finditer(r'(?im)^\s*PROCEDURE\s+(\w+)', m)]
def owner(pos):
    name = '(package-level)'
    for s, n in procs:
        if s <= pos: name = n
        else: break
    return name

# --- 3) 모든 SELECT 키워드의 선택목록 구간 추출 -----------------------------
#     SELECT ... (깊이 0 에서) ... FROM   구간이 선택목록
findings = []
for mm in re.finditer(r'(?i)\bSELECT\b', m):
    start = mm.end()
    depth = 0
    i = start
    n = len(m)
    end = None
    while i < n:
        c = m[i]
        if c == '(':
            depth += 1
        elif c == ')':
            if depth == 0:      # 자기 괄호 밖으로 나감 → FROM 없는 SELECT (스칼라 등)
                end = i; break
            depth -= 1
        elif depth == 0 and re.match(r'(?i)\bFROM\b', m[i:i+4]) and (i == 0 or not m[i-1].isalnum() and m[i-1] != '_'):
            end = i; break
        i += 1
    if end is None:
        continue
    seg_masked = m[start:end]
    seg_raw    = text[start:end]

    # 3-a) 선택목록 안의 서브쿼리 = 괄호로 열린 뒤 곧바로 SELECT
    for sm in re.finditer(r'\(\s*SELECT\b', seg_masked, re.I):
        findings.append(dict(kind='SUBQUERY', proc=owner(mm.start()),
                             line=lineno(start + sm.start()),
                             snippet=seg_raw[max(0, sm.start()-70):sm.start()+150].replace('\n', ' ')))

    # 3-b) 선택목록 안의 함수 호출 (SCM_MGR.FN_* / FN_* / PKG.FN)
    for fm in re.finditer(r'\b((?:SCM_MGR\.)?(?:FN|F)_\w+)\s*\(', seg_masked, re.I):
        findings.append(dict(kind='FUNCTION', proc=owner(mm.start()),
                             line=lineno(start + fm.start()),
                             snippet=fm.group(1)))

# --- 4) 출력 --------------------------------------------------------------
TRANSFER = {'P_DMF0044_MOBILE_REPORT_CREATE',
            'P_DMF0044_SALES_REPORT_PRODUCT_CREATE',
            'P_DMF0044_SALES_REPORT_DEPT_CREATE',
            'P_DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE'}

seen = set()
uniq = []
for f in findings:
    k = (f['kind'], f['proc'], f['line'], f['snippet'][:60])
    if k in seen: continue
    seen.add(k); uniq.append(f)
uniq.sort(key=lambda x: x['line'])

for scope, title in ((True, 'TRANSFER 경로 (MOBILE_REPORT_CREATE + 하위 3 PROC)'),
                     (False, 'TRANSFER 경로 밖 (참고 — 이번 범위 아님)')):
    print("=" * 118)
    print(f"### {title}")
    print("=" * 118)
    for kind in ('SUBQUERY', 'FUNCTION'):
        rows = [f for f in uniq if f['kind'] == kind and ((f['proc'] in TRANSFER) == scope)]
        print(f"\n-- {kind} : {len(rows)} 건")
        for f in rows:
            print(f"  L{f['line']:<5} {f['proc']:<45} {f['snippet'][:150]}")
    print()
