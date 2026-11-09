# -*- coding: utf-8 -*-
"""규칙 → 오라클 분류 마스터(2026-11-06 사용자 원칙: AS-IS 직접 비교가 1순위 정답 · 룰은 AS-IS 로 비교할 수 없는 항목만)

  python tools/Harness/verify/oracle_class.py --init          # 규칙 ID 를 코드로 전수 수집 → Doc/verify/_oracle_class.csv (기존 값 보존 · 새 ID 만 추가)
  python tools/Harness/verify/oracle_class.py --check [<ID>…] # 원장에 있는데 마스터에 없는 규칙 ID → 목록 + exit 2 (run_verify GATE_WARN)
  python tools/Harness/verify/oracle_class.py                 # 현황 출력

oracle_class: ASIS(AS-IS 실행 결과·원문과 직접 비교) / RULE(TO-BE 룰·설계 결정·공용 계약만) / RUNTIME(실저장·팝업·검증 메시지·권한 등 실행 결과) / HOLD(미분류 · 사유)
초기값은 손으로 정하지 않는다 — detect_rules.csv 의 oracle 열(O1 AS-IS 동작 / O2 확정 규칙 / O3 기능 무결성)에서 기계적으로:
  O3 포함 → RUNTIME · O1 포함(O3 없음) → ASIS · O2 만 → RULE · detect_rules 에 없음 → HOLD('미분류(detect_rules 없음)')
수집 원천(누락 금지 · 손 목록 금지): ① detect_rules.csv rule_id ② mapping_checkdefs.csv check ③ Doc/verify/*/verify_ledger.csv rule_id ④ _engine_gap.csv rule_id
  ⑤ defects_classified.csv rule_ids ⑥ confirmed_requirements.csv rule_id·rule_ids ⑦ design_decisions.csv·check_maturity.csv·common_contract.csv rule_ids ⑧ tools/Harness/check.js 정적 검사 ID 리터럴(LB1|LB2|MS1|SC1|SC2)
"""
import csv, datetime, glob, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
MASTER = P('Doc', 'verify', '_oracle_class.csv')
COLS = ['rule_id', 'oracle_class', 'asis_source', 'compare_method', 'hold_reason', 'origin', 'classified_by', 'classified_at']
CLASSES = ('ASIS', 'RULE', 'RUNTIME', 'HOLD')
csv.field_size_limit(10 ** 8)


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def split_rules(s):
    return [x for x in re.split(r'[;,\s]+', (s or '').strip()) if x]


def collect():
    """규칙 ID → 출처 집합. 모든 원천을 코드로 훑는다(손 목록 없음)."""
    org = {}
    def add(rid, src):
        rid = (rid or '').strip()
        if not rid:
            return
        org.setdefault(rid, set()).add(src)
    for r in rd(os.path.join(HERE, 'detect_rules.csv')):
        add(r.get('rule_id'), 'detect_rules')
    for r in rd(os.path.join(HERE, 'mapping_checkdefs.csv')):
        add(r.get('check'), 'mapping_checkdefs')
    for f in sorted(glob.glob(P('Doc', 'verify', '*', 'verify_ledger.csv'))):
        m = os.path.basename(os.path.dirname(f))
        for r in rd(f):
            add(r.get('rule_id'), f'ledger:{m}')
    for r in rd(P('Doc', 'verify', '_engine_gap.csv')):
        add(r.get('rule_id'), 'engine_gap')
    for r in rd(P('Doc', 'verify', 'defects_classified.csv')):
        for x in split_rules(r.get('rule_ids')):
            add(x, 'defects_classified')
    for r in rd(P('tools', 'Harness', 'rules', 'confirmed_requirements.csv')):
        add(r.get('rule_id'), 'confirmed_requirements')
        for x in split_rules(r.get('rule_ids')):
            add(x, 'confirmed_requirements')
    for name in ('design_decisions.csv', 'check_maturity.csv', 'common_contract.csv'):
        for r in rd(P('tools', 'Harness', 'rules', name)):
            for x in split_rules(r.get('rule_ids')):
                add(x, name.replace('.csv', ''))
    cj = P('tools', 'Harness', 'check.js')
    if os.path.exists(cj):
        with open(cj, encoding='utf-8', errors='replace') as f:
            for x in set(re.findall(r'\b(LB1|LB2|MS1|SC1|SC2)\b', f.read())):
                add(x, 'check.js')
    return org


