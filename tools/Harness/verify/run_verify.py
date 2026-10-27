"""화면 정합검증 한 번에 실행 — Vibe_Manager '🔎 화면 정합검증' 이 부르는 진입점

  python tools/Harness/verify/run_verify.py <MENU_ID> [--asis <AS-IS ID>] [--skip-e2e] [--scope DB_ONLY|DB_FE]

순서 (실패 단계에서 멈추고 exit≠0 — 미실행을 완료로 보고하지 않는다):
  1 AS-IS 사실 보강   facts_cellrules.py · facts_lockrules.py · facts_combosrc.py · facts_sortrules.py(정렬: SQL ORDER BY / 그리드·코드) → Doc/asisfacts/screens/<AS-IS>/cell_rules.csv · lock_rules.csv · edit_expect.csv · combo_src.csv
  2 검증 항목 원장     ledger.py                                 → Doc/verify/<ID>/verify_ledger.csv
  3 동적 판정(E2E)    Playwright Doc/e2e/specs/_verify.spec.ts @verify (VERIFY_ID=<ID>) → Doc/verify/<ID>/e2e_results.json
                      FE(5173)/BE(8080) 미기동이면 exit 5 · 다른 E2E 실행 중이면 exit 4 (tools/E2E/runlock.js 공용 잠금)
  4 판정              judge.py (E2E 반입 · META I1 · STATIC H5/G4 · 결함 원장 상속)
  2b 대조표 추적      syn_check.py · mapping_trace.py --to-ledger(대조표 전 행 × 검사 카탈로그 → 원장 TRACE 행)
  3' 검증 엔진(E2E)   Doc/e2e/specs/_trace.spec.ts @trace — TRACE 행 중 엔진 구현 검사(A10·X-REOPEN·K4·G6·C1·C4·D6)
  4' 추적·구현 엔진   mapping_trace.py(재계산) · impl_engine.py → work_ledger.md(작업 원장 — PASS·NA 외 전부 할 일 W1~W9)
  5 문서              make_verify_docs.py → 정합검증서 + 보완대상목록 xlsx (보완 적용은 하지 않는다 — 목록 확인 후 🛠️/🧯/🩹)
"""
import argparse
import csv
import json
import os
import subprocess
import sys
import urllib.request

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
HERE = os.path.dirname(os.path.abspath(__file__))
E2E = os.path.join(ROOT, 'tools', 'E2E')


def run(cmd, env=None, cwd=None):
    print(f"\n$ {' '.join(cmd)}", flush=True)
    return subprocess.call(cmd, cwd=cwd or ROOT, env=env)


def asis_of(mid):
    p = os.path.join(ROOT, 'tools', 'Harness', 'rules', 'map_screen.csv')
    if os.path.exists(p):
        with open(p, encoding='utf-8-sig') as f:
            for r in csv.DictReader(f):
                if r.get('tobe_id', '').upper() == mid:
                    return r['asis_id'].upper()
    return mid


