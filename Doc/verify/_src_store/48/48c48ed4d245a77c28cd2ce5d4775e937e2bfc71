# -*- coding: utf-8 -*-
"""검사엔진 존재 전수 조사(2026-10-31) — impl=Y 표시를 믿지 않고 규칙마다 코드에서 확인한다

  대상 생성(gen): ledger.py / mapping_checks.csv 가 규칙의 판정 행을 만드는가(GENERAL·DEFECT·CONFIRMED 상속 행 제외)
  측정 코드(meas): _verify·_trace·smoke·static 검사기·judge 에 그 규칙을 판정하는 코드가 있는가
  판정 문구(put): 측정 코드가 PASS/FAIL 을 낼 수 있는가(put·add 등) — 탐지는 문자열 패턴이라 '없음' 은 사람이 확인한다
  python tools/Harness/verify/engine_audit.py → Doc/verify/_engine_audit.csv · 콘솔
"""
import collections, csv, glob, os, re
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))


def rd(f):
    with open(f, encoding='utf-8-sig') as fh:
        return list(csv.DictReader(fh))


def txt(p):
    try:
        return open(p, encoding='utf-8', errors='replace').read()
    except OSError:
        return ''


def main():
    defs = rd(os.path.join(HERE, 'mapping_checkdefs.csv'))
    refs = collections.Counter()
    for r in rd(os.path.join(ROOT, 'Doc', 'verify', 'defects_classified.csv')):
        if r['status'] in ('DEFECT', '', 'REQ', 'OPEN'):
            for x in re.split(r'[;,\s]+', r['rule_ids'].strip()):
                if x:
                    refs[x] += 1
    ledger = txt(os.path.join(HERE, 'ledger.py')); checks = rd(os.path.join(HERE, 'mapping_checks.csv'))
    check_rules = collections.Counter()
    for c in checks:
        for v in c.values():
            for x in re.findall(r'(?<![A-Za-z0-9_])([A-Z]{1,3}-?[A-Z]*\d{0,2})(?![A-Za-z0-9_])', v or ''):
                check_rules[x] += 1
    spec = {n: txt(os.path.join(ROOT, 'Doc', 'e2e', 'specs', n)) for n in ('_verify.spec.ts', '_trace.spec.ts')}
    lib = {os.path.basename(p): txt(p) for p in glob.glob(os.path.join(ROOT, 'tools', 'E2E', 'lib', '*.ts'))}
    py = {os.path.basename(p): txt(p) for p in glob.glob(os.path.join(HERE, '*.py')) if os.path.basename(p) not in ('engine_audit.py', 'doc_proof.py', 'coverage.py', 'ledger.py', 'gen_cleanup_spec.py')}
    out = []
    for d in defs:
        x = d['check']; q = re.escape(x)
        gen = []
        if re.search(rf"add\(\s*'[A-Z_]+'\s*,\s*'{q}'", ledger): gen.append('ledger.add')
        if re.search(rf"'{q}'", ledger) and not gen: gen.append('ledger.list')
        if check_rules.get(x): gen.append('mapping_checks')
        meas = []
        rx = re.compile(rf"(?:rule_id === '{q}'|pick\('{q}'\)|trc\('{q}'\)|byRule\([^)]*'{q}'|fRows\('{q}'\)|\['{q}'|, '{q}'[,\]]|\"{q}\")")
        for n, t in spec.items():
            if rx.search(t): meas.append(n.split('.')[0])
        for n, t in lib.items():
            if re.search(rf"\b{q}\b", t) and n in ('smoke-extra.ts', 'mutate.ts'): meas.append(n)
        for n, t in py.items():
            if re.search(rf"'{q}'", t): meas.append(n)
        verdict = 'OK' if gen and meas else '대상 생성 없음' if meas else '측정 코드 없음' if gen else '둘 다 없음'
        out.append({'rule_id': x, 'doc_rows': refs.get(x, 0), 'verdict': verdict, 'gen': ';'.join(gen), 'meas': ';'.join(meas), 'runner': d.get('runner', ''), 'how': (d.get('how') or '')[:90], 'checker_claim': (d.get('checker') or '')[:90]})
    for x in refs:
        if x not in {d['check'] for d in defs}:
            out.append({'rule_id': x, 'doc_rows': refs[x], 'verdict': '규칙 정의 없음', 'gen': '', 'meas': '', 'runner': '', 'how': '', 'checker_claim': ''})
    with open(os.path.join(ROOT, 'Doc', 'verify', '_engine_audit.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(out[0].keys())); w.writeheader(); w.writerows(out)
    c = collections.Counter(o['verdict'] for o in out); print(dict(c), '규칙', len(out))
    for o in sorted(out, key=lambda o: -int(o['doc_rows'])):
        if o['verdict'] != 'OK' or 'judge.py' == o['meas']:
            print(o['rule_id'], '문서', o['doc_rows'], o['verdict'], 'gen=' + o['gen'], 'meas=' + o['meas'], '|', o['how'])
    print('--- 측정 코드 위치가 judge 뿐인 규칙은 상속만 하는지 사람이 확인')


if __name__ == '__main__':
    main()
