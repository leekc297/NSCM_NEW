# -*- coding: utf-8 -*-
"""보완 계획 — fixlist.csv(조치 필요·판정 필요 행) × fix_recipes.csv(규칙별 보정 레시피) → Doc/verify/<ID>/repair_plan.md (2026-11-08 · 사용자 결정 '순차 진행' (c))

  python tools/Harness/verify/repair_plan.py <MENU_ID> [--all]     기본 = action_needed=Y(조치 필요) 행만 · --all 은 판정 필요 포함

계층·적용 여부는 fixlist 가 이미 정한 값(decide_layer · repairScope)을 그대로 쓴다. 이 도구는 **적용하지 않는다** — 레시피가 있는 행은
'변경 요지·대상·검증(--only 부분 재판정)' 을 붙여 보완 메뉴(🛠️/🧯)와 사람이 바로 쓰게 하고, 레시피 없는 규칙은 '레시피 없음(가이드 작성 대상)' 으로 센다.
auto_apply=Y 레시피도 여기서는 표시만 한다(자동 적용은 보완실행 단계 · hook #152 절차).
"""
import csv, io, os, sys, collections

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
LAYER_ORDER = ['DB_META', 'DB_OBJECT', 'FE', 'COMMON', 'HUMAN']


def rd(p):
    return list(csv.DictReader(io.open(p, encoding='utf-8-sig'))) if os.path.exists(p) else []


def main(mid, all_rows=False):
    mid = mid.upper()
    fx = rd(os.path.join(ROOT, 'Doc', 'verify', mid, 'fixlist.csv'))
    if not fx:
        print(f'[repair_plan] {mid}: fixlist.csv 없음 — run_verify.py {mid} 먼저'); return 3
    rc = rd(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'fix_recipes.csv'))
    def recipe(rule, layer):
        for key in ((rule, layer), (rule, '*')):
            for x in rc:
                if (x.get('rule_id'), x.get('layer') or '*') == key:
                    return x
        return None
    rows = [f for f in fx if all_rows or (f.get('action_needed') or 'N') == 'Y']
    rows = [f for f in rows if f.get('rule_id') != 'X-ROW']  # 집계 행은 원천 행이 따로 있다
    by_layer = collections.defaultdict(list); missing = collections.Counter()
    for f in rows:
        r = recipe(f['rule_id'], f['layer'])
        if not r: missing[f['rule_id']] += 1
        by_layer[f['layer']].append((f, r))
    L = [f'# 보완 계획 {mid} — {__import__("time").strftime("%Y-%m-%d %H:%M")} · 대상 {"조치 필요+판정 필요" if all_rows else "조치 필요"} {len(rows)}행 · 레시피 있음 {sum(1 for l in by_layer.values() for _, r in l if r)} · 레시피 없음 {sum(missing.values())}', '',
         '> 적용은 보완실행 단계에서(hook #152 절차 · repairScope 에 따라 FE 는 가이드). 각 행의 검증 = 부분 재판정 명령(--only) 1회.', '']
    for lay in LAYER_ORDER + [k for k in by_layer if k not in LAYER_ORDER]:
        items = by_layer.get(lay)
        if not items: continue
        L += [f'## {lay} — {len(items)}행 · 적용 여부: {items[0][0].get("apply", "")}', '', '| 보완 ID | 규칙 | 대상 | 현상(실측) | 변경 요지(레시피) | 대상 객체 | 검증 | 자동 |', '|---|---|---|---|---|---|---|---|']
        for f, r in items:
            fmt = lambda s: (s or '').replace('{mid}', mid).replace('{row_id}', f['row_id']).replace('{target}', f['target'])
            ch = fmt(r['change_template']) if r else '(레시피 없음 — 가이드 작성 대상)'
            ob = fmt(r['object_pattern']) if r else (f.get('object') or '')
            vf = fmt(r['verify_cmd']) if r and r.get('verify_cmd') else f"python tools/Harness/verify/run_verify.py {mid} --only {f['rule_id']}"
            L.append(f"| {f['fix_id']} | {f['rule_id']} | {f['target'][:40].replace('|', '／')} | {(f.get('symptom') or '')[:120].replace('|', '／')} | {ch[:160].replace('|', '／')} | {ob[:60].replace('|', '／')} | `{vf}` | {(r.get('auto_apply') if r else '-')} |")
        L.append('')
    if missing:
        L += ['## 레시피 없는 규칙(가이드 작성 대상)', ''] + [f'- {k}: {n}행' for k, n in missing.most_common()]
    out = os.path.join(ROOT, 'Doc', 'verify', mid, 'repair_plan.md')
    io.open(out, 'w', encoding='utf-8', newline='\n').write('\n'.join(L) + '\n')
    print(f"[repair_plan] {mid}: {len(rows)}행 → 계층 " + ' · '.join(f'{k} {len(v)}' for k, v in by_layer.items()) + f" · 레시피 없음 {dict(missing)} → Doc/verify/{mid}/repair_plan.md")
    return 0


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(1)
    sys.exit(main(sys.argv[1], '--all' in sys.argv))
