# -*- coding: utf-8 -*-
"""구간 A4 — dedup_screen.py: 미측정·판정필요 행이 있는 규칙만 AI 에 묻는다(전부 측정된 규칙은 묶어도 상속할 행이 없음)"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pt import patch

D = sys.argv[1]
patch(os.path.join(D, 'dedup_screen.py'), [
    ("def judge_rule(mid, rid, items, rname, ask=None):\n    if len(items) == 1:\n        return {'rule_id': rid, 'hash': in_hash(items), 'groups': [{'rows': [items[0]['row_id']], 'why': '단독'}], 'why': '행 1건', 'by': '코드', 'at': now(), 'cost': 0}\n",
     "def judge_rule(mid, rid, items, rname, ask=None, open_n=None):\n    if len(items) == 1:\n        return {'rule_id': rid, 'hash': in_hash(items), 'groups': [{'rows': [items[0]['row_id']], 'why': '단독'}], 'why': '행 1건', 'by': '코드', 'at': now(), 'cost': 0}\n"
     "    if open_n == 0:   # 2026-11-20 A4: 이 규칙 행이 모두 측정됨(PASS·FAIL·NA) — 묶어도 결과를 이어받을 행이 없다. AI 호출 없이 단독(측정 안 된 행이 생기면 다시 판단)\n"
     "        return {'rule_id': rid, 'hash': in_hash(items), 'groups': [{'rows': [x['row_id']], 'why': '단독'} for x in items], 'why': '미측정 행 없음 — 중복 판단 생략', 'by': '코드', 'at': now(), 'cost': 0, 'open': 0}\n"),
    ("    cands = candidates(mid, rows); names = rule_names(); dd = os.path.join(vdir(mid), '_dedup'); results = {}; todo = []\n",
     "    cands = candidates(mid, rows); names = rule_names(); dd = os.path.join(vdir(mid), '_dedup'); results = {}; todo = []\n"
     "    _res = {r['row_id']: (r.get('result') or '') for r in rows}\n"
     "    open_n = {rid: sum(1 for x in items if _res.get(x['row_id'], '') in UNMEASURED) for rid, items in cands.items()}\n"),
    ("        if old and old.get('hash') == in_hash(items):\n            results[rid] = old\n",
     "        if old and old.get('hash') == in_hash(items) and not (old.get('open') == 0 and open_n.get(rid)):   # 지난번 '미측정 없음'으로 생략한 규칙에 미측정 행이 생기면 다시 판단\n            results[rid] = old\n"),
    ("    nc = sum(1 for r in todo if len(cands[r]) > 1)\n",
     "    nc = sum(1 for r in todo if len(cands[r]) > 1 and open_n.get(r))\n"),
    ("        res = judge_rule(mid, rid, cands[rid], names.get(rid, ''), ask)\n",
     "        res = judge_rule(mid, rid, cands[rid], names.get(rid, ''), ask, open_n=open_n.get(rid, 0))\n"),
    ("    chk('규칙 판단(가짜 AI) = AI · 묶음 2', res['by'] == 'AI' and len(res['groups']) == 2)\n",
     "    chk('규칙 판단(가짜 AI) = AI · 묶음 2', res['by'] == 'AI' and len(res['groups']) == 2)\n"
     "    called = []\n"
     "    res = judge_rule('X', 'A1', items, '', ask=lambda p: called.append(1) or {'ok': True, 'data': {}}, open_n=0)\n"
     "    chk('미측정 행 없는 규칙 = AI 호출 없음 · 전부 단독', not called and res['by'] == '코드' and len(res['groups']) == 4)\n"),
])
