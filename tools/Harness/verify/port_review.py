# -*- coding: utf-8 -*-
"""UI 개발·보완 AI 지점(UI/DB MODE · 2026-11-20 사용자 지시 'UI 개발, UI 보완의 전반적인 과정에 AI 적용 고민') — 구간 D1·D3·D4

  python tools/Harness/verify/port_review.py <MENU_ID> --plan        D1 이식 목록: 기준 원장(criteria.csv) → Doc/gen/<ID>/port_plan.csv(코드 · AI 없음)
                                                                     항목마다 요소 · 확인 · 기대 · AS-IS 근거 · AS-IS 실측 · TO-BE 룰 · 참조 화면 패턴 칸. 개발 세션은 이 행 단위로 이식하고 구현 위치를 적는다
  python tools/Harness/verify/port_review.py <MENU_ID> --review      D3 개발 뒤 독립 검토(AI 읽기 전용): 이식 목록 행마다 구현 위치(파일:줄)와 그 줄 원문을 Claude 가 찾고,
                                                                     기계가 인용을 확인한다 → Doc/gen/<ID>/port_review.csv. 인용 미확인·'없음' 행 = 미구현 의심(종료코드 2)
  python tools/Harness/verify/port_review.py <MENU_ID> --diag        D4 보완 진단(AI 읽기 전용): CheckList 원인 묶음(action_summary.csv group)마다 고칠 계층·위치(파일:줄 인용)·정해진 보완(fix_recipes.csv) 해당 여부
                                                                     → Doc/verify/<ID>/repair_diag.csv · .md. 🧯 자동 보완은 정해진 보완(repair_apply.py)을 먼저, 남은 묶음만 고친다
  옵션 --dry(묶음·프롬프트 크기만) · --from <json>(호출 없이 답 반영) · --selftest
  쓰기: 이 도구는 FE·BE·DB 를 고치지 않는다(산출물 파일만). DB MODE(repairScope DB_ONLY)에서도 실행할 수 있다(진단 결과는 가이드로 쓰임)
"""
import argparse
import collections
import csv
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
csv.field_size_limit(10 ** 8)
PLAN_COLS = ['crit_id', 'elem_key', 'rule_id', 'check', 'expected', 'src_asis', 'src_live', 'src_rule', 'status', 'impl_where', 'impl_note']
REVIEW_COLS = ['crit_id', 'elem_key', 'rule_id', 'state', 'impl_ref', 'impl_quote', 'verified', 'verify_why', 'reason', 'at']
DIAG_COLS = ['group', 'rows', 'layer', 'fix_ref', 'fix_quote', 'verified', 'recipe', 'reason', 'at']
LAYERS = ('DB_OBJECT', 'DB_META', 'FE', 'BE', 'COMMON', 'CHECKER', 'HUMAN')
BATCH = 12


def P(*a):
    return os.path.join(ROOT, *a)


def read_csv(p):
    try:
        with open(p, encoding='utf-8-sig', newline='') as f:
            return list(csv.DictReader(f))
    except OSError:
        return []


def write_csv(p, cols, rows):
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p + '.tmp', 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=cols, extrasaction='ignore'); w.writeheader(); w.writerows(rows)
    os.replace(p + '.tmp', p)


def now():
    import datetime
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


# ── D1 이식 목록 ──
def plan(mid):
    crit = read_csv(P('Doc', 'verify', mid, 'criteria', 'criteria.csv'))
    if not crit:
        print(f'[ERROR] 기준 원장 없음 — python tools/Harness/verify/criteria_build.py {mid} 먼저'); return 3
    keep = [x for x in crit if x.get('status') != '대상 아님']
    old = {x['crit_id']: x for x in read_csv(P('Doc', 'gen', mid, 'port_plan.csv'))}   # 개발 세션이 적은 구현 위치는 보존
    rows = [dict({k: x.get(k, '') for k in PLAN_COLS}, impl_where=old.get(x['crit_id'], {}).get('impl_where', ''), impl_note=old.get(x['crit_id'], {}).get('impl_note', ''))
            for x in sorted(keep, key=lambda x: (x.get('elem_key', ''), x.get('rule_id', '')))]
    write_csv(P('Doc', 'gen', mid, 'port_plan.csv'), PLAN_COLS, rows)
    print(f"[이식 목록 {mid}] 기준 항목 {len(crit)} 중 대상 {len(rows)}(대상 아님 {len(crit) - len(rows)} 제외) · 구현 위치 기록 {sum(1 for r in rows if r['impl_where'])} → Doc/gen/{mid}/port_plan.csv")
    return 0


