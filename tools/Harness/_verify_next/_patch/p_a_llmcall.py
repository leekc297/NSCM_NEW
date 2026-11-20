# -*- coding: utf-8 -*-
"""구간 A7·A8 — llm_call.py: 종류 목록(dedup·delta·criteria), llmReviewPar 기본값, 종류별 effort, 꺼진 종류 차단, 효과 기록"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pt import patch

D = sys.argv[1]
patch(os.path.join(D, 'llm_call.py'), [
    ("KINDS = ('facts', 'judge', 'opinion', 'desc')\nDEFAULTS = {'llmReview': True, 'llmReviewKinds': list(KINDS), 'llmReviewModel': '', 'llmReviewEffort': 'high', 'llmReviewBudgetUsd': 0, 'llmReviewBatch': 6, 'llmReviewTimeoutMin': 20, 'llmReviewLean': True}",
     "KINDS = ('facts', 'judge', 'opinion', 'desc', 'dedup', 'delta', 'criteria', 'port', 'repair')   # 2026-11-20 A7: dedup·delta 도 켜고 끔 대상 · criteria = 기준 정리(구간 B) · port·repair = UI 개발 검토·보완 진단(구간 D)\n"
     "DEFAULTS = {'llmReview': True, 'llmReviewKinds': list(KINDS), 'llmReviewModel': '', 'llmReviewEffort': 'high', 'llmReviewEffortByKind': {}, 'llmReviewBudgetUsd': 0, 'llmReviewBatch': 6, 'llmReviewPar': 4, 'llmReviewTimeoutMin': 20, 'llmReviewLean': True}\n"
     "EFFECT_COLS = ['at', 'menu_id', 'kind', 'calls', 'cached', 'applied', 'nochange_calls', 'skipped_rows', 'note']"),
    # 종류별 effort
    ("def claude_cmd():\n    b = (os.environ.get('CLAUDE_BIN') or '').strip() or 'claude'\n    c = cfg()",
     "def claude_cmd(kind=''):\n    b = (os.environ.get('CLAUDE_BIN') or '').strip() or 'claude'\n    c = cfg()"),
    ("    e = str(c.get('llmReviewEffort') or '').strip().lower()\n    if e in",
     "    e = str(((c.get('llmReviewEffortByKind') or {}).get(kind) if isinstance(c.get('llmReviewEffortByKind'), dict) else '') or c.get('llmReviewEffort') or '').strip().lower()   # 2026-11-20 A7 종류별 effort(정리·설명은 낮게)\n    if e in"),
    ("def _spawn(prompt, timeout):\n    b, args, m, e = claude_cmd()",
     "def _spawn(prompt, timeout, kind=''):\n    b, args, m, e = claude_cmd(kind)"),
    ("        rc, out, err, m, e = _spawn(prompt, int(cfg().get('llmReviewTimeoutMin') or 20) * 60)",
     "        rc, out, err, m, e = _spawn(prompt, int(cfg().get('llmReviewTimeoutMin') or 20) * 60, kind)"),
    # 꺼진 종류 차단(캐시·배관 시험 뒤)
    ("    left = budget_left(mid)\n    if left is not None and left <= 0:",
     "    if kind in KINDS and not enabled(kind):   # 2026-11-20 A7: 꺼진 종류는 호출하지 않는다(부른 쪽은 결과 없음 처리 = 기계 판정·단독 유지)\n"
     "        return {'ok': False, 'data': None, 'why': f'꺼짐(harness.json llmReviewKinds 에 {kind} 없음)', 'cached': False, 'cost': 0.0, 'ms': 0, 'skipped': True}\n"
     "    left = budget_left(mid)\n    if left is not None and left <= 0:"),
    # 효과 기록
    ("def read_usage(mid=None):",
     "def log_effect(mid, kind, calls=0, cached=0, applied=0, nochange_calls=0, skipped_rows=0, note=''):\n"
     "    \"\"\"2026-11-20 A8: AI 지점별 효과 — 호출 수, 반영 건수, 바꾼 것이 없는 호출 수. Doc/verify/<ID>/llm_effect.csv · Doc/verify/_llm_effect.csv\n"
     "       반환 = 경고 문장(바꾼 것이 없는 호출이 절반을 넘으면) 또는 ''\"\"\"\n"
     "    row = {'at': now(), 'menu_id': mid, 'kind': kind, 'calls': calls, 'cached': cached, 'applied': applied, 'nochange_calls': nochange_calls, 'skipped_rows': skipped_rows, 'note': str(note or '')[:300]}\n"
     "    for p in (os.path.join(vdir(mid), 'llm_effect.csv'), os.path.join(ROOT, 'Doc', 'verify', '_llm_effect.csv')):\n"
     "        try:\n"
     "            with _LOCK:\n"
     "                new = not os.path.exists(p)\n"
     "                with open(p, 'a', encoding='utf-8-sig', newline='') as f:\n"
     "                    w = csv.DictWriter(f, fieldnames=EFFECT_COLS, extrasaction='ignore')\n"
     "                    if new:\n"
     "                        w.writeheader()\n"
     "                    w.writerow(row)\n"
     "        except OSError as e:\n"
     "            print(f'[WARN] 효과 기록 실패 {os.path.relpath(p, ROOT)}: {e}')\n"
     "    if calls >= 2 and nochange_calls * 2 > calls:\n"
     "        return f'[WARN] AI {kind} 호출 {calls}회 중 {nochange_calls}회는 바꾼 것이 없음(절반 초과) · Doc/verify/{mid}/llm_effect.csv'\n"
     "    return ''\n\n\n"
     "def read_usage(mid=None):"),
    # selftest
    ("    c = cfg()\n    chk('설정 — 기본 키', all(k in c for k in DEFAULTS))",
     "    c = cfg()\n    chk('설정 — 기본 키', all(k in c for k in DEFAULTS))\n"
     "    chk('설정 — 동시 호출 기본값', int(DEFAULTS['llmReviewPar']) == 4 and 'llmReviewPar' in c)\n"
     "    chk('종류 — dedup·delta·criteria 켜고 끔 대상', all(k in KINDS for k in ('dedup', 'delta', 'criteria')))\n"
     "    chk('효과 — 절반 초과 경고', log_effect('_SELFTEST', 'judge', calls=4, nochange_calls=3).startswith('[WARN]') and log_effect('_SELFTEST', 'judge', calls=4, nochange_calls=2) == '')\n"
     "    for _f in ('llm_effect.csv', 'llm_usage.csv'):\n"
     "        try:\n"
     "            os.remove(os.path.join(ROOT, 'Doc', 'verify', '_SELFTEST', _f))\n"
     "        except OSError:\n"
     "            pass\n"
     "    try:\n"
     "        _p = os.path.join(ROOT, 'Doc', 'verify', '_llm_effect.csv'); _ls = open(_p, encoding='utf-8-sig').read().splitlines(True)\n"
     "        open(_p, 'w', encoding='utf-8-sig').write(''.join(x for x in _ls if ',_SELFTEST,' not in x))\n"
     "    except OSError:\n"
     "        pass"),
])
