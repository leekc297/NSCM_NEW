# -*- coding: utf-8 -*-
"""검사 커버리지 집계 — Doc/verify/<ID>/coverage.csv + 봉투 summary.coverage (2026-10-30 WP8-b · 검사기 결함 T13 "Playwright passed ≠ 판정")

  python tools/Harness/verify/coverage.py <MENU_ID> [--asis <AS-IS ID>]      exit 0 · SUSPECT_NA100 있으면 exit 2

규칙(impl=Y)마다 원장 행을 센다: measured(PASS/FAIL — 측정 근거 접두) · not_run(NOT_RUN/ERROR) · na · na_pct.
feature_present(규칙) = AS-IS facts 에 그 규칙의 대상 기능이 있는가(화면 리터럴 없음):
  C4 ← actions GRID_CLEAR ∧ *Changed 핸들러 · G3/K-SA ← controls UsrConditionPanel · F1/F2/F4/F6 ← SAVE 엔드포인트(endpoints _SAVE_ 또는 btn SAVE)
  D1/D3 ← lock_rules 행 · E1/H8/H13 ← cell_rules NUMBER 또는 dyn_columns · K4 ← *Button 멤버 · D5 ← cell_rules 비TEXT · C1 ← LIST_REBIND/*Changed · A6 ← sort_rules
SUSPECT_NA100 = 기능은 있는데 측정 0(전부 NA/미실행) — 검사기가 대상을 못 만든 것(T15 류). 봉투 verdict hold + run_verify rc 10
원천은 원장(verify_ledger.csv)뿐이다 — Playwright 통과 수는 쓰지 않는다.
"""
import argparse, csv, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
RX_MEASURED = re.compile(r'^(E2E|STATIC|META|SYN|DB|W1 |sort)')
RX_INHERITED = re.compile(r'^(\[[^\]]*\]\s*|실측\[T-[0-9a-f]+\]: )*(행 집계|진입점 집계|선행 미구현에 종속|선행 대조표 |규칙 \w+ )')


def rd(p):
    if not os.path.exists(p): return []
    with open(p, encoding='utf-8-sig', newline='') as f: return list(csv.DictReader(f))