REVIEW_PROMPT = """너는 화면 {mid} 의 AS-IS → TO-BE 이식 결과를 검토한다. 개발 세션과 다른 검토자다. 파일을 고치지 않는다(Read·Glob·Grep 만).
TO-BE 화면 폴더: {page_dir} · TO-BE 패키지 원문: To-be_v2_converted/06_Packages/ · AS-IS 화면 소스: {asis_files}
아래 이식 항목마다 TO-BE 에서 그 확인(기대)을 구현한 위치를 찾아라.
- state = 구현(위치 찾음) · 없음(찾았는데 없음 — reason 에 무엇을 어디서 찾았는지) · 판단불가
- 구현이면 impl = {{"ref":"경로:줄","quote":"그 줄 원문 일부를 글자 그대로"}}. 기계가 그 줄(±3줄)에서 원문을 확인한다. 확인 안 되면 미구현으로 본다.
- 대조표(__asis-mapping__.md)의 상태 문구를 그대로 믿지 않는다. 코드에서 직접 찾는다.

항목(JSON):
{items}

답은 JSON 하나만: {{"items":[{{"crit_id":"…","state":"구현|없음|판단불가","impl":{{"ref":"…","quote":"…"}},"reason":"한 문장"}}]}}"""

DIAG_PROMPT = """너는 화면 {mid} CheckList 결함의 보완 위치를 진단한다. 파일을 고치지 않는다(Read·Glob·Grep 만).
TO-BE 화면 폴더: {page_dir} · TO-BE 패키지 원문: To-be_v2_converted/06_Packages/ · 메타 SQL: Doc/tobefacts/db/ · AS-IS 화면 소스: {asis_files}
정해진 보완 처방(fix_recipes.csv): {recipes}
아래 원인 묶음마다 고칠 계층과 위치를 정하라.
- layer = DB_OBJECT(PKG·SP) · DB_META(메뉴·컬럼·메시지 메타) · FE · BE · COMMON(공용 컴포넌트) · CHECKER(검사기 오판 — 화면은 맞음) · HUMAN(업무 결정 필요)
- fix = {{"ref":"경로:줄","quote":"그 줄 원문 일부"}} — 고칠 줄. 기계가 확인한다. 못 찾으면 비운다.
- recipe = 위 처방 중 그대로 쓸 수 있는 rule_id(없으면 빈 값)

원인 묶음(JSON):
{groups}

답은 JSON 하나만: {{"groups":[{{"group":"…","layer":"…","fix":{{"ref":"…","quote":"…"}},"recipe":"","reason":"한 문장"}}]}}"""


def _ask_all(mid, kind, prompts, from_file=None):
    import llm_call
    import concurrent.futures as cf
    if from_file:
        d = llm_call.parse_json(open(from_file, encoding='utf-8-sig').read())
        return [{'ok': True, 'data': d, 'cached': False} for _ in prompts]
    par = max(1, int(llm_call.cfg().get('llmReviewPar') or 4))
    with cf.ThreadPoolExecutor(max_workers=par) as ex:
        return list(ex.map(lambda p: llm_call.ask(mid, kind, p[1], rows=p[0]), prompts))


