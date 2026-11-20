# -*- coding: utf-8 -*-
"""구간 A1·A2·A3·A5·A8 — llm_review.py
   A1 재측정으로만 풀리는 미검증 행(검사기공백·데이터전제·재실행·차등짝·집계·사람·선행결함)은 AI 에 보내지 않는다(unverified_classes.csv 분류 재사용)
   A2 판단 행(판정필요에서 넘어온 ERROR · 분류표 '판단')은 판정필요와 같은 조건으로 반영 · 그 밖 미검증 행은 근거 확인된 NA 만
   A3 같은 규칙·같은 증거 행은 한 항목으로 묻고 답을 같이 쓴다(예외 행은 단독 검토)
   A5 행 기억 키 = 행 내용 + 그 규칙의 TO-BE 룰(결함 유형표·사실 후보·지난 판정 제외) · 답 1건마다 저장
   A8 효과 기록(llm_call.log_effect)"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pt import patch

D = sys.argv[1]
patch(os.path.join(D, 'llm_review.py'), [
    # ── 상수 ──
    ("RX_STAMP = re.compile(r'@?\\d{2}-\\d{2} \\d{2}:\\d{2}(:\\d{2})?|\\d{4}-\\d{2}-\\d{2}[ T]\\d{2}:\\d{2}(:\\d{2})?')\n",
     "RX_STAMP = re.compile(r'@?\\d{2}-\\d{2} \\d{2}:\\d{2}(:\\d{2})?|\\d{4}-\\d{2}-\\d{2}[ T]\\d{2}:\\d{2}(:\\d{2})?')\n"
     "SWEEP_TAIL = ' → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)'   # judge 판정필요 정리(REVIEW_SWEEP)가 판정필요를 ERROR 로 바꿀 때 붙이는 꼬리\n"
     "# 2026-11-20 A1: AI 가 원문을 읽어도 풀 수 없는 미검증 — 다시 재야 답이 나온다(unverified_classes.csv 담당). 이 행은 판정 검토에 보내지 않는다\n"
     "REMEASURE_ACTORS = ('엔진', '자동', '사람', '보완', '집계')\n"
     "JUDGE_ACTORS = ('판단',)            # 판정 대기(기계가 결론을 못 낸 비교) — 판정필요와 같게 본다\n"
     "SAME_MAX = 30                       # A3 한 항목에 싣는 같은 증거 행 상한\n"
     "_CLS = None\n\n\n"
     "def uv_class(ev):\n"
     "    \"\"\"(분류, 담당) — unverified_resolve.classify 와 같은 표(unverified_classes.csv)\"\"\"\n"
     "    global _CLS\n"
     "    try:\n"
     "        import unverified_resolve as _ur\n"
     "        if _CLS is None:\n"
     "            _CLS = _ur.load_classes()\n"
     "        c, a, _ = _ur.classify(ev, _CLS)\n"
     "        return c, a\n"
     "    except Exception:\n"
     "        return '미분류', '엔진'\n\n\n"
     "def eff_result(r):\n"
     "    \"\"\"판정 검토가 보는 결과. ERROR 중 판정 대기 행(판정필요 정리 꼬리 · 분류표 담당 '판단')은 판정필요로 본다(2026-11-20 A2 · 사용자 승인 결정 1)\"\"\"\n"
     "    cur = r.get('result') or ''\n"
     "    if cur != 'ERROR':\n"
     "        return cur\n"
     "    ev = r.get('evidence') or ''\n"
     "    c, a = uv_class(ev)\n"
     "    return '판정필요' if a in JUDGE_ACTORS else 'ERROR'\n\n\n"
     "def remeasure_reason(r):\n"
     "    \"\"\"재측정으로만 풀리는 미검증 행이면 사유, 아니면 ''\"\"\"\n"
     "    if (r.get('result') or '') != 'ERROR':\n"
     "        return ''\n"
     "    c, a = uv_class(r.get('evidence') or '')\n"
     "    return f'재측정 대상({c}·{a}) — AI 판정 대상 아님' if a in REMEASURE_ACTORS else ''\n"),
    # ── 행 요약: 판정 대기 표시(키 v1 은 종전 그대로) ──
    ("def row_brief(r):\n    f = lambda k, n: (r.get(k) or '').replace('\\r', ' ').strip()[:n]\n    return {",
     "def row_brief(r, v1=False):\n    f = lambda k, n: (r.get(k) or '').replace('\\r', ' ').strip()[:n]\n"
     "    b = row_brief_v1(r)\n"
     "    if not v1 and eff_result(r) != (r.get('result') or ''):\n"
     "        b['state'] = '판정 대기(기계가 비교는 했으나 결론을 못 냄) — 판정필요 행과 같이 판단'\n"
     "    if not v1 and r.get('_same'):\n"
     "        b['same_rows'] = r['_same']\n"
     "    return b\n\n\n"
     "def row_brief_v1(r):\n    f = lambda k, n: (r.get(k) or '').replace('\\r', ' ').strip()[:n]\n    return {"),
    # 프롬프트 추가 문장은 새 상수(PROMPT_HEAD2·PROMPT_TAIL2)에만. 종전 문장(v1)은 행 기억 종전 키 계산에 그대로 쓴다
    ("def build_prompt(mid, ctx, chunk):\n",
     "PROMPT_ADD_HEAD = (\"- state 가 '판정 대기'인 ERROR 행은 기계가 비교를 했지만 결론을 못 낸 행이다. 판정필요 행과 같이 판단한다.\\n\"\n"
     "                   \"- same_rows 가 있는 행은 같은 규칙에서 증거 문장이 같은 행 묶음이다. 대상(target)을 모두 보고, 같은 판단이 모든 행에 맞으면 same=\\\"Y\\\", 다른 행이 있으면 그 row_id 를 except 에 적는다.\\n\")\n"
     "PROMPT_HEAD2 = PROMPT_HEAD.replace('## 근거 규칙', PROMPT_ADD_HEAD + '\\n## 근거 규칙', 1)   # 2026-11-20 A2·A3\n"
     "PROMPT_TAIL2 = PROMPT_TAIL.replace('\"general\":\"Y|N\"}]}', '\"general\":\"Y|N\",\"same\":\"Y|N(same_rows 있을 때만)\",\"except\":[\"same_rows 중 이 판단이 맞지 않는 row_id\"]}]}', 1)\n\n\n"
     "def build_prompt(mid, ctx, chunk, v1=False):\n"),
    ("    head = PROMPT_HEAD.format(",
     "    head = (PROMPT_HEAD if v1 else PROMPT_HEAD2).format("),
    ("    parts += ['## 검토할 행', json.dumps([row_brief(r) for r in chunk], ensure_ascii=False, indent=1), PROMPT_TAIL]",
     "    parts += ['## 검토할 행', json.dumps([row_brief(r, v1=v1) for r in chunk], ensure_ascii=False, indent=1), PROMPT_TAIL if v1 else PROMPT_TAIL2]"),
    # ── decide: 판정 대기 = 판정필요 · 그 밖 미검증 = NA 만 ──
    ("    cur = r.get('result') or ''\n    cls = it.get('class') if it.get('class') in CLASSES else '확인불가'",
     "    cur = eff_result(r)\n    cls = it.get('class') if it.get('class') in CLASSES else '확인불가'"),
    ("    elif cur == 'ERROR':\n        why = '미검증 행은 의견만(판정 반영 안 함)'\n",
     "    elif cur == 'ERROR' and ver != 'NA':\n        why = '미검증 행은 NA(대상 없음 근거)만 반영'\n"
     "    elif cur == 'ERROR' and not (cls in ('검사기오판', 'TOBE룰', '추출오류') and (ok_asis or (rule_ok and ok_any))):\n"
     "        why = '미검증 행 NA 는 AS-IS 원문 인용 또는 등록 룰 번호 필요'\n"
     "    elif cur == 'ERROR':\n        apply, why = 'Y', ('AS-IS 원문 인용 확인' if ok_asis else f'등록 룰 {rule_ref} + 인용 확인') + ' · 대상 없음(미검증 → NA)'\n"),
    # ── 대상 선정: 재측정 대상 제외 · 같은 증거 묶기 · 행 기억 키 ──
    ("    rkey = {r['row_id']: llm_call.key_of('judge-row', build_prompt(mid, ctx, [r])) for r in targets}\n"
     "    hit = [r for r in targets if rkey[r['row_id']] in rowcache and not from_file]\n"
     "    targets = [r for r in targets if r not in hit]\n"
     "    for r in hit:\n"
     "        out.append(decide(r, rowcache[rkey[r['row_id']]]))\n",
     "    # 2026-11-20 A5: 키 = 행 내용 + 그 규칙의 TO-BE 룰 + AS-IS 화면 ID(결함 유형표·사실 후보·지난 판정은 실행마다 바뀌어 기억을 깨므로 뺀다). 종전 키(v1)로 저장된 답도 찾는다\n"
     "    rkey = {r['row_id']: row_key(ctx, r) for r in targets}\n"
     "    hit = []\n"
     "    for r in targets:\n"
     "        if from_file:\n"
     "            break\n"
     "        k = rkey[r['row_id']]\n"
     "        if k not in rowcache:\n"
     "            k1 = llm_call.key_of('judge-row', build_prompt(mid, ctx, [r], v1=True))\n"
     "            if k1 in rowcache:\n"
     "                rowcache[k] = rowcache[k1]\n"
     "        if k in rowcache:\n"
     "            hit.append(r)\n"
     "    targets = [r for r in targets if r not in hit]\n"
     "    for r in hit:\n"
     "        out.append(decide(r, rowcache[rkey[r['row_id']]]))\n"
     "    # 2026-11-20 A1: 재측정으로만 풀리는 미검증 행은 새로 묻지 않는다(기억된 답이 있으면 위에서 이미 반영 · 호출 비용 없음)\n"
     "    for r in [x for x in targets if remeasure_reason(x)]:\n"
     "        out.append(blank(r, '검토 제외', remeasure_reason(r)))\n"
     "    targets = [x for x in targets if not remeasure_reason(x)]\n"
     "    # 2026-11-20 A3: 같은 규칙·같은 증거·같은 판정 대기 상태 행은 대표 1행으로 묻는다(대상 목록은 same_rows 로 보임). 예외로 답한 행은 llm_solo.json 에 남겨 다음 실행에 단독으로 묻는다\n"
     "    solo_p = os.path.join(llm_call.vdir(mid), 'llm_solo.json')\n"
     "    try:\n"
     "        solo = set(json.load(open(solo_p, encoding='utf-8')))\n"
     "    except (OSError, ValueError):\n"
     "        solo = set()\n"
     "    grp = {}\n"
     "    for r in sorted(targets, key=lambda x: x['row_id']):\n"
     "        g = (r.get('rule_id') or '', ev_hash(r.get('evidence')), eff_result(r)) if r['row_id'] not in solo else ('', r['row_id'], '')\n"
     "        grp.setdefault(g, []).append(r)\n"
     "    members = {}\n"
     "    reps = []\n"
     "    for g, rs in grp.items():\n"
     "        rep = rs[0]; rest = rs[1:SAME_MAX + 1]\n"
     "        if rest:\n"
     "            rep = dict(rep, _same=[{'row_id': x['row_id'], 'target': (x.get('target') or '')[:160]} for x in rest]); members[rep['row_id']] = rest\n"
     "        reps.append(rep)\n"
     "        for x in rs[SAME_MAX + 1:]:   # 상한 넘는 행은 다음 실행에서(같은 묶음의 대표 답이 기억되므로 그때 상속)\n"
     "            out.append(blank(x, '미검토', f'같은 증거 묶음 {SAME_MAX + 1}행 초과 — 다음 실행'))\n"
     "    n_same = sum(len(v) for v in members.values())\n"
     "    targets = reps\n"
     "    rk_lock = __import__('threading').Lock()\n"
     "\n"
     "    def _remember(r, it):\n"
     "        \"\"\"답 1건마다 행 기억 저장(중단돼도 다음 실행이 재사용)\"\"\"\n"
     "        if from_file or not it:\n"
     "            return\n"
     "        with rk_lock:\n"
     "            rowcache[rkey.get(r['row_id']) or row_key(ctx, r)] = it\n"
     "            try:\n"
     "                tmp = rc_p + '.tmp'; json.dump(rowcache, open(tmp, 'w', encoding='utf-8'), ensure_ascii=False); os.replace(tmp, rc_p)\n"
     "            except OSError:\n"
     "                pass\n"),
    ("    print(f'[AI 검토] 대상 {len(cand)}행(FAIL·판정필요·미검증) · 새로 검토 {len(targets)}행 · 기억 재사용 {len(hit)}행 · 검토 제외 {len(cand) - len(targets) - len(hit)}행 · 묶음 {len(ch)}개(묶음당 {n}행)', flush=True)\n"
     "    meta = {'calls': 0, 'cached': 0, 'failed': 0, 'cost': 0.0, 'chunks': len(ch)}",
     "    n_skip = sum(1 for x in out if x['class'] in ('검토 제외', '미검토'))\n"
     "    n_remeasure = sum(1 for x in out if (x.get('apply_why') or '').startswith('재측정 대상'))\n"
     "    print(f'[AI 검토] 대상 {len(cand)}행(FAIL·판정필요·미검증) · 새로 검토 {len(targets)}행(같은 증거 행 {n_same}행 함께) · 기억 재사용 {len(hit)}행 · 검토 제외 {n_skip}행(재측정 대상 {n_remeasure}) · 묶음 {len(ch)}개(묶음당 {n}행)', flush=True)\n"
     "    meta = {'calls': 0, 'cached': 0, 'failed': 0, 'cost': 0.0, 'chunks': len(ch), 'same': n_same, 'remeasure_skip': n_remeasure, 'row_hit': len(hit)}"),
    ("        res = llm_call.ask(mid, 'judge', prompt, rows=len(g))\n        if not res['ok'] and '해석 실패' in (res.get('why') or ''):",
     "        res = llm_call.ask(mid, 'judge', prompt, rows=len(g) + sum(len(members.get(x['row_id'], [])) for x in g))\n        if not res['ok'] and '해석 실패' in (res.get('why') or ''):"),
    ("            print(f\"  · AI 판정 검토 묶음 {_pdone[0]}/{len(ch)} — {len(g)}행 · 규칙 {','.join(sorted({x.get('rule_id') or '' for x in g}))}{' · 캐시' if res.get('cached') else ''}\", flush=True)\n        return i, g, res",
     "            print(f\"  · AI 판정 검토 묶음 {_pdone[0]}/{len(ch)} — {len(g)}행 · 규칙 {','.join(sorted({x.get('rule_id') or '' for x in g}))}{' · 캐시' if res.get('cached') else ''}\", flush=True)\n"
     "        if res.get('ok'):\n"
     "            _its = {str(it.get('row_id') or ''): it for it in ((res['data'] or {}).get('items') or []) if isinstance(it, dict)}\n"
     "            for r in g:\n"
     "                _remember(r, _its.get(r['row_id']))\n"
     "        return i, g, res"),
    ("    for i, g, res in _answers:\n        if not res['ok']:\n            meta['failed'] += 1\n            print(f\"[WARN] AI 검토 묶음 {i} 결과 없음 — {res['why']} · 기계 판정 유지\", flush=True)\n            out += [blank(r, '미검토', res['why'][:120]) for r in g]\n            continue",
     "    nochange = 0; new_solo = set()\n"
     "    for i, g, res in _answers:\n        if not res['ok']:\n            meta['failed'] += 1\n            print(f\"[WARN] AI 검토 묶음 {i} 결과 없음 — {res['why']} · 기계 판정 유지\", flush=True)\n            out += [blank(r, '미검토', res['why'][:120]) for r in g]\n"
     "            out += [blank(x, '미검토', '대표 행 결과 없음') for r in g for x in members.get(r['row_id'], [])]\n"
     "            continue\n"
     "        _n0 = sum(1 for x in out if x.get('apply') == 'Y')"),
    ("        for r in g:\n            it = items.get(r['row_id'])\n            out.append(decide(r, it) if it else blank(r, '미검토', '답에 이 행이 없음'))\n            if it and not from_file:\n                rowcache[rkey[r['row_id']]] = it\n",
     "        for r in g:\n            it = items.get(r['row_id'])\n            out.append(decide(r, it) if it else blank(r, '미검토', '답에 이 행이 없음'))\n"
     "            if it and not from_file:\n                rowcache[rkey[r['row_id']]] = it\n"
     "            # A3 같은 증거 행: 대표 답이 같다고 한 행은 같은 답으로 판정(인용은 대표 답 그대로 확인) · 예외 행은 다음 실행에 단독\n"
     "            ex = {str(x) for x in ((it or {}).get('except') or [])} if it else set()\n"
     "            same_ok = bool(it) and str(it.get('same') or 'Y').upper().startswith('Y')\n"
     "            for x in members.get(r['row_id'], []):\n"
     "                if it and same_ok and x['row_id'] not in ex:\n"
     "                    d_ = decide(x, dict(it, row_id=x['row_id'])); d_['reason'] = (f\"[대표 {r['row_id']} 와 같은 증거] \" + d_['reason'])[:900]; out.append(d_)\n"
     "                    if not from_file:\n"
     "                        rowcache[rkey.get(x['row_id']) or row_key(ctx, x)] = dict(it, row_id=x['row_id'])\n"
     "                else:\n"
     "                    out.append(blank(x, '미검토', f\"대표 {r['row_id']} 와 판단이 다름 — 다음 실행에 단독 검토\" if it else '대표 행 답 없음')); new_solo.add(x['row_id'])\n"
     "        if sum(1 for x in out if x.get('apply') == 'Y') == _n0 and not res.get('cached'):\n"
     "            nochange += 1\n"),
    ("    if not from_file and not dry:\n        try:\n            tmp = rc_p + '.tmp'; json.dump(rowcache, open(tmp, 'w', encoding='utf-8'), ensure_ascii=False); os.replace(tmp, rc_p)\n        except OSError as _e:\n            print(f'[WARN] 행 단위 기억 저장 실패: {_e}', flush=True)\n",
     "    if not from_file and not dry:\n        try:\n            tmp = rc_p + '.tmp'; json.dump(rowcache, open(tmp, 'w', encoding='utf-8'), ensure_ascii=False); os.replace(tmp, rc_p)\n        except OSError as _e:\n            print(f'[WARN] 행 단위 기억 저장 실패: {_e}', flush=True)\n"
     "        if new_solo:\n"
     "            try:\n"
     "                json.dump(sorted(solo | new_solo), open(solo_p, 'w', encoding='utf-8'), ensure_ascii=False)\n"
     "            except OSError:\n"
     "                pass\n"),
    ("    print(f'@@LINK 🧠 AI 판정 검토|Doc/verify/{mid}/llm_review.md', flush=True)\n    return 0\n",
     "    if not from_file:\n"
     "        w_ = llm_call.log_effect(mid, 'judge', calls=meta['calls'], cached=meta['cached'] + len(hit), applied=j['apply'], nochange_calls=nochange,\n"
     "                                 skipped_rows=n_remeasure, note=f\"같은 증거 함께 {n_same}행 · 실패 {meta['failed']}\")\n"
     "        if w_:\n"
     "            print(w_, flush=True)\n"
     "    print(f'@@LINK 🧠 AI 판정 검토|Doc/verify/{mid}/llm_review.md', flush=True)\n    return 0\n"),
    # ── 행 기억 키 함수 ──
    ("def chunks(targets, n):",
     "def row_key(ctx, r):\n"
     "    \"\"\"2026-11-20 A5 행 기억 키 — 행 내용 + 그 규칙의 TO-BE 룰 + AS-IS 화면 ID\"\"\"\n"
     "    b = row_brief(dict(r, _same=None))\n"
     "    return llm_call.key_of('judge-row2', json.dumps([ctx.get('asis_id'), b, rules_for(r.get('rule_id') or '')], ensure_ascii=False, sort_keys=True))\n\n\n"
     "def chunks(targets, n):"),
    # ── selftest ──
    ("    d = decide({'row_id': 'V-2', 'result': 'ERROR', 'evidence': 'x'}, {'class': '검사기오판', 'verdict': 'NA', 'evidence': good})\n    chk('반영 — 미검증 행은 의견만', d['apply'] == 'N' and d['class'] == '검사기오판')",
     "    d = decide({'row_id': 'V-2', 'result': 'ERROR', 'evidence': 'x'}, {'class': '검사기오판', 'verdict': 'NA', 'evidence': good})\n    chk('반영 — 미검증 행 NA 는 AS-IS 원문·룰 근거 필요', d['apply'] == 'N' and d['class'] == '검사기오판')\n"
     "    d = decide({'row_id': 'V-2', 'result': 'ERROR', 'evidence': 'x'}, {'class': '검사기오판', 'verdict': 'PASS', 'evidence': good})\n    chk('반영 — 미검증 행은 PASS 로 바꾸지 않음', d['apply'] == 'N')\n"
     "    sw = {'row_id': 'V-4', 'result': 'ERROR', 'evidence': '헤더 글자 잘림' + SWEEP_TAIL}\n"
     "    chk('판정 대기 — 판정필요 정리 꼬리 = 판정필요', eff_result(sw) == '판정필요' and remeasure_reason(sw) == '')\n"
     "    chk('재측정 대상 — 검사기 공백은 AI 에 보내지 않음', remeasure_reason({'result': 'ERROR', 'evidence': '[측정 경로 없음] 서버 콤보'}) != '')\n"
     "    chk('재측정 대상 — 시간 초과', remeasure_reason({'result': 'ERROR', 'evidence': 'locator.click Timeout 5000ms'}) != '')\n"
     "    chk('재측정 대상 아님 — FAIL', remeasure_reason({'result': 'FAIL', 'evidence': '[측정 경로 없음]'}) == '')\n"
     "    k1 = row_key({'asis_id': 'Z'}, {'row_id': 'V-9', 'rule_id': 'A1', 'result': 'FAIL', 'evidence': '값 다름 @11-19 10:00'})\n"
     "    k2 = row_key({'asis_id': 'Z'}, {'row_id': 'V-9', 'rule_id': 'A1', 'result': 'FAIL', 'evidence': '값 다름 @11-20 09:00'})\n"
     "    chk('행 기억 키 — 시각만 다르면 같음', k1 == k2)"),
])
