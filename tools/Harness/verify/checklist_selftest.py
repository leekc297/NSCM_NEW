"""CheckList 자기검증(변이 시험) — 검사기가 오류를 실제로 잡는지 화면마다 기계적으로 증명 (2026-10-28)

사용자 요청(10-28): 다른 화면도 CheckList 를 돌릴 예정인데 할 때마다 누락 여부를 사람이 확인할 수 없다 →
  '현재 기준으로 누락 없이 CheckList 를 뽑아낸다'는 확신이 들 때까지 기능 보완. 그 확신의 근거 = 이 자기검증.

방법: 화면 소스는 건드리지 않고(CheckList 는 소스 무수정), E2E 실행 중 브라우저 안에서만 오류를 주입(tools/E2E/lib/mutate.ts, CL_MUTATE)한다.
  주입한 요소의 해당 규칙 행이
    공식 결과(Doc/verify/<ID>/e2e_results.json)에서 PASS 였는데 변이 실행에서 FAIL → '검출 증명'
    변이 실행에서도 PASS                                                   → '미검출'(검사기 결함 — 그 규칙의 PASS 는 믿을 수 없음)
    변이 실행에서 측정되지 않음                                             → '미측정'(시험 경로가 그 요소를 안 거침)
  공식 결과·원장은 바꾸지 않는다(결과 = Doc/verify/<ID>/selftest/).

  python tools/Harness/verify/checklist_selftest.py <MENU_ID> [--kinds A5,H5,D1,H3,G1] [--compare-only]
"""
import argparse, csv, datetime, json, os, re, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
E2E = os.path.join(ROOT, 'tools', 'E2E')
KINDS = ['A5', 'H5', 'D1', 'H3', 'G1', 'G5', 'C2']
# 종류 → 그 규칙을 판정하는 테스트(제목 일부) — CRUD 실저장 테스트는 넣지 않는다
TESTS = {'A5': ['그리드 컬럼 프로브', 'W5 컬럼 대상 검사'], 'H5': ['W5 컬럼 대상 검사'], 'D1': ['그리드 컬럼 프로브', 'W5 컬럼 대상 검사'],
         'H3': ['W4b H3'], 'G1': ['W4c 정밀 판정'], 'G5': ['그리드 더블클릭 팝업 인자'], 'C2': ['W5 컬럼 대상 검사', 'W4c 정밀 판정']}


def read_csv(p):
    with open(p, encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))


def load(p, default):
    try:
        return json.load(open(p, encoding='utf-8'))
    except (OSError, ValueError):
        return default


def run_mutated(mid, kinds, od, mutate=True):
    """mutate=False = 같은 코드·같은 시험을 변이 없이(기준선 e2e_base.json) — 검사기를 고친 직후 공식 결과와 코드가 달라 비교가 틀어지는 것 방지"""
    res = os.path.join(od, 'e2e_mutated.json' if mutate else 'e2e_base.json'); mlog = os.path.join(od, 'mutation_log.json' if mutate else 'mutation_log_base.json')
    for f in (res, mlog):
        if os.path.exists(f):
            os.remove(f)
    grep = '|'.join(sorted({re.escape(t) for k in kinds for t in TESTS[k]}))
    lock = subprocess.run(['node', 'runlock.js', 'acquire', 'verify', mid], cwd=E2E, capture_output=True, text=True, encoding='utf-8')
    if lock.returncode:
        print(lock.stderr.strip() or lock.stdout.strip())
        return 4
    try:
        env = dict(os.environ, VERIFY_ID=mid, CL_MUTATE=','.join(kinds) if mutate else '', CL_RESULTS=res, CL_MUTLOG=mlog)
        if not mutate:
            env['CL_SELFTEST_BASE'] = '1'
        cmd = ['node', os.path.join('node_modules', '@playwright', 'test', 'cli.js'), 'test', '_verify', '_trace', '--grep', grep, '--workers', '1', '--reporter=list']
        print('$', ' '.join(cmd), f'(CL_MUTATE={",".join(kinds) if mutate else "없음 — 기준선"})', flush=True)
        return subprocess.call(cmd, cwd=E2E, env=env)
    finally:
        subprocess.run(['node', 'runlock.js', 'release', 'verify', mid], cwd=E2E, capture_output=True)


def binding_of(target):
    m = re.search(r'\.([A-Z][A-Z0-9_]+)', target or '') or re.match(r'^([A-Z][A-Z0-9_]+)$', target or '')
    return m.group(1) if m else ''


