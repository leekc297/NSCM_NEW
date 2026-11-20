# -*- coding: utf-8 -*-
"""구간 A6 — 문서 1회 생성 + 설명 문장 묶음 병렬
   make_verify_docs.py --plan-only : 설명 정리 필요 목록(no_summary.json)까지만 만들고 xlsx 를 쓰지 않는다
   run_verify.py : 설명 문장(AI)이 켜져 있으면 --plan-only → llm_desc → 문서 1회 · 꺼져 있으면 종전대로 1회
   llm_desc.py   : 묶음을 동시에(harness.json llmReviewPar) · 효과 기록"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pt import patch

D = sys.argv[1]
patch(os.path.join(D, 'make_verify_docs.py'), [
    ("    ap.add_argument('--scope', choices=['DB_ONLY', 'DB_FE'])\n    a = ap.parse_args()\n",
     "    ap.add_argument('--scope', choices=['DB_ONLY', 'DB_FE'])\n"
     "    ap.add_argument('--plan-only', action='store_true', help='설명 정리 필요 목록(no_summary.json)까지만 · xlsx 쓰지 않음(2026-11-20 A6 · run_verify 가 설명 문장 작성 전에 부름)')\n"
     "    a = ap.parse_args()\n"),
    ("    except Exception as _ex:\n        print(f'  [WARN] no_summary.json 기록 실패: {_ex}')\n",
     "    except Exception as _ex:\n        print(f'  [WARN] no_summary.json 기록 실패: {_ex}')\n"
     "    if a.plan_only:\n"
     "        print(f'[설명 정리 필요] {len(_NO_SUMMARY)}건(목록만 · --plan-only · 문서는 설명 문장 작성 뒤 1회 생성)')\n"
     "        return 0\n"),
])

patch(os.path.join(D, 'run_verify.py'), [
    ("def llm_desc_step(py, mid):\n",
     "def docs_once(py, mid, cmd):\n"
     "    \"\"\"2026-11-20 A6 문서 1회 생성: 설명 문장(AI)이 켜져 있으면 목록만 먼저(--plan-only) → 설명 문장 작성 → 문서 생성. 반환 = make_verify_docs 종료코드\"\"\"\n"
     "    if llm_on('desc'):\n"
     "        if run(cmd + ['--plan-only']) == 0:\n"
     "            llm_step('desc', [py, os.path.join(HERE, 'llm_desc.py'), mid])\n"
     "    else:\n"
     "        sub('llm_desc.py', 'AI 검토 꺼짐(harness.json llmReview)')\n"
     "    return run(cmd)\n\n\n"
     "def llm_desc_step(py, mid):\n"),
    # --resume-docs
    ("        cmd = [py, os.path.join(HERE, 'make_verify_docs.py'), mid] + (['--scope', a.scope] if a.scope else [])\n        if run(cmd):\n            return 8\n        made = docs_made_since(mid, STARTED)\n        if made is not True:\n            print(f'[ERROR] 문서 생성 확인 실패 — {made}')\n            return 8\n        if llm_desc_step(py, mid) and run(cmd):  # 2026-11-19 설명 문장 작성(AI) — 쓴 행이 있으면 문서만 한 번 더\n            return 8\n",
     "        cmd = [py, os.path.join(HERE, 'make_verify_docs.py'), mid] + (['--scope', a.scope] if a.scope else [])\n        if docs_once(py, mid, cmd):   # 2026-11-20 A6: 설명 문장 작성 뒤 문서 1회\n            return 8\n        made = docs_made_since(mid, STARTED)\n        if made is not True:\n            print(f'[ERROR] 문서 생성 확인 실패 — {made}')\n            return 8\n"),
    # 정규 실행
    ("    cmd = [py, os.path.join(HERE, 'make_verify_docs.py'), mid] + (['--scope', a.scope] if a.scope else [])\n    if run(cmd):\n        return 8\n",
     "    cmd = [py, os.path.join(HERE, 'make_verify_docs.py'), mid] + (['--scope', a.scope] if a.scope else [])\n    if docs_once(py, mid, cmd):   # 2026-11-20 A6: 설명 문장 작성 뒤 문서 1회(종전 = 문서 → 설명 → 문서 2회 · 판 번호 2개)\n        return 8\n"),
    ("    if llm_desc_step(py, mid) and run(cmd):\n        return 8\n    # 검사기 회귀 게이트",
     "    # 검사기 회귀 게이트"),
])

patch(os.path.join(D, 'llm_desc.py'), [
    ("    new, skipped, cost = [], [], 0.0\n    for i, g in enumerate(ch, 1):\n        if from_data is not None:\n            res = {'ok': True, 'data': from_data, 'cost': 0.0, 'why': ''}\n        else:\n            print(f'  · 설명 문장 작성 묶음 {i}/{len(ch)} — {len(g)}행', flush=True)\n            res = llm_call.ask(mid, 'desc', build_prompt(mid, ctx, g, review), rows=len(g))\n",
     "    new, skipped, cost = [], [], 0.0\n"
     "    # 2026-11-20 A6: 묶음을 동시에 부른다(harness.json llmReviewPar · 종전 순서 호출 묶음 5개 약 11분). 결과 처리는 묶음 번호 순\n"
     "    import concurrent.futures as _cf\n"
     "    try:\n"
     "        par = max(1, int(c.get('llmReviewPar') or 4))\n"
     "    except (TypeError, ValueError):\n"
     "        par = 4\n"
     "\n"
     "    def _one(ig):\n"
     "        i, g = ig\n"
     "        if from_data is not None:\n"
     "            return i, g, {'ok': True, 'data': from_data, 'cost': 0.0, 'why': ''}\n"
     "        print(f'  · 설명 문장 작성 묶음 {i}/{len(ch)} — {len(g)}행', flush=True)\n"
     "        return i, g, llm_call.ask(mid, 'desc', build_prompt(mid, ctx, g, review), rows=len(g))\n"
     "    with _cf.ThreadPoolExecutor(max_workers=par if from_data is None else 1) as ex:\n"
     "        answers = list(ex.map(_one, list(enumerate(ch, 1))))\n"
     "    calls = cached = nochange = 0\n"
     "    for i, g, res in answers:\n"
     "        if res.get('ok'):\n"
     "            calls += 0 if res.get('cached') else 1; cached += 1 if res.get('cached') else 0\n"),
    ("        cost += float(res.get('cost') or 0)\n        items = {str(it.get('row_id') or ''): it for it in ((res['data'] or {}).get('items') or []) if isinstance(it, dict)}\n        for r, _ in g:\n",
     "        cost += float(res.get('cost') or 0)\n        items = {str(it.get('row_id') or ''): it for it in ((res['data'] or {}).get('items') or []) if isinstance(it, dict)}\n        _n0 = len(new)\n        for r, _ in g:\n"),
    ("            else:\n                skipped.append((r['row_id'], why))\n    # 같은 group",
     "            else:\n                skipped.append((r['row_id'], why))\n        if len(new) == _n0 and not res.get('cached'):\n            nochange += 1\n    # 같은 group"),
    ("    print(f'DESC_WRITTEN {len(keep)}', flush=True)\n    return 0\n",
     "    if from_data is None:\n"
     "        w_ = llm_call.log_effect(mid, 'desc', calls=calls, cached=cached, applied=len(keep), nochange_calls=nochange, note=f'미작성 {len(skipped)}행')\n"
     "        if w_:\n"
     "            print(w_, flush=True)\n"
     "    print(f'DESC_WRITTEN {len(keep)}', flush=True)\n    return 0\n"),
])