def reachable(url):
    try:
        urllib.request.urlopen(url, timeout=5)
        return True
    except urllib.error.HTTPError:
        return True  # 401 등 = 응답함(기동됨)
    except OSError:
        return False


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id')
    ap.add_argument('--asis', default='')
    ap.add_argument('--skip-e2e', action='store_true')
    ap.add_argument('--scope', choices=['DB_ONLY', 'DB_FE'])
    a = ap.parse_args()
    mid = a.menu_id.upper()
    asis = (a.asis or asis_of(mid)).upper()
    py = sys.executable
    print(f'== 화면 정합검증 {mid} (AS-IS {asis}) ==')

    if not os.path.isdir(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', asis)):
        print(f'[FAIL] AS-IS Fact Pack 없음: Doc/asisfacts/screens/{asis} — 🔬 AS-IS 파싱 먼저')
        return 6
    for s in ('facts_cellrules.py', 'facts_lockrules.py', 'facts_combosrc.py', 'facts_sortrules.py', 'facts_gridcols.py'):
        if run([py, os.path.join(HERE, s), asis]):
            return 6
    if run([py, os.path.join(HERE, 'ledger.py'), mid, '--asis', asis]):
        return 6
    # 2026-10-26 사용자 지시 — 대조표 전 행이 검증 대상(오류 수정 아님, 검증의 빈틈 0 이 목적)
    #   syn_check: BE 계정(SCMP_APP)이 부르는 PKG·콤보 SQL 객체의 시노님/권한(Doc/verify/<ID>/syn_check.csv)
    #   mapping_trace --to-ledger: 대조표 행 × 검사 카탈로그 → 원장 연결 없는 검사 인스턴스를 source=TRACE 행으로 편입(정적 검사 결과 포함)
    #     → 아래 E2E 에서 검증 엔진(_trace.spec.ts @trace)이 실행 · judge 가 반입
    run([py, os.path.join(HERE, 'syn_check.py'), mid])
    run([py, os.path.join(HERE, 'sort_check.py'), mid, '--asis', asis])  # A6 결과 정렬 — AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY(ALL_SOURCE 새로 조회)
    run([py, os.path.join(HERE, 'align_check.py'), mid])  # H1 가로 정렬 — AS-IS 정렬 ↔ TO-BE 메타 HORIZONTAL_ALIGN_CODE (2026-10-27)
    run([py, os.path.join(ROOT, 'tools', 'DbConn', 'golden.py'), mid])  # A1 건수·A7 컬럼별 값 — AS-IS SP ↔ TO-BE PROC 같은 인자 동시 실행(GET 만, 2026-10-27 체인 편입)
    run([py, os.path.join(HERE, 'b7_check.py'), mid, '--asis', asis])  # B7(a) 저장 대상 ∩ 콤보 원천 — E2E B7 테스트가 결과를 싣는다(2026-10-28)
    if run([py, os.path.join(HERE, 'mapping_trace.py'), mid, '--asis', asis, '--to-ledger']):
        return 9

    if not a.skip_e2e:
        with open(os.path.join(E2E, 'e2e.config.json'), encoding='utf-8-sig') as f:
            cfg = json.load(f)
        if not (reachable(cfg['feUrl']) and reachable(cfg['beUrl'])):
            print(f"[FAIL] FE({cfg['feUrl']}) 또는 BE({cfg['beUrl']}) 미응답 — 서버 기동 후 다시 실행(☕ BE Start / 🎨 FE Start). E2E 판정 없이 문서를 만들려면 --skip-e2e")
            return 5
        lock = subprocess.run(['node', 'runlock.js', 'acquire', 'verify', mid], cwd=E2E, capture_output=True, text=True, encoding='utf-8')
        if lock.returncode:
            print(lock.stderr.strip())
            return 4
        try:
            out_dir = os.path.join(ROOT, 'Doc', 'verify', mid)
            res_json = os.path.join(out_dir, 'e2e_results.json')
            if os.path.exists(res_json):
                os.replace(res_json, res_json + '.prev')  # 이전 실행 결과가 이번 판정에 섞이지 않게
            env = dict(os.environ, VERIFY_ID=mid, E2E_RESULTS=os.path.join(out_dir, 'e2e'),
                       PLAYWRIGHT_JSON_OUTPUT_NAME=os.path.join(out_dir, 'e2e', 'results.json'))
            rc = run(['node', os.path.join('node_modules', '@playwright', 'test', 'cli.js'), 'test', '_verify', '_trace', '--grep', '@verify|@trace', '--workers', '1',
                      '--reporter=list,json'], env=env, cwd=E2E)
            if not os.path.exists(res_json):
                print(f'[FAIL] E2E 결과 파일 없음({res_json}) — Playwright 가 판정 없이 끝남(rc={rc}). 로그 확인')
                return 3
            print(f'E2E 종료 rc={rc} (테스트 실패는 판정 결과로 원장에 반영된다)')
        finally:
            subprocess.run(['node', 'runlock.js', 'release'], cwd=E2E, capture_output=True)
    else:
        print('\n[INFO] --skip-e2e — E2E 판정 행은 미검증(NOT_RUN)으로 남는다')

    # W1 콤보 AS-IS 원천 비교 — E2E 덤프(combo_runtime.json)가 있으면 AS-IS DB 에서 원천을 실행해 B4·B3 판정 근거를 만든다(실패해도 다음 단계 진행 = 판정필요로 남음)
    if os.path.exists(os.path.join(ROOT, 'Doc', 'verify', mid, 'combo_runtime.json')):
        run([py, os.path.join(HERE, 'combo_oracle.py'), mid, '--asis', asis])
    # CRUD 실제 저장 마커 행 정리(사내 DB) — 백업·건수 단언·SQL 기록. 정의 없는 화면은 SKIP(2026-10-24 BOD 잔존 행 사고 재발 방지)
    if not a.skip_e2e:
        run([py, os.path.join(HERE, 'cleanup_marker.py'), mid])
    # F8 감사 필드 · F7 저장 연계 테이블 — 정리 백업(실제 저장이 남긴 행) ↔ AS-IS 저장 SP DML 대상 (2026-10-27)
    run([py, os.path.join(HERE, 'save_audit.py'), mid])
    if run([py, os.path.join(HERE, 'judge.py'), mid]):
        return 7
    # 판정 반입 후 추적표 재계산 + 원장 TRACE 행(행·진입점 집계·정적 판정) 갱신 → 다시 반입(2026-10-27: E2E 전에 만든 집계 행이 낡은 채 남아 판정필요로 보이던 결함)
    if run([py, os.path.join(HERE, 'mapping_trace.py'), mid, '--asis', asis, '--to-ledger']):
        return 9
    if run([py, os.path.join(HERE, 'judge.py'), mid]):
        return 7
    if run([py, os.path.join(HERE, 'mapping_trace.py'), mid, '--asis', asis]):
        return 9
    run([py, os.path.join(HERE, 'impl_engine.py'), mid])
    cmd = [py, os.path.join(HERE, 'make_verify_docs.py'), mid] + (['--scope', a.scope] if a.scope else [])
    if run(cmd):
        return 8
    print('\n다음: 보완대상목록 xlsx 를 확인한 뒤 보완 범위(🧭 보완 범위 설정)를 정하고 🛠️/🧯 로 보완을 적용한다.')
    return 0


STEP_OF_RC = {2: '인자', 3: 'E2E 판정(결과 파일 없음)', 4: 'E2E 잠금(다른 E2E 실행 중)', 5: 'E2E 서버 미기동', 6: 'AS-IS 사실 보강·원장', 7: '판정(judge)', 8: '문서 생성', 9: '대조표 추적'}


def write_envelope(rc):
    """결과 봉투 Doc/verify/<ID>/run_verify.result.json (vibe-result/1, 2026-10-26) — 실패 단계도 기록(미실행을 완료로 보고하지 않음).
    verdict: FAIL 있으면 fail · 판정필요·미검증 남으면 hold · 전부 PASS/해당없음이면 pass. 근거 등급은 make_verify_docs 와 같은 규칙."""
    args = [x for x in sys.argv[1:] if not x.startswith('--')]
    if not args:
        return
    mid = args[0].upper()
    out = os.path.join(ROOT, 'Doc', 'verify', mid, 'run_verify.result.json')
    sys.path.insert(0, HERE)
    import envelope
    skip = '--skip-e2e' in sys.argv
    base = {'producer': 'run_verify', 'id': mid, 'skip_e2e': skip}
    if rc != 0:
        envelope.write(out, dict(base, state='error' if rc in (2, 3, 4, 5) else 'failed', verdict=None, why=f"exit {rc} — 멈춘 단계: {STEP_OF_RC.get(rc, '?')}",
                                 evidence=[{'kind': 'exec', 'ref': 'tools/Harness/verify/run_verify.py'}]))
        return
    import make_verify_docs as mvd
    rows = mvd.read_csv(os.path.join(ROOT, 'Doc', 'verify', mid, 'verify_ledger.csv'))
    cnt, gcnt, demoted, fails = {}, {}, 0, []
    for r in rows:
        r['_grade'] = mvd.evidence_grade(r)
        eff = mvd.effective_result(r)
        demoted += eff != r['result']
        cnt[eff] = cnt.get(eff, 0) + 1
        gcnt[r['_grade']] = gcnt.get(r['_grade'], 0) + 1
        if eff == 'FAIL':
            fails.append({'id': r['row_id'], 'class': r['rule_id'], 'msg': f"{r['target']}"[:200], 'evidence': [{'kind': 'exec' if r['_grade'] in mvd.GRADE_HARD else 'agent-judgment', 'ref': r.get('tobe_ref') or r['_grade']}]})
    unv = cnt.get('NOT_RUN', 0) + cnt.get('ERROR', 0) + cnt.get('', 0); pend = cnt.get('판정필요', 0) + cnt.get('WARN', 0)
    docs = {}
    for kind in ('정합검증서', '보완대상'):
        import glob
        fs = sorted(glob.glob(os.path.join(ROOT, 'Doc', '화면분석서', f'{mid}_*_{kind}_v*.xlsx')), key=os.path.getmtime)
        if fs:
            docs[kind] = os.path.relpath(fs[-1], ROOT).replace('\\', '/')
    verdict = 'fail' if cnt.get('FAIL', 0) else ('hold' if unv or pend else 'pass')
    ev = [{'kind': 'exec', 'ref': 'tools/Harness/verify/run_verify.py'}] + ([{'kind': 'test', 'ref': f'Doc/verify/{mid}/e2e_results.json'}] if not skip else [])
    envelope.write(out, dict(base, state='completed', verdict=verdict, issues=fails[:300],
                             summary={'rows': len(rows), 'PASS': cnt.get('PASS', 0), 'FAIL': cnt.get('FAIL', 0), '판정필요': pend, '미검증': unv, '해당없음': cnt.get('NA', 0),
                                      'AI판단만_강등': demoted, 'grade': gcnt, 'fail_listed': min(len(fails), 300)},
                             docs=docs, evidence=ev, note='E2E 미실행(--skip-e2e) — E2E 행은 이전 결과 또는 미검증' if skip else ''))
    print(f"결과 봉투: {os.path.relpath(out, ROOT)} — verdict {verdict} · FAIL {cnt.get('FAIL', 0)} · 판정필요 {pend} · 미검증 {unv}" + (f' · AI 판단만 강등 {demoted}' if demoted else ''))


if __name__ == '__main__':
    rc = main()
    try:
        write_envelope(rc)
    except Exception as e:  # 봉투 기록 실패가 본 작업 결과를 바꾸지 않게 — 단, 알린다
        print(f'[WARN] 결과 봉투 기록 실패: {e}')
    sys.exit(rc)