def compare(mid, kinds, od):
    led = read_csv(os.path.join(ROOT, 'Doc', 'verify', mid, 'verify_ledger.csv'))
    bp = os.path.join(od, 'e2e_base.json')  # 같은 코드의 변이 없는 실행(있으면 우선) — 없으면 공식 결과
    base = {e['row_id']: e for e in load(bp if os.path.exists(bp) else os.path.join(ROOT, 'Doc', 'verify', mid, 'e2e_results.json'), [])}
    mut = {e['row_id']: e for e in load(os.path.join(od, 'e2e_mutated.json'), [])}
    mlog = load(os.path.join(od, 'mutation_log.json'), [])
    report = []
    for k in kinds:
        inj = [m for m in mlog if m['kind'] == k]
        if not inj:
            report.append({'kind': k, 'target': '-', 'verdict': '미주입', 'why': '주입 대상 없음(그리드·요청이 해당 시험 경로에 없음)', 'rows': []})
            continue
        for m in inj:
            b = m['target']
            rows = [r for r in led if r['rule_id'] == k and (b == '*' or k in ('G1', 'G5') or binding_of(r['target']) == b or b in (r['target'] or ''))
                    and r['source'] not in ('DEFECT', 'GENERAL', 'CONFIRMED')]
            seen = [r for r in rows if r['row_id'] in mut]
            hit = [r for r in seen if mut[r['row_id']]['result'] == 'FAIL' and base.get(r['row_id'], {}).get('result') != 'FAIL']
            stay = [r for r in seen if mut[r['row_id']]['result'] == 'PASS']
            # 표면화 = 공식 PASS 가 변이 후 판정필요·ERROR — 조용히 통과하지 않고 사람 확인 목록(판정 필요 시트)에 올라옴(2026-10-28)
            surf = [r for r in seen if mut[r['row_id']]['result'] in ('판정필요', 'ERROR') and base.get(r['row_id'], {}).get('result') == 'PASS']
            if hit:
                v, why = '검출 증명', f"{len(hit)}행 PASS→FAIL: " + ' | '.join(f"[{r['row_id']}] {mut[r['row_id']]['evidence'][:120]}" for r in hit[:3])
            elif surf and not stay:
                v, why = '표면화(판정필요)', f"{len(surf)}행 PASS→판정필요/ERROR(조용한 통과 없음 · FAIL 로 단정은 못 함): " + ' | '.join(f"[{r['row_id']}] {mut[r['row_id']]['evidence'][:120]}" for r in surf[:3])
            elif not seen:
                v, why = '미측정', f'해당 규칙 행 {len(rows)}개가 변이 실행에서 판정되지 않음'
            else:
                v, why = '미검출', f"주입했는데 {len(stay)}행 PASS 유지(검사기 결함): " + ' | '.join(f"[{r['row_id']}] {mut[r['row_id']]['evidence'][:120]}" for r in stay[:3])
            report.append({'kind': k, 'target': b, 'detail': m.get('detail', ''), 'verdict': v, 'why': why[:900],
                           'rows': [r['row_id'] for r in seen]})
    out = {'menu_id': mid, 'generated': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), 'kinds': kinds, 'report': report}
    json.dump(out, open(os.path.join(od, 'checklist_selftest.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    L = [f'# {mid} CheckList 자기검증(변이 시험) — {out["generated"]}', '', '| 규칙 | 주입 대상 | 주입 | 결과 | 근거 |', '|---|---|---|---|---|']
    L += [f"| {r['kind']} | {r['target']} | {r.get('detail', '')} | **{r['verdict']}** | {r['why'][:200].replace('|', '/')} |" for r in report]
    open(os.path.join(od, 'checklist_selftest.md'), 'w', encoding='utf-8').write('\n'.join(L) + '\n')
    for r in report:
        print(f"[{r['verdict']}] {r['kind']} {r['target']} — {r['why'][:220]}")
    return 0 if all(r['verdict'] in ('검출 증명', '표면화(판정필요)') for r in report) else 1


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id')
    ap.add_argument('--kinds', default=','.join(KINDS))
    ap.add_argument('--compare-only', action='store_true')
    ap.add_argument('--no-base', action='store_true', help='기준선(변이 없는 같은 시험) 생략 — 공식 결과와 비교')
    a = ap.parse_args()
    mid = a.menu_id.upper()
    kinds = [k.strip().upper() for k in a.kinds.split(',') if k.strip().upper() in TESTS]
    od = os.path.join(ROOT, 'Doc', 'verify', mid, 'selftest')
    os.makedirs(od, exist_ok=True)
    if not a.compare_only:
        if not a.no_base:
            if run_mutated(mid, kinds, od, mutate=False) == 4:
                return 4
        rc = run_mutated(mid, kinds, od)
        if rc == 4:
            return 4
    return compare(mid, kinds, od)


if __name__ == '__main__':
    sys.exit(main())
