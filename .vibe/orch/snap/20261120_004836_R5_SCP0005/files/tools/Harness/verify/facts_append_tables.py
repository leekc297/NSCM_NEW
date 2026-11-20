# -*- coding: utf-8 -*-
"""AS-IS 저장 SP 가 '저장마다 새 키로 행을 쌓는' 표 — Doc/asisfacts/screens/<ID>/append_tables.csv (2026-11-10 T212)

  python tools/Harness/verify/facts_append_tables.py <AS-IS ID>

왜: F7(EG235 같은 행 2회 저장 → 업무 표 행 수 불변)이 이력 표를 이름(_H·_HIST·HISTORY)으로만 가려,
  SSP0060 SAVE_SHIPMENT_PLAN 처럼 저장마다 새 변경요청 번호(NEXT VALUE FOR SEQ1_…)로 SSP_ANL_SHIP_CONFIRM_CHG_REQ / _DE 를 INSERT 하는
  요청 로그 표를 업무 표로 보고 '재저장이 행 수를 바꿈' FAIL 을 냈다(AS-IS 도 저장마다 행이 는다).
무엇: 화면 actions.csv 의 저장 ENDPOINT SP(+ EXEC 하위 SP) 원문(주석 제거)에서
  ① 키 변수 = SET/SELECT @v = … NEXT VALUE FOR … | MAX(…)+1 | IDENT_CURRENT | SCOPE_IDENTITY 로 그 저장에서 새로 만든 값
  ② INSERT [INTO] <표> … 문장(다음 최상위 문장 전까지)이 ① 변수를 쓰면 그 표 = 저장마다 새 키 행(append)
열: root(화면이 부르는 저장 SP — 체인 시작), table, sp(INSERT 가 있는 SP), line, key_var, key_src(빈 값 = 새 키 없는 일반 INSERT · T222)
한계: 동적 SQL 문자열 안 INSERT 는 보지 못한다(그 표는 append 로 분류되지 않음 → 종전 판정 유지).
"""
import csv
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
DOC = os.path.join(ROOT, 'Doc')
sys.path.insert(0, HERE)
from sp_branch_check import asis_src, rd, RX_EXEC  # noqa: E402
from facts_sortrules import strip_comments  # noqa: E402

RX_KEY = re.compile(r'(?is)\b(?:SET|SELECT)\s+(@\w+)\s*=\s*([^;]{0,400}?)(?=\bSET\b|\bSELECT\b|\bINSERT\b|\bUPDATE\b|\bDELETE\b|\bIF\b|\bEND\b|\bBEGIN\b|;|$)')
RX_GEN = re.compile(r'(?is)NEXT\s+VALUE\s+FOR|MAX\s*\([^)]*\)\s*\+\s*1|IDENT_CURRENT|SCOPE_IDENTITY|@@IDENTITY|NEWID\s*\(')
RX_INS = re.compile(r'(?is)\bINSERT\s+(?:INTO\s+)?(?!INTO\b)([@#]?(?:\[?[\w$]+\]?\.){0,3}\[?[\w$]+\]?)')  # 표 변수(@T)·임시표(#T)는 아래에서 제외
RX_NEXT = re.compile(r'(?is)\b(?:INSERT|UPDATE|DELETE|MERGE|SET|IF|ELSE|END|BEGIN|EXEC|EXECUTE|DECLARE|RETURN|WHILE|FETCH|CLOSE|DEALLOCATE|OPEN)\b')


def append_tables(src):
    """(표, 줄, 키 변수, 키 원천) 목록"""
    if not src: return []
    s = strip_comments(src)
    keys = {}
    for m in RX_KEY.finditer(s):
        g = RX_GEN.search(m.group(2))
        if g: keys.setdefault(m.group(1).upper(), g.group(0).split('(')[0].strip().upper())
    # 키 변수에서 파생된 변수(SET @a = 'R' + … @key …)도 키로 본다(1단계)
    for m in RX_KEY.finditer(s):
        v = m.group(1).upper()
        if v not in keys:
            hit = next((k for k in keys if re.search(re.escape(k) + r'\b', m.group(2), re.I)), None)
            if hit: keys[v] = f'{keys[hit]}({hit})'
    out = []
    for m in RX_INS.finditer(s):
        tbl = re.sub(r'[\[\]]', '', m.group(1)).split('.')[-1].upper()
        if tbl.startswith('#') or tbl.startswith('@'): continue
        rest = s[m.end():]
        # INSERT 문 끝 = 괄호 깊이 0 에서 다음 최상위 문장 키워드(SELECT 는 INSERT…SELECT 일부라 제외)
        d = 0; end = len(rest)
        for i, ch in enumerate(rest):
            if ch == '(': d += 1
            elif ch == ')': d -= 1
            elif d == 0 and ch.isalpha() and (i == 0 or not (rest[i - 1].isalnum() or rest[i - 1] in '_@')):
                mm = RX_NEXT.match(rest, i)
                if mm: end = i; break
            elif d == 0 and ch == ';': end = i; break
        body = rest[:end]
        used = [k for k in keys if re.search(re.escape(k) + r'\b', body, re.I)]
        line = s[:m.start()].count('\n') + 1
        # 2026-11-10 T222: 새 키를 쓰지 않는 INSERT 도 기록(key_src='') — '이번 저장 SP 가 실제로 쓰는 표'(F 이력 표 판정)의 원천
        out.append((tbl, line, used[0], keys[used[0]]) if used else (tbl, line, '', ''))
    return out


def main():
    sid = (sys.argv[1] if len(sys.argv) > 1 else '').upper()
    if not sid: print(__doc__); return 2
    acts = rd(os.path.join(DOC, 'asisfacts', 'screens', sid, 'actions.csv'))
    sps = {re.split(r'[.]', r.get('endpoint') or '')[-1].upper() for r in acts if r.get('kind') == 'ENDPOINT' and re.search(r'SAVE|_INS|_UPD|_DEL', r.get('endpoint') or '', re.I)}
    sps.discard('')
    rows, seen = [], set()
    for sp in sorted(sps):
        todo = [sp]; vis = set()
        while todo:
            cur = todo.pop()
            if cur in vis or len(vis) > 20: continue
            vis.add(cur); src = asis_src(cur)
            for t, ln, kv, ks in append_tables(src):
                if (t, cur, sp) in seen: continue
                seen.add((t, cur, sp)); rows.append({'root': sp, 'table': t, 'sp': cur, 'line': ln, 'key_var': kv, 'key_src': ks})
            todo += [m.group(1).upper() for m in RX_EXEC.finditer(src or '')]
    p = os.path.join(DOC, 'asisfacts', 'screens', sid, 'append_tables.csv')
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['root', 'table', 'sp', 'line', 'key_var', 'key_src']); w.writeheader(); w.writerows(rows)
    ap = [r for r in rows if r['key_src']]
    print(f"{sid}: 저장 SP INSERT 표 {len({r['table'] for r in rows})}개 · 그중 저장마다 새 키 행 표 {len({r['table'] for r in ap})}개 → {p}" + (' · ' + ', '.join(sorted({f"{r['table']}({r['key_src']})" for r in ap})) if ap else ''))
    return 0


if __name__ == '__main__':
    sys.exit(main())
