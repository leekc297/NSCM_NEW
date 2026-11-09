# -*- coding: utf-8 -*-
"""차등 검증 결과(Doc/verify/<ID>/diff/diff_summary.csv) → 원장 행(source=ASIS_DIFF · row_id AD-…) + e2e_results.json 반입(2026-11-06 플랜 2-4)
  python tools/Harness/verify/diff_ingest.py <ID>
규칙 매핑은 tools/Harness/rules/diff_rule_map.csv (코드에 규칙 ID 를 적지 않는다): diff_item(KEYSET/VALUES/COLSET/ORDER) → rule_id · verdict_map(diff 판정 → 원장 결과)
판정은 judge.py 가 한다 — 여기서는 eg_ingest.py 와 같이 원장 행 + e2e_results 항목만 만든다(evidence 에 3-증거: 기대 원천 ASIS:<sp> · 증거 경로 diff/*.md · 전제 = 호출 인자).
"""
import csv, hashlib, json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
csv.field_size_limit(10 ** 8)


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def rid(mid, *parts):
    return 'AD-' + hashlib.md5('|'.join([mid] + [str(x) for x in parts]).encode('utf-8')).hexdigest()[:8]


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    if not args:
        print(__doc__); return 2
    mid = args[0].upper(); vd = P('Doc', 'verify', mid)
    summ = rd(os.path.join(vd, 'diff', 'diff_summary.csv'))
    rmap = rd(P('tools', 'Harness', 'rules', 'diff_rule_map.csv'))
    lp = os.path.join(vd, 'verify_ledger.csv')
    if not os.path.exists(lp):
        print(f'[diff_ingest] {mid}: 원장 없음'); return 2
    with open(lp, encoding='utf-8-sig', newline='') as f:
        r_ = csv.DictReader(f); fields = r_.fieldnames; rows = [r for r in r_ if not r['row_id'].startswith('AD-')]
    out = []
    for s in summ:
        if not s.get('asis_sp') and s.get('verdict') == 'SKIP' and not s.get('tobe_proc'):
            continue  # 배선·포착 자체가 없는 호출은 원장 행을 만들지 않는다(미검증 사유는 diff_summary 에 남음)
        sp, proc, v = s.get('asis_sp') or '(짝 없음)', s.get('tobe_proc') or '', s.get('verdict') or 'ERR'
        base_ev = (f"[차등 검증 #{s.get('call_no')}] {s.get('sheet')}/{s.get('btn')} AS-IS {sp} ↔ TO-BE {proc} · 판정 {v} · {s.get('note', '')} · 키({s.get('key_source', '')}) {s.get('keys', '')} · "
                   f"AS-IS {s.get('asis_rows', '')}행 ↔ TO-BE {s.get('tobe_rows', '')}행 · 공통 {s.get('common', '')} · 단독 AS-IS {s.get('asis_only', '')} / TO-BE {s.get('tobe_only', '')} · 불일치 셀 {s.get('diff_cells', '')} · 순서 {s.get('order', '')}"
                   f" · 전제: AS-IS 인자 {s.get('params_asis', '')[:300]}{(' · 재시도 ' + s['retry']) if s.get('retry') else ''} · 증거 {s.get('md', '')}")
        for m in rmap:
            vm = dict(x.split('=', 1) for x in (m.get('verdict_map') or '').split(';') if '=' in x)
            item = m['diff_item']
            res = vm.get(v)
            if item == 'KEYSET' and v == 'PASS' and (str(s.get('asis_only') or '0') not in ('', '0') or str(s.get('tobe_only') or '0') not in ('', '0')):
                res = vm.get('ASIS_ONLY', '판정필요')  # 사용자 결정 2026-11-06: 건수(단독행) 차이 = 판정필요
            if item == 'ORDER' and v == 'PASS':
                res = vm.get(s.get('order') or 'NA', 'NA')
            if item == 'COLSET' and v in ('PASS', 'DIFF', 'ROWS_ONLY') and (s.get('cols_only_a') or s.get('cols_only_t')):
                res = vm.get('COLS', '판정필요')
            if not res:
                res = 'ERROR'
            tgt = (m.get('target_tpl') or '{sp}').format(sp=sp, common=s.get('common', ''), asis_only=s.get('asis_only', ''), tobe_only=s.get('tobe_only', ''), diff_cells=s.get('diff_cells', ''),
                                                        cols_only_a=s.get('cols_only_a', ''), cols_only_t=s.get('cols_only_t', ''))
            r = {k: '' for k in fields}
            r.update({'row_id': rid(mid, item, proc, s.get('call_no')), 'source': 'ASIS_DIFF', 'family': m['rule_id'][:1], 'rule_id': m['rule_id'], 'axis': '2', 'area': '차등 검증',
                      'target': f"{mid} {tgt}", 'condition': f"호출 #{s.get('call_no')} {s.get('sheet')}/{s.get('btn')} 인자: {s.get('params_tobe', '')[:200]}", 'oracle': 'O1',
                      'expected': m.get('expected', ''), 'asis_ref': f"AS-IS SP {sp} 실행 결과(golden 차등 · {m.get('basis', '')})", 'method': 'DB', 'result': 'NOT_RUN',
                      'note': f"diff_item={item}"})
            if 'oracle_class' in fields: r['oracle_class'] = 'ASIS'
            if 'expect_src' in fields: r['expect_src'] = f"ASIS:{sp}"
            if 'evidence_ref' in fields: r['evidence_ref'] = s.get('md', '')
            if 'precond' in fields: r['precond'] = json.dumps({'calls': 1, 'rows': s.get('tobe_rows') or 0, 'asis_rows': s.get('asis_rows') or 0, 'params': (s.get('params_tobe') or '')[:300]}, ensure_ascii=False)
            if 'applicable' in fields: r['applicable'] = 'Y'; r['applicable_why'] = '차등 검증 실행 행'
            rows.append(r)
            out.append({'row_id': r['row_id'], 'result': res, 'evidence': (f"[{item}] " + base_ev)[:1500], 'tobe_ref': f"DB @diff {item}",
                        'mctx': {'calls': 1, 'rows': int(s.get('tobe_rows') or 0) if str(s.get('tobe_rows') or '').isdigit() else 0, 'req': 0},
                        'expect_src': f"ASIS:{sp}", 'evidence_ref': s.get('md', ''), 'precond': {'params': (s.get('params_tobe') or '')[:300]}})
    with open(lp, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=fields); w.writeheader(); w.writerows(rows)
    ej = os.path.join(vd, 'e2e_results.json')
    try:
        with open(ej, encoding='utf-8') as f: prev = json.load(f)
    except (OSError, ValueError):
        prev = []
    keep = [e for e in prev if not str(e.get('row_id', '')).startswith('AD-')]
    with open(ej, 'w', encoding='utf-8') as f:
        json.dump(keep + out, f, ensure_ascii=False, indent=1)
    cnt = {}
    for o in out: cnt[o['result']] = cnt.get(o['result'], 0) + 1
    print(f"[diff_ingest] {mid}: diff 요약 {len(summ)}행 → 원장 ASIS_DIFF {len(out)}행(" + ' · '.join(f'{k} {v}' for k, v in sorted(cnt.items())) + f") · e2e_results 반입 {len(out)} (judge.py 가 판정)")
    return 0


if __name__ == '__main__':
    sys.exit(main())
