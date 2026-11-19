# -*- coding: utf-8 -*-
"""3개 문서가 지목한 메뉴 전체에 정합검증 실행(2026-10-31) — 문서 행 많은 메뉴부터 · 동시 상한 3(BE 풀 · 메모리 기록)

  정리 정의(cleanup_spec.json)가 없는 메뉴 = VERIFY_NO_SAVE=1(사내 DB 미기록 · 저장 규칙은 ERROR '[저장 미실행]')
  python tools/Harness/verify/run_docs_batch.py [--only A,B] [--skip A,B] [--workers 3]
  결과 = Doc/verify/_batch_docs.csv(메뉴·시작·끝·rc·no_save·로그) — 진행율 보고는 이 파일과 doc_proof.py 만 인용한다
"""
import argparse, collections, csv, datetime, json, os, subprocess, sys, threading
from concurrent.futures import ThreadPoolExecutor
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
OUT = os.path.join(ROOT, 'Doc', 'verify', '_batch_docs.csv'); LOGD = os.path.join(ROOT, 'Doc', 'verify', '_batch_logs')
lock = threading.Lock()


def rd(f):
    with open(f, encoding='utf-8-sig') as fh:
        return list(csv.DictReader(fh))


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--only', default=''); ap.add_argument('--skip', default=''); ap.add_argument('--workers', type=int, default=3); ap.add_argument('--tier', choices=['all', 'fast', 'slow'], default='fast'); a = ap.parse_args()
    cnt = collections.Counter(r['menu_id'] for r in rd(os.path.join(ROOT, 'Doc', 'verify', '_doc_proof_rows.csv')))
    smap = {m['tobe_id'].upper(): m for m in rd(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'map_screen.csv'))}
    only = {x.strip().upper() for x in a.only.split(',') if x.strip()}; skip = {x.strip().upper() for x in a.skip.split(',') if x.strip()}
    todo = [m for m, _ in cnt.most_common() if m and (m in smap or os.path.isdir(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', m))) and (not only or m in only) and m not in skip]
    not_runnable = [m for m in cnt if m not in todo and m not in skip and not only]
    os.makedirs(LOGD, exist_ok=True)
    print(f'대상 {len(todo)}메뉴: {" ".join(todo)}')
    print(f'실행 불가(map_screen·asisfacts 없음) {len(not_runnable)}: {" ".join(not_runnable)} — 문서 행 {sum(cnt[m] for m in not_runnable)}', flush=True)
    if not os.path.exists(OUT):
        with open(OUT, 'w', encoding='utf-8-sig', newline='') as f:
            csv.writer(f).writerow(['menu_id', 'doc_rows', 'start', 'end', 'rc', 'no_save', 'log'])

    def one(m):
        ns = m not in json.load(open(os.path.join(HERE, 'cleanup_spec.json'), encoding='utf-8')); log = os.path.join(LOGD, f'{m}.log'); t0 = datetime.datetime.now()
        env = dict(os.environ); env.pop('VERIFY_NO_SAVE', None)
        if ns:
            env['VERIFY_NO_SAVE'] = '1'
        with open(log, 'w', encoding='utf-8') as lf:
            rc = subprocess.run([sys.executable, '-I', os.path.join(HERE, 'run_verify.py'), m, '--tier', a.tier], cwd=ROOT, env=env, stdout=lf, stderr=subprocess.STDOUT).returncode
        t1 = datetime.datetime.now()
        if not ns:  # 실저장 메뉴 — 잔존 변경 실측(save_residue.py)
            with open(log, 'a', encoding='utf-8') as lf:
                rr = subprocess.run([sys.executable, '-I', os.path.join(HERE, 'save_residue.py'), m, '--since', f'{t0:%Y-%m-%d %H:%M:%S}'], cwd=ROOT, stdout=lf, stderr=subprocess.STDOUT).returncode
                lf.write(f'RESIDUE_RC={rr}\n')
        with lock:
            with open(OUT, 'a', encoding='utf-8-sig', newline='') as f:
                csv.writer(f).writerow([m, cnt[m], f'{t0:%m-%d %H:%M}', f'{t1:%m-%d %H:%M}', rc, 'Y' if ns else 'N', os.path.relpath(log, ROOT)])
            print(f'{t1:%H:%M} {m} rc={rc} no_save={ns}', flush=True)
    with ThreadPoolExecutor(max_workers=a.workers) as ex:
        list(ex.map(one, todo))
    print('BATCH_DONE', flush=True)


if __name__ == '__main__':
    main()