def review(mid, dry=False, from_file=None):
    import llm_call, llm_review
    rows = read_csv(P('Doc', 'gen', mid, 'port_plan.csv'))
    if not rows:
        print(f'[ERROR] 이식 목록 없음 — port_review.py {mid} --plan 먼저'); return 3
    ctx = llm_review.screen_ctx(mid)
    ch = [rows[i:i + BATCH] for i in range(0, len(rows), BATCH)]
    prompts = [(len(g), REVIEW_PROMPT.format(mid=mid, page_dir=ctx['page_dir'] or '(없음)', asis_files=' · '.join(ctx['asis_files'][:8]),
                                             items=json.dumps([{k: g_[k] for k in ('crit_id', 'elem_key', 'rule_id', 'check', 'expected', 'src_asis', 'src_rule', 'impl_where')} for g_ in g], ensure_ascii=False, indent=0))) for g in ch]
    print(f'[이식 검토 {mid}] 항목 {len(rows)} · 묶음 {len(ch)}', flush=True)
    if dry:
        for i, (n, p) in enumerate(prompts, 1):
            print(f'  묶음 {i}: {n}행 · 프롬프트 {len(p)}자')
        return 0
    res = _ask_all(mid, 'port', prompts, from_file)
    out = []
    for g, r in zip(ch, res):
        items = {str(x.get('crit_id')): x for x in ((r.get('data') or {}).get('items') or []) if isinstance(x, dict)} if r.get('ok') else {}
        for x in g:
            it = items.get(x['crit_id']) or {}
            imp = it.get('impl') if isinstance(it.get('impl'), dict) else {}
            ok, why = llm_call.verify_quote(imp.get('ref'), imp.get('quote')) if it.get('state') == '구현' else (False, it.get('state') or '답 없음')
            out.append({'crit_id': x['crit_id'], 'elem_key': x['elem_key'], 'rule_id': x['rule_id'], 'state': it.get('state') or '답 없음', 'impl_ref': imp.get('ref', ''),
                        'impl_quote': str(imp.get('quote') or '')[:300], 'verified': 'Y' if ok else 'N', 'verify_why': why[:200], 'reason': str(it.get('reason') or '')[:400], 'at': now()})
    write_csv(P('Doc', 'gen', mid, 'port_review.csv'), REVIEW_COLS, out)
    bad = [x for x in out if x['verified'] != 'Y']
    print(f"[이식 검토 {mid}] 구현 확인 {len(out) - len(bad)} · 미구현 의심 {len(bad)}(없음 {sum(1 for x in bad if x['state'] == '없음')} · 인용 미확인·판단불가 {sum(1 for x in bad if x['state'] != '없음')}) → Doc/gen/{mid}/port_review.csv")
    return 2 if bad else 0


