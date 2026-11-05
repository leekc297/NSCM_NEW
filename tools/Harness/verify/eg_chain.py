# -*- coding: utf-8 -*-
"""엔진 갭 전용 검사기 실행(2026-11-01) — 팝업(eg_popup)·Division·권한(eg_auth). run_verify 가 화면 잠금을 쥔 채로 부른다(--tier all|slow)

  python tools/Harness/verify/eg_chain.py <MENU_ID> [--asis <AS-IS ID>]
  결과 = Doc/verify/<ID>/eg/popup · Doc/verify/<ID>/eg/auth → eg_ingest.py 가 원장·판정으로 반입
  두 검사기 모두 VERIFY_NO_SAVE=1 — 저장 요청은 서버로 가지 않는다. 실패해도 나머지 체인은 계속(행 없음 = 미측정으로 보임)
"""
import argparse, json, os, shutil, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..')); E2E = os.path.join(ROOT, 'tools', 'E2E')
TIMEOUT_S = 2400  # 측정 실측: DMF0005 eg_auth 17.4분(10-31 r5) · 넘으면 그 검사기만 끊고 ERROR 없이 행 없음으로 남긴다


def run(cmd, env=None, cwd=ROOT, timeout=None):
    try:
        return subprocess.run(cmd, env=env, cwd=cwd, timeout=timeout).returncode
    except subprocess.TimeoutExpired:
        print(f'[eg_chain] 시간 제한 {timeout}s 초과: {" ".join(cmd[:6])}', flush=True)
        return 124


def fresh(path):
    # 지난 결과가 이번 판정에 섞이지 않게 — 폴더 안 결과 파일만 비운다
    os.makedirs(path, exist_ok=True)
    for n in ('popup_results.json', 'popup_rowsets.json', 'popup_source.csv', 'popup_accounts.csv', 'e2e.json', 'eg_combos.json', 'eg_combo_judge.json', 'results.json'):
        p = os.path.join(path, n)
        if os.path.exists(p):
            os.remove(p)


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('menu'); ap.add_argument('--asis', default=''); a = ap.parse_args()
    mid = a.menu.upper(); asis = (a.asis or mid).upper(); py = sys.executable; cli = os.path.join('node_modules', '@playwright', 'test', 'cli.js')
    base = dict(os.environ, VERIFY_ID=mid, VERIFY_NO_SAVE='1', CL_SELFTEST_BASE='1')
    # 팝업
    pd = os.path.join(ROOT, 'Doc', 'verify', mid, 'eg', 'popup'); fresh(pd)
    run([py, '-I', os.path.join(HERE, 'facts_popup.py'), asis]); run([py, '-I', os.path.join(HERE, 'facts_popup_meta.py'), mid])
    rc_p = run(['node', cli, 'test', 'eg_popup', '--workers', '1', '--retries', '0', '--reporter=list,json'], cwd=E2E, timeout=TIMEOUT_S,
               env=dict(base, EG_META='1', CL_RESULTS=os.path.join(pd, 'e2e.json'), E2E_RESULTS=pd, PLAYWRIGHT_JSON_OUTPUT_NAME=os.path.join(pd, 'results.json')))
    if os.path.exists(os.path.join(pd, 'popup_rowsets.json')):
        run([py, '-I', os.path.join(HERE, 'facts_popup_golden.py'), pd, mid])
    # Division·권한
    ad = os.path.join(ROOT, 'Doc', 'verify', mid, 'eg', 'auth'); fresh(ad)
    run([py, '-I', os.path.join(HERE, 'facts_auth.py'), mid])
    rc_a = run(['node', cli, 'test', 'eg_auth', '--workers', '1', '--retries', '0', '--reporter=list,json'], cwd=E2E, timeout=TIMEOUT_S,
               env=dict(base, CL_RESULTS=os.path.join(ad, 'e2e.json'), E2E_RESULTS=ad, PLAYWRIGHT_JSON_OUTPUT_NAME=os.path.join(ad, 'results.json')))
    if os.path.exists(os.path.join(ad, 'eg_combos.json')):
        run([py, '-I', os.path.join(HERE, 'facts_auth_combo.py'), mid, ad])
    print(f'[eg_chain] {mid} 팝업 rc={rc_p} · 권한 rc={rc_a}', flush=True)
    return 0


if __name__ == '__main__':
    sys.exit(main())
