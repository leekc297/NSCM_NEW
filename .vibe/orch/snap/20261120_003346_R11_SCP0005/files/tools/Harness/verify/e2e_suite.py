# -*- coding: utf-8 -*-
"""CheckList 안에서 E2E 테스트 4종 실행 (2026-11-18 사용자 지시)
   "CheckList 생성 시 테스트의 모든 단계까지를 테스트하고 CheckList 을 생성 · 테스트 4단계가 CheckList 에 포함"

  python tools/Harness/verify/e2e_suite.py <MENU_ID> [--kinds crud,auth,authcrud] [--force]

  smoke 는 사전 작업(prereq.py)이 이미 돌린다. 이 도구는 나머지 crud, auth, authcrud 를 같은 방식으로 돌린다.
    - 실행기 = tools/E2E/run-e2e.cmd <종류> <ID> --mode <모드> (화면별 잠금 · 화면 폴더 결과)
    - 다시 실행하는 조건 = 그 종류 결과가 없음 · 화면 FE 소스나 그 종류 스펙·공용 라이브러리가 결과보다 새로움 · --force
    - 모드 = tools/E2E/users.json screens[<ID>].mode 가 있으면 그것, 없으면 admin
      (사용자 지시 2026-10-27: 검증 기본 = 계정 1개 · 권한×Division 은 사용자가 지정한 화면만)
    - 저장이 일어나는 종류(crud · authcrud)는 환경변수 VERIFY_NO_SAVE=1 이면 실행하지 않는다(SCP0111 ADMIN 실저장 금지 등)
    - 잠금(rc 4)이면 30초 간격으로 최대 60분 기다린다
  결과 = Doc/verify/<ID>/e2e_suite.json  {kind: {ran, rc, rows, pass, at, reason, mode}}
  판정 반입 = e2e_suite_ingest.py (원장 ES- 행)
  종료코드 0 = 끝까지 진행(일부 종류 실패여도 0 · 실패는 결과 파일과 원장 미검증 행으로 남음)
"""
import argparse, datetime, glob, json, os, subprocess, sys, time

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
E2E = os.path.join(ROOT, 'tools', 'E2E')
SAVE_KINDS = {'crud', 'authcrud'}
WAIT_MAX = 3600


def mtime(p):
    return os.path.getmtime(p) if os.path.exists(p) else 0


def mode_of(mid):
    try:
        u = json.load(open(os.path.join(E2E, 'users.json'), encoding='utf-8'))
        m = ((u.get('screens') or {}).get(mid) or {}).get('mode')
        if m in ('admin', 'division', 'auto'):
            return m, 'users.json screens'
    except Exception:
        pass
    return 'admin', '기본(계정 1개 · 사용자 지시 2026-10-27)'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id')
    ap.add_argument('--kinds', default='crud,auth,authcrud')
    ap.add_argument('--force', action='store_true')
    a = ap.parse_args()
    mid = a.menu_id.upper()
    import e2e_paths
    from prereq import page_dir, newest
    vd = os.path.join(ROOT, 'Doc', 'verify', mid); os.makedirs(vd, exist_ok=True)
    out_p = os.path.join(vd, 'e2e_suite.json')
    try:
        out = json.load(open(out_p, encoding='utf-8'))
    except Exception:
        out = {}
    mode, mode_src = mode_of(mid)
    pdir = page_dir(mid)
    fe_at = newest(pdir) if pdir else 0
    lib_at = max((mtime(f) for f in glob.glob(os.path.join(E2E, 'lib', '*.ts'))), default=0)
    no_save = os.environ.get('VERIFY_NO_SAVE') == '1'
    for kind in [k.strip() for k in a.kinds.split(',') if k.strip()]:
        spec = os.path.join(ROOT, 'Doc', 'e2e', 'specs', f'{mid}.{kind}.spec.ts')
        rec = {'mode': mode, 'mode_src': mode_src, 'at': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
        if not os.path.exists(spec):
            rec.update(ran=False, rc=None, reason=f'스펙 없음(Doc/e2e/specs/{mid}.{kind}.spec.ts), gen-e2e.js 로 생성 필요'); out[kind] = rec
            print(f'[ERROR] {kind}: 스펙 없음, 미검증', flush=True); continue
        if kind in SAVE_KINDS and no_save:
            rec.update(ran=False, rc=None, reason='VERIFY_NO_SAVE=1, 실저장 금지 설정이라 실행 안 함'); out[kind] = rec
            print(f'[ERROR] {kind}: VERIFY_NO_SAVE=1, 실행 안 함(미검증)', flush=True); continue
        last = e2e_paths.summary_rows(mid, kind)
        last_at = max((mtime(f) for f in e2e_paths.run_logs(mid, kind)), default=0)
        stale = (not last) or last_at < fe_at or last_at < mtime(spec) or last_at < lib_at
        if not stale and not a.force:
            prev = out.get(kind) or {}
            rec.update(ran=False, rc=prev.get('rc'), rows=len(last), passed=sum(1 for r in last if (r.get('status') or '').upper() == 'PASS'),
                       reason=f"최신 결과 재사용(마지막 실행 {datetime.datetime.fromtimestamp(last_at).strftime('%m-%d %H:%M')} · FE 소스·스펙·공용 라이브러리보다 새로움)")
            out[kind] = rec; print(f'[OK] {kind}: {rec["reason"]} · {rec["rows"]}건', flush=True); continue
        waited = 0; t0 = time.time()
        while True:
            print(f'\n$ run-e2e.cmd {kind} {mid} --mode {mode}', flush=True)
            rc = subprocess.call(['cmd', '/c', os.path.join(E2E, 'run-e2e.cmd'), kind, mid, '--mode', mode], cwd=E2E)
            if rc != 4 or waited >= WAIT_MAX:
                break
            if waited == 0:
                print(f'[WAIT] 같은 화면({mid}) 또는 공용 E2E 실행 중, 30초 간격 · 최대 {WAIT_MAX // 60}분', flush=True)
            time.sleep(30); waited += 30
        rows = e2e_paths.summary_rows(mid, kind)
        rec.update(ran=rc in (0, 1), rc=rc, rows=len(rows), passed=sum(1 for r in rows if (r.get('status') or '').upper() == 'PASS'), sec=round(time.time() - t0, 1),
                   reason={0: '실행 · 전부 PASS', 1: '실행 · FAIL 포함(판정 반입)', 3: '결과 파일이 이번 실행보다 오래됨(실행 증빙 없음)', 4: '다른 E2E 실행 중(잠금 대기 초과)', 5: 'FE/BE 미기동'}.get(rc, f'실행 실패 rc={rc}'))
        out[kind] = rec
        print(f"[{'OK' if rc in (0, 1) else 'ERROR'}] {kind}: {rec['reason']} · {rec['rows']}건 · {rec['sec']}s", flush=True)
    json.dump(out, open(out_p, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(f'[e2e_suite] {mid}: ' + ' · '.join(f"{k} {v.get('reason', '')}" for k, v in out.items()) + f' → {os.path.relpath(out_p, ROOT)}', flush=True)
    return 0


if __name__ == '__main__':
    sys.exit(main())