def diag(mid, dry=False, from_file=None):
    import llm_call, llm_review
    summ = read_csv(P('Doc', 'verify', mid, 'action_summary.csv'))
    fx = {x.get('row_id'): x for x in read_csv(P('Doc', 'verify', mid, 'fixlist.csv'))}
    groups = collections.OrderedDict()
    for x in summ:
        g = (x.get('group') or x.get('row_id') or '').strip()
        if not g:
            continue
        e = groups.setdefault(g, {'group': g, 'title': '', 'gap': '', 'rows': []})
        e['rows'].append(x.get('row_id', ''))
        if x.get('title'):
            e['title'] = x['title']; e['gap'] = x.get('gap', ''); e['where'] = x.get('where', '')
    open_g = [g for g in groups.values() if any((fx.get(r) or {}).get('action_needed', 'Y') != 'N' for r in g['rows'])] or list(groups.values())
    recipes = '; '.join(f"{r.get('rule_id')}({r.get('layer')}: {(r.get('change_template') or '')[:60]})" for r in read_csv(P('tools', 'Harness', 'rules', 'fix_recipes.csv')))
    ctx = llm_review.screen_ctx(mid)
    ch = [open_g[i:i + BATCH] for i in range(0, len(open_g), BATCH)]
    prompts = [(len(g), DIAG_PROMPT.format(mid=mid, page_dir=ctx['page_dir'] or '(없음)', asis_files=' · '.join(ctx['asis_files'][:8]), recipes=recipes[:3000],
                                           groups=json.dumps([{k: g_.get(k, '') for k in ('group', 'title', 'gap', 'where')} | {'rows': g_['rows'][:8]} for g_ in g], ensure_ascii=False, indent=0))) for g in ch]
    print(f'[보완 진단 {mid}] 원인 묶음 {len(open_g)} · AI 묶음 {len(ch)}', flush=True)
    if dry:
        for i, (n, p) in enumerate(prompts, 1):
            print(f'  묶음 {i}: {n}개 · 프롬프트 {len(p)}자')
        return 0
    res = _ask_all(mid, 'repair', prompts, from_file)
    rid = {(r.get('rule_id') or '').upper() for r in read_csv(P('tools', 'Harness', 'rules', 'fix_recipes.csv'))}
    out = []
    for g, r in zip(ch, res):
        items = {str(x.get('group')): x for x in ((r.get('data') or {}).get('groups') or []) if isinstance(x, dict)} if r.get('ok') else {}
        for x in g:
            it = items.get(x['group']) or {}
            fx_ = it.get('fix') if isinstance(it.get('fix'), dict) else {}
            ok, why = llm_call.verify_quote(fx_.get('ref'), fx_.get('quote')) if fx_.get('ref') else (False, '위치 없음')
            lay = it.get('layer') if it.get('layer') in LAYERS else ''
            rc = (it.get('recipe') or '').upper(); rc = rc if rc in rid else ''
            out.append({'group': x['group'], 'rows': ';'.join(x['rows']), 'layer': lay or '판단불가', 'fix_ref': fx_.get('ref', ''), 'fix_quote': str(fx_.get('quote') or '')[:300],
                        'verified': 'Y' if ok else 'N', 'recipe': rc, 'reason': str(it.get('reason') or '')[:400], 'at': now()})
    write_csv(P('Doc', 'verify', mid, 'repair_diag.csv'), DIAG_COLS, out)
    c = collections.Counter(x['layer'] for x in out)
    L = [f'# {mid} 보완 진단 ({now()})', '', '- 계층별 ' + ' · '.join(f'{k} {v}' for k, v in c.items()) + f" · 위치 인용 확인 {sum(1 for x in out if x['verified'] == 'Y')}/{len(out)} · 정해진 보완 해당 {sum(1 for x in out if x['recipe'])}", '',
         '| 묶음 | 계층 | 고칠 곳 | 인용 | 처방 | 사유 |', '|---|---|---|---|---|---|']
    L += [f"| {x['group']} | {x['layer']} | {x['fix_ref']} | {x['verified']} | {x['recipe']} | {x['reason'].replace('|', '/')[:200]} |" for x in out]
    open(P('Doc', 'verify', mid, 'repair_diag.md'), 'w', encoding='utf-8').write('\n'.join(L) + '\n')
    print(f'[보완 진단 {mid}] ' + L[2][2:] + f' → Doc/verify/{mid}/repair_diag.md')
    return 0


def selftest():
    ok = True

    def chk(n, c):
        nonlocal ok
        print(('  [OK] ' if c else '  [FAIL] ') + n); ok = ok and bool(c)
    chk('프롬프트 — 이식 검토 출력 형식', '"items"' in REVIEW_PROMPT and '{items}' in REVIEW_PROMPT)
    chk('프롬프트 — 보완 진단 계층', all(x in DIAG_PROMPT for x in ('DB_OBJECT', 'CHECKER', 'HUMAN')))
    chk('계층 값 목록', len(LAYERS) == 7)
    print('SELFTEST ' + ('OK' if ok else 'FAIL'))
    return 0 if ok else 1


def main():
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest':
        return selftest()
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id'); g = ap.add_mutually_exclusive_group(required=True)
    g.add_argument('--plan', action='store_true'); g.add_argument('--review', action='store_true'); g.add_argument('--diag', action='store_true')
    ap.add_argument('--dry', action='store_true'); ap.add_argument('--from', dest='from_file')
    a = ap.parse_args(); mid = a.menu_id.upper()
    if a.plan:
        return plan(mid)
    import llm_call
    kind = 'port' if a.review else 'repair'
    if not (a.dry or a.from_file) and not llm_call.enabled(kind):
        print(f'[AI] 꺼짐(harness.json llmReviewKinds 에 {kind} 없음) — 건너뜀'); return 0
    return review(mid, a.dry, a.from_file) if a.review else diag(mid, a.dry, a.from_file)


if __name__ == '__main__':
    sys.exit(main())