def feature_present(rule, sd):
    acts = rd(os.path.join(sd, 'actions.csv')); kinds = {a['kind'] for a in acts}; meths = {a['method'] for a in acts}
    ctls = rd(os.path.join(sd, 'controls.csv')); eps = rd(os.path.join(sd, 'endpoints.csv'))
    cell = rd(os.path.join(sd, 'cell_rules.csv')); dyn = rd(os.path.join(sd, 'dyn_columns.csv')); locks = rd(os.path.join(sd, 'lock_rules.csv')); sorts = rd(os.path.join(sd, 'sort_rules.csv'))
    changed = any(re.search(r'(Changed|ItemCheck|ValueChanged)$', m) for m in meths)
    save = any(re.search(r'_SAVE_|_SAVE$|SAVE', (e.get('candidate') or e.get('key') or '').upper()) for e in eps)
    num = any(c.get('cell_type') == 'NUMBER' for c in cell) or any(d.get('cell_type') == 'NUMBER' for d in dyn)
    # 2026-11-05 T56: E1(숫자 입력 규칙) 은 'NUMBER 셀이 있다' 만으로는 기능 있음이 아니다 — AS-IS 가 그 컬럼을 전 행 잠그면(lock_rules locked=Y ALL_ROWS/MODE,
    #   같은 컬럼의 locked=N 해제 없음) 입력 경로 자체가 없어 E1 대상이 0 이 맞다(SCP0084: Find_Data L327 전 컬럼 잠금 · EditButton L249 MEMO 만 해제 → 숫자 컬럼 전부 잠김).
    #   종전엔 이런 화면이 SUSPECT_NA100 으로 잡혀 rc 10(커버리지 게이트) 오판이 났다(11-05 05:38 SCP0084).
    locked_all, unlocked = set(), set()
    for l in locks:
        cols = {c.strip().upper() for c in (l.get('columns') or '').split(';') if c.strip()}
        if (l.get('locked') or '').upper() == 'N': unlocked |= cols
        elif (l.get('locked') or '').upper() == 'Y' and (l.get('scope') or '') in ('ALL_ROWS', 'MODE'): locked_all |= cols
    num_cols = {(c.get('column') or '').upper() for c in cell if c.get('cell_type') == 'NUMBER'} | {(d.get('column') or d.get('binding') or '').upper() for d in dyn if d.get('cell_type') == 'NUMBER'}
    num_editable = any(c and (c not in locked_all or c in unlocked) for c in num_cols) if locks else num
    table = {
        'C4': 'GRID_CLEAR' in kinds and changed, 'C1': ('LIST_REBIND' in kinds or 'COMBO_DATA' in kinds) and changed,
        'G3': any('UsrConditionPanel' in (c.get('type') or '') for c in ctls), 'K-SA': any('UsrConditionPanel' in (c.get('type') or '') for c in ctls),
        'F1': save, 'F2': save, 'F4': bool(eps), 'F6': save, 'E3': save,
        'D1': bool(locks), 'D3': any(l.get('scope') == 'ROW_COND' for l in locks),
        'E1': num_editable, 'H8': num or any(c.get('cell_type') in ('DATE', 'DATETIME') for c in cell), 'H13': any(c.get('negative_red') == 'Y' for c in cell) or any(d.get('negative_red') == 'Y' for d in dyn),
        'D5': any(c.get('cell_type') not in ('', 'TEXT') for c in cell) or bool(dyn), 'K4': any(re.search(r'Button$', m) for m in meths),
        'A6': bool(sorts), 'A1': bool(eps), 'H2': bool(cell) or bool(locks), 'E2': any(c.get('cell_type') in ('DATE', 'DATETIME') for c in cell),
        # 2026-10-30 신설 검사기 근거 — K5 표준 밖 셀 타입 · D2 동적 컬럼×행 조건 잠금 · B5 콤보 필터 원천(combo_src filters) · K6/C5 시트 2개 이상(grid_columns_asis sheet 수)
        'K5': any((c.get('cell_type') or '') not in ('', 'TEXT', 'COMBO', 'NUMBER', 'DATE', 'DATETIME', 'CHECK', 'NUMBER_TEXT', 'FPTextBox', 'FPDateText') for c in cell),
        'D2': bool(dyn) and any(l.get('scope') == 'ROW_COND' for l in locks),
        'B5': any((c.get('filters') or '').strip() for c in rd(os.path.join(sd, 'combo_src.csv'))),
        'K6': len({g.get('sheet') for g in rd(os.path.join(sd, 'grid_columns_asis.csv')) if g.get('sheet')}) >= 2,
        'C5': len({g.get('sheet') for g in rd(os.path.join(sd, 'grid_columns_asis.csv')) if g.get('sheet')}) >= 2,
    }
    return table.get(rule)


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('menu_id'); ap.add_argument('--asis', default=''); a = ap.parse_args()
    mid = a.menu_id.upper()
    asis = a.asis.upper() if a.asis else next((m['asis_id'].upper() for m in rd(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'map_screen.csv')) if m.get('tobe_id', '').upper() == mid), mid)
    sd = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', asis)
    led = rd(os.path.join(ROOT, 'Doc', 'verify', mid, 'verify_ledger.csv'))
    defs = [d for d in rd(os.path.join(HERE, 'mapping_checkdefs.csv')) if d.get('impl') == 'Y']
    out = []; suspects = []
    for d in defs:
        rid = d['check']
        rows = [r for r in led if r['rule_id'] == rid and r['source'] not in ('GENERAL', 'DEFECT', 'CONFIRMED')]
        if not rows: continue
        meas = [r for r in rows if r['result'] in ('PASS', 'FAIL') and RX_MEASURED.match(r.get('tobe_ref') or '') and not RX_INHERITED.match(r.get('evidence') or '')]
        inh = [r for r in rows if r['result'] in ('PASS', 'FAIL') and r not in meas]
        nr = [r for r in rows if r['result'] in ('NOT_RUN', 'ERROR', '')]
        na = [r for r in rows if r['result'] == 'NA']; rev = [r for r in rows if r['result'] == '판정필요']
        na_pct = round(100.0 * len(na) / len(rows), 1) if rows else 0.0
        reasons = {}
        for r in na + nr:
            key = re.sub(r'[\[\]]', '', (r.get('evidence') or '')[:28]).strip() or '(사유 없음)'
            reasons[key] = reasons.get(key, 0) + 1
        fp = feature_present(rid, sd)
        # 근거 있는 미측정(다른 FAIL 에 명시 연결된 차단 · TO-BE 설계로 대상 없음 · 데이터/컨트롤 조건)만으로 이뤄진 규칙은 SUSPECT 가 아니다(2026-10-30 SCP0111 E1/E3)
        by_id = {r['row_id']: r for r in led}
        def benign(r):
            ev = r.get('evidence') or ''
            if ev.startswith('[편집 불가로 미측정]'):
                return any(by_id.get(m, {}).get('result') == 'FAIL' for m in re.findall(r'\b([VT]-[0-9a-f]{8})\b', ev))
            # 2026-11-05 T56: '편집 가능한 행 없음(입력 경로 없음)' · 'Division 기본 순회 — …(표시는 A5·편집은 D1 행에서 판정)' 도 근거 있는 미측정
            return bool(re.search(r'Insert 버튼 없음|전부 비울 수 없는 컨트롤|음수 값 표본 없음|현재 그리드에 없음|음수 불가 컬럼|그리드 \d+개 — 상단·하단|^행 집계 —|^진입점 집계|^검사 대상 아님 — 이 화면에 \S+ 를 적용할 요소|편집 가능한 행 없음|^Division 기본 순회 —', ev))
        suspect = bool(fp) and not meas and not inh and len(rows) > 0 and (len(na) + len(nr)) == len(rows) and not all(benign(r) for r in na + nr)
        if suspect: suspects.append(rid)
        out.append({'rule_id': rid, 'rows': len(rows), 'measured': len(meas), 'inherited': len(inh), 'not_run_error': len(nr), 'review': len(rev), 'na': len(na), 'na_pct': na_pct,
                    'feature_present': '' if fp is None else ('Y' if fp else 'N'), 'suspect_na100': 'Y' if suspect else '',
                    'na_reasons': ' | '.join(f'{k}×{v}' for k, v in sorted(reasons.items(), key=lambda kv: -kv[1])[:4])})
    od = os.path.join(ROOT, 'Doc', 'verify', mid); os.makedirs(od, exist_ok=True)
    p = os.path.join(od, 'coverage.csv')
    with open(p, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['rule_id', 'rows', 'measured', 'inherited', 'not_run_error', 'review', 'na', 'na_pct', 'feature_present', 'suspect_na100', 'na_reasons']); w.writeheader(); w.writerows(out)
    json.dump({'menu_id': mid, 'rules': out, 'suspect_na100': suspects}, open(os.path.join(od, 'coverage.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    tot_m = sum(o['measured'] for o in out); tot_r = sum(o['rows'] for o in out)
    print(f"{mid}: 규칙 {len(out)}개 · 요소 행 {tot_r} · 측정 {tot_m} · 미실행/ERROR {sum(o['not_run_error'] for o in out)} · NA {sum(o['na'] for o in out)} → {os.path.relpath(p, ROOT)}")
    if suspects:
        print('  ⚠ SUSPECT_NA100(AS-IS 에 기능이 있는데 측정 0): ' + ', '.join(suspects) + ' — 검사기가 대상을 만들지 못했거나 측정 경로가 없음(T15)')
        return 2
    return 0


if __name__ == '__main__':
    sys.exit(main())