def initial_class(rid, det):
    """detect_rules.csv oracle 열 → 초기 분류(기계적). 반환 (class, asis_source, hold_reason, by)"""
    d = det.get(rid)
    if not d:
        return 'HOLD', '', '미분류(detect_rules 없음 — 사람/AI 가 사유와 함께 분류)', ''
    o = (d.get('oracle') or '').upper()
    src = (d.get('expected_source') or '').strip()
    by = f"detect_rules.csv oracle='{o}' (자동 초기값)"
    if 'O3' in o:
        return 'RUNTIME', src, '', by
    if 'O1' in o:
        return 'ASIS', src, '', by
    if 'O2' in o:
        return 'RULE', src, '', by
    return 'HOLD', src, f"미분류(detect_rules oracle '{o}' 해석 불가)", by


def load():
    """ledger.py 가 쓴다: rule_id → oracle_class (마스터 없으면 빈 dict → 전행 HOLD)"""
    return {r['rule_id']: (r.get('oracle_class') or 'HOLD') for r in rd(MASTER)}


def write(rows):
    os.makedirs(os.path.dirname(MASTER), exist_ok=True)
    tmp = MASTER + f'.{os.getpid()}.tmp'
    with open(tmp, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS)
        w.writeheader()
        for r in sorted(rows, key=lambda x: x['rule_id']):
            w.writerow({k: r.get(k, '') for k in COLS})
    os.replace(tmp, MASTER)


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    org = collect()
    det = {r['rule_id']: r for r in rd(os.path.join(HERE, 'detect_rules.csv'))}
    cur = {r['rule_id']: r for r in rd(MASTER)}
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M')
    if '--init' in sys.argv:
        added = []
        for rid, srcs in org.items():
            o = ';'.join(sorted(srcs, key=lambda s: (s.startswith('ledger:'), s)))
            if rid in cur:
                cur[rid]['origin'] = o  # 출처는 매번 갱신(분류값은 보존)
                continue
            c, src, hold, by = initial_class(rid, det)
            cur[rid] = {'rule_id': rid, 'oracle_class': c, 'asis_source': src, 'compare_method': '', 'hold_reason': hold, 'origin': o, 'classified_by': by, 'classified_at': now}
            added.append(rid)
        write(list(cur.values()))
        cnt = {c: sum(1 for r in cur.values() if r['oracle_class'] == c) for c in CLASSES}
        print(f"[oracle_class] 규칙 ID 수집 {len(org)}개 (원천: " + ', '.join(f"{s.split(':')[0]}" for s in sorted({x.split(':')[0] for v in org.values() for x in v})) + ')')
        print(f"  마스터 {len(cur)}행 → {os.path.relpath(MASTER, ROOT)} · 신규 {len(added)} · 분류 " + ' · '.join(f'{k} {v}' for k, v in cnt.items()))
        if added:
            print('  신규(초기값): ' + ', '.join(f"{r}={cur[r]['oracle_class']}" for r in sorted(added)))
        hold = [r for r in cur.values() if r['oracle_class'] == 'HOLD']
        if hold:
            print(f"  HOLD {len(hold)}개(사유 필수): " + ', '.join(f"{r['rule_id']}[{r['hold_reason'][:24]}]" for r in sorted(hold, key=lambda x: x['rule_id'])))
        return 0
    if '--check' in sys.argv:
        mids = [a.upper() for a in args]
        files = [P('Doc', 'verify', m, 'verify_ledger.csv') for m in mids] if mids else sorted(glob.glob(P('Doc', 'verify', '*', 'verify_ledger.csv')))
        miss = {}
        for f in files:
            for r in rd(f):
                rid = (r.get('rule_id') or '').strip()
                if rid and rid not in cur:
                    miss.setdefault(rid, set()).add(os.path.basename(os.path.dirname(f)))
        bad = [r for r in cur.values() if r['oracle_class'] not in CLASSES or (r['oracle_class'] == 'HOLD' and not r.get('hold_reason'))]
        if miss or bad:
            if miss:
                print(f"[oracle_class] 마스터에 없는 규칙 ID {len(miss)}개: " + ', '.join(f"{k}({','.join(sorted(v))[:40]})" for k, v in sorted(miss.items())) + ' → --init 으로 추가')
            if bad:
                print(f"[oracle_class] 분류값 오류·HOLD 사유 없음 {len(bad)}개: " + ', '.join(r['rule_id'] for r in bad))
            return 2
        print(f"[oracle_class] 검사 통과 — 마스터 {len(cur)}행 · 원장 {len(files)}개 규칙 ID 전부 등재")
        return 0
    cnt = {c: sum(1 for r in cur.values() if r['oracle_class'] == c) for c in CLASSES}
    print(f"[oracle_class] 마스터 {len(cur)}행 · " + ' · '.join(f'{k} {v}' for k, v in cnt.items()) + f" · 수집 가능 ID {len(org)}개 (--init 으로 동기화)")
    return 0


if __name__ == '__main__':
    sys.exit(main())
