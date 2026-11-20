# -*- coding: utf-8 -*-
"""구간 C1·C2·A8
   C1 unverified_resolve.py: 판단 행(분류표 담당 '판단')은 AI 판정 검토가 먼저 본다. 검토가 끝났는데 판정이 남은 행 = 담당 '결정'(사람 결정 목록 · 엔진 작업 목록에서 뺌).
      AI 가 검사기오판·추출오류·미등록 TO-BE 룰로 가린 행은 담당 '엔진'(검사기 보완). AI 검토가 꺼져 있거나 검토 기록이 없으면 종전대로 '판단'(세션이 처리)
   C2 checklist_run.py --recheck: 팝업·권한 검사기(EG-)·E2E 4종(ES-)·차등 검증(ASIS_DIFF) 행이 있어도 전체로 돌리지 않고
      그 단계만 함께 다시 돈다(run_verify --only + VERIFY_DELTA_STAGES eg·suite·diff — 수정분 재점검 경로와 같은 장치)
      run_verify.py: --only 규칙에 @verify 시험이 없어도 그 규칙이 요청한 단계(eg·suite·diff)로만 판정되면 중단하지 않는다(VERIFY_STAGE_RULES)
   A8 checklist_run.py 끝 줄: 이번 실행의 AI 지점별 호출·반영·무변화 호출(llm_effect.csv)"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pt import patch

D = sys.argv[1]
patch(os.path.join(D, 'unverified_resolve.py'), [
    ("    ai_n = ai_review_rows(mid, tri)\n    after = counts(tri)\n",
     "    ai_n = ai_review_rows(mid, tri)\n"
     "    dec_n = judge_rows_to_decision(mid, tri)   # 2026-11-20 C1\n"
     "    after = counts(tri)\n"),
    ("def _read(p):\n",
     "def judge_rows_to_decision(mid, tri):\n"
     "    \"\"\"2026-11-20 C1(사용자 지시 '판단이 필요한 부분에만 AI · 미검증 1회 해소'): 담당 '판단' 행 정리.\n"
     "       판단 행은 검사기를 고쳐도 줄지 않는다(기계가 비교는 했고 결론을 못 낸 행). 판정 검토(llm_review.py)가 판정필요와 같이 보고, 근거가 확인되면 judge 가 판정을 바꾼다.\n"
     "       여기 남은 판단 행 = 검토는 했으나 근거로 결론이 안 난 행 → 담당 '결정'(결정 목록 · 처리 대상 아님).\n"
     "       AI 가 검사기오판·추출오류·미등록 룰로 가린 행 → 담당 '엔진'. 검토 기록이 없거나 AI 검토가 꺼져 있으면 종전 '판단' 유지(세션 처리). 반환 = 결정으로 옮긴 행 수\"\"\"\n"
     "    try:\n"
     "        import llm_call as _lc\n"
     "        if not _lc.enabled('judge'):\n"
     "            return 0\n"
     "    except Exception:\n"
     "        return 0\n"
     "    rv = {x['row_id']: x for x in _read(os.path.join(ROOT, 'Doc', 'verify', mid, 'llm_review.csv')) if x.get('row_id')}\n"
     "    if not rv:\n"
     "        return 0\n"
     "    n = 0\n"
     "    for t in tri:\n"
     "        if t.get('actor') != '판단' or t.get('_ai'):\n"
     "            continue\n"
     "        x = rv.get(t['row_id'])\n"
     "        if not x or x.get('class') in ('미검토', '검토 제외', ''):\n"
     "            continue   # 아직 검토 안 됨 — 다음 판정 검토가 본다(종전 담당 유지)\n"
     "        if x.get('class') in AI_ENGINE and x.get('verified') == 'Y':\n"
     "            t['actor'] = '엔진'; continue\n"
     "        t['actor'] = '결정'; n += 1\n"
     "        t['remedy'] = ('AI 판정 검토 결과 근거로 결론이 나지 않음(' + (x.get('class') or '') + ' · ' + (x.get('apply_why') or '') + ') → 결정 목록 · 근거 ' + (x.get('evidence_ref') or '없음') + ' · ' + (x.get('reason') or '')[:300])[:900]\n"
     "    return n\n\n\n"
     "def _read(p):\n"),
    ("            'human': by_actor['사람'], 'aggregate': by_actor['집계'], 'blocked': by_actor['보완'], 'guide': by_actor['가이드']}",
     "            'human': by_actor['사람'], 'aggregate': by_actor['집계'], 'blocked': by_actor['보완'], 'guide': by_actor['가이드'], 'decide': by_actor['결정']}"),
    ("f'미검증 {before[\"total\"]} → {after[\"total\"]}행, 처리 대상 {after[\"actionable\"]}(AI 판정 검토가 가린 엔진 보완 대상 {ai_n} 포함), 사람 확인 {after[\"human\"]}, 집계 {after[\"aggregate\"]}'",
     "f'미검증 {before[\"total\"]} → {after[\"total\"]}행, 처리 대상 {after[\"actionable\"]}(AI 판정 검토가 가린 엔진 보완 대상 {ai_n} 포함), 사람 확인 {after[\"human\"]}, 결정 목록 {after[\"decide\"]}(판단 행 중 AI 검토로 결론 안 남 {dec_n}), 집계 {after[\"aggregate\"]}'"),
])

patch(os.path.join(D, 'checklist_run.py'), [
    ("def recheck_rules(mid):\n    \"\"\"(규칙 목록, 사유) — 규칙 목록이 비면 전체 실행\"\"\"",
     "STAGE_OF = (('EG-', 'eg', '팝업·권한 검사기'), ('ES-', 'suite', 'E2E 4종'))\n\n\n"
     "def recheck_plan(mid):\n"
     "    \"\"\"2026-11-20 C2: (규칙 목록, 함께 돌 단계 목록, 단계로만 판정되는 규칙, 사유) — 규칙 목록이 비면 전체 실행.\n"
     "       종전(recheck_rules)은 EG-·ES-·ASIS_DIFF 행이 1행만 있어도 전체로 돌았다(11-20 SCP0005·SCP0028·SSP0014 재점검 3건 모두 전체 · 1단계 96~137분)\"\"\"\n"
     "    p = os.path.join(ROOT, 'Doc', 'verify', mid, 'unverified_triage.csv')\n"
     "    if not os.path.exists(p):\n"
     "        return [], [], [], '미검증 분류 결과 없음'\n"
     "    rows = [r for r in csv.DictReader(open(p, encoding='utf-8-sig')) if r.get('actor') in WORK]\n"
     "    if not rows:\n"
     "        return [], [], [], '처리 대상 0행'\n"
     "    stages, names, per_rule = set(), set(), {}\n"
     "    for r in rows:\n"
     "        rid = (r.get('rule_id') or '').upper(); st = ''\n"
     "        if r.get('source') == 'ASIS_DIFF':\n"
     "            st = 'diff'; names.add('차등 검증')\n"
     "        for pre, s_, nm in STAGE_OF:\n"
     "            if (r.get('row_id') or '').startswith(pre):\n"
     "                st = s_; names.add(nm)\n"
     "        if st:\n"
     "            stages.add(st)\n"
     "        if rid:\n"
     "            per_rule.setdefault(rid, set()).add(st or 'verify')\n"
     "    rules = sorted(per_rule)\n"
     "    stage_rules = sorted(r for r, s in per_rule.items() if 'verify' not in s)\n"
     "    if not rules:\n"
     "        return [], [], [], f'처리 대상 {len(rows)}행에 규칙 ID 없음'\n"
     "    return rules, sorted(stages), stage_rules, f'처리 대상 {len(rows)}행 · 규칙 {len(rules)}개' + (f\" · 함께 돌 단계 {', '.join(sorted(names))}\" if stages else '')\n\n\n"
     "def effect_line(mid, since):\n"
     "    \"\"\"2026-11-20 A8: 이번 실행의 AI 지점별 효과(Doc/verify/<ID>/llm_effect.csv)\"\"\"\n"
     "    try:\n"
     "        rs = [r for r in csv.DictReader(open(os.path.join(ROOT, 'Doc', 'verify', mid, 'llm_effect.csv'), encoding='utf-8-sig')) if (r.get('at') or '') >= since]\n"
     "    except OSError:\n"
     "        return ''\n"
     "    if not rs:\n"
     "        return ''\n"
     "    by = {}\n"
     "    for r in rs:\n"
     "        a = by.setdefault(r.get('kind') or '', [0, 0, 0, 0])\n"
     "        for i, k in enumerate(('calls', 'cached', 'applied', 'nochange_calls')):\n"
     "            try:\n"
     "                a[i] += int(float(r.get(k) or 0))\n"
     "            except ValueError:\n"
     "                pass\n"
     "    return '[AI 효과] ' + ' · '.join(f'{k} 호출 {v[0]}(기억 {v[1]}) 반영 {v[2]} 무변화 호출 {v[3]}' for k, v in sorted(by.items())) + f' · Doc/verify/{mid}/llm_effect.csv'\n\n\n"
     "def recheck_rules(mid):\n    \"\"\"(규칙 목록, 사유) — 규칙 목록이 비면 전체 실행\"\"\""),
    ("    if a.recheck:\n        rules, why = recheck_rules(mid)\n        if rules:\n            print(f'[INFO] CheckList 재수행 = 미검증 행만 — {why}: {\",\".join(rules)}', flush=True)\n            print(f'[작업 1/{jobs}] CheckList 재측정(미검증 규칙만 --only)', flush=True)\n            rc = run(['py', rv, mid, '--only', ','.join(rules)])\n",
     "    if a.recheck:\n        rules, stages, stage_rules, why = recheck_plan(mid)\n        if rules:\n            print(f'[INFO] CheckList 재수행 = 미검증 행만 — {why}: {\",\".join(rules)}', flush=True)\n            print(f'[작업 1/{jobs}] CheckList 재측정(미검증 규칙만 --only' + (f\" + 단계 {','.join(stages)}\" if stages else '') + ')', flush=True)\n"
     "            env = dict(os.environ, VERIFY_DELTA_STAGES=','.join(stages), VERIFY_STAGE_RULES=','.join(stage_rules))\n"
     "            print('$ ' + ' '.join([rv, mid, '--only', ','.join(rules)])[:400] + (f' (VERIFY_DELTA_STAGES={\",\".join(stages)})' if stages else ''), flush=True)\n"
     "            rc = subprocess.call([sys.executable, rv, mid, '--only', ','.join(rules)], cwd=ROOT, env=env)\n"),
    ("    rv = os.path.join(HERE, 'run_verify.py'); ur = os.path.join(HERE, 'unverified_resolve.py')\n",
     "    rv = os.path.join(HERE, 'run_verify.py'); ur = os.path.join(HERE, 'unverified_resolve.py')\n"
     "    import datetime as _dt\n    started = _dt.datetime.now().strftime('%Y-%m-%d %H:%M:%S')\n"),
    ("    except (OSError, ValueError, KeyError):\n        pass\n    return rc\n",
     "    except (OSError, ValueError, KeyError):\n        pass\n"
     "    el = effect_line(mid, started)\n"
     "    if el:\n"
     "        print(el, flush=True)\n"
     "    return rc\n"),
    ("print(f\"[{'OK' if not j.get('actionable') else 'INFO'}] 미검증 {j['after']['total']}행 · 처리 대상 {j.get('actionable')} · 사람 확인 {j.get('human')} · 보완 대기 {j['after'].get('blocked', 0)} · 집계 {j['after'].get('aggregate')}\", flush=True)",
     "print(f\"[{'OK' if not j.get('actionable') else 'INFO'}] 미검증 {j['after']['total']}행 · 처리 대상 {j.get('actionable')} · 사람 확인 {j.get('human')} · 결정 목록 {j['after'].get('decide', 0)} · 보완 대기 {j['after'].get('blocked', 0)} · 집계 {j['after'].get('aggregate')}\", flush=True)"),
])

patch(os.path.join(D, 'run_verify.py'), [
    ("                if not titles and not snap_rules:\n                    print(f\"[FAIL] --only {','.join(sorted(only))}: 이 규칙을 판정하는 @verify/@trace 테스트를 스펙 본문에서 찾지 못함",
     "                _stage_rules = {x.strip().upper() for x in os.environ.get('VERIFY_STAGE_RULES', '').split(',') if x.strip()}\n"
     "                if not titles and not snap_rules and DSTAGES and not (only - _stage_rules):\n"
     "                    titles = ['__stages_only__']   # 2026-11-20 C2: 이 규칙들은 함께 도는 단계(eg·suite·diff)로만 판정 — @verify/@trace 는 돌릴 것이 없음\n"
     "                    print(f\"[INFO] --only {','.join(sorted(only))} = 단계 {','.join(sorted(DSTAGES))} 로만 판정되는 규칙 — @verify/@trace 재실행 없음\", flush=True)\n"
     "                if not titles and not snap_rules:\n                    print(f\"[FAIL] --only {','.join(sorted(only))}: 이 규칙을 판정하는 @verify/@trace 테스트를 스펙 본문에서 찾지 못함"),
])
