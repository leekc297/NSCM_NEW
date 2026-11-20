# -*- coding: utf-8 -*-
"""VM 🔎 CheckList 체인의 1단계·3단계 실행기 (2026-11-18 사용자 지시)
   "1 단계 - CHECKLIST 수행, 2단계 - 검증 보완, 3단계 - CHECKLIST 재수행" · "미검증 항목에 대해서만 별도 CHECK 가능하면 가장 좋고, 그게 아니면 처음부터 수행"

  python tools/Harness/verify/checklist_run.py <MENU_ID>            1단계: CheckList 전체(run_verify.py) → 미검증 분류(unverified_resolve.py --no-rerun)
  python tools/Harness/verify/checklist_run.py <MENU_ID> --recheck  3단계: 미검증 행만 다시 잴 수 있으면 그 규칙만(run_verify --only), 아니면 전체 → 재분류

  미검증 행만 재측정하는 조건(모두 만족):
    - 처리 대상 행(분류 담당 엔진·대조표·판단·자동 · Doc/verify/<ID>/unverified_triage.csv)이 1행 이상
    - 그 행들이 --only 가 다시 돌리는 E2E 시험(@verify·@trace·@snap)으로 판정되는 행: 차등 검증(source ASIS_DIFF)·팝업 권한 검사기(EG-)·E2E 4종(ES-) 행이 없음
      (--only 는 eg·diff 단계와 E2E 4종을 건너뛴다 · run_verify.py --only 설명)
    - run_verify --only 가 시험을 찾음(종료코드 3 = 이 규칙 시험 없음 → 전체로 다시)
  종료코드 = run_verify 종료코드(0 정상 · 10 검사기 게이트 경고) · 분류 실패는 무시(결과 파일 없음은 체인 검증이 잡는다)
"""
import argparse, csv, json, os, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
csv.field_size_limit(10 ** 8)
WORK = ('엔진', '대조표', '판단', '자동')


def run(args):
    print('$ ' + ' '.join(args[1:]), flush=True)
    return subprocess.call([sys.executable] + args[1:] if args[0] == 'py' else args, cwd=ROOT)


def recheck_rules(mid):
    """(규칙 목록, 사유) — 규칙 목록이 비면 전체 실행"""
    p = os.path.join(ROOT, 'Doc', 'verify', mid, 'unverified_triage.csv')
    if not os.path.exists(p):
        return [], '미검증 분류 결과 없음'
    rows = [r for r in csv.DictReader(open(p, encoding='utf-8-sig')) if r.get('actor') in WORK]
    if not rows:
        return [], '처리 대상 0행'
    blk = [r for r in rows if r.get('source') == 'ASIS_DIFF' or (r.get('row_id') or '').startswith(('EG-', 'ES-'))]
    if blk:
        kinds = sorted({'차등 검증' if r.get('source') == 'ASIS_DIFF' else ('팝업·권한 검사기' if r['row_id'].startswith('EG-') else 'E2E 4종') for r in blk})
        return [], f"처리 대상 {len(rows)}행 중 {len(blk)}행이 --only 로 다시 잴 수 없는 단계({', '.join(kinds)})"
    rules = sorted({(r.get('rule_id') or '').upper() for r in rows if r.get('rule_id')})
    return rules, f'처리 대상 {len(rows)}행 · 규칙 {len(rules)}개'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id')
    ap.add_argument('--recheck', action='store_true')
    a = ap.parse_args()
    mid = a.menu_id.upper()
    rv = os.path.join(HERE, 'run_verify.py'); ur = os.path.join(HERE, 'unverified_resolve.py')
    rc = None
    # 2026-11-19 사용자: 한 단계 안에서 이어지는 작업은 하위 단계로 보이게 — '[작업 k/K] 이름' 줄(VM Flow 카드가 하위 단계 목록으로 그림)
    jobs = 2
    if a.recheck:
        rules, why = recheck_rules(mid)
        if rules:
            print(f'[INFO] CheckList 재수행 = 미검증 행만 — {why}: {",".join(rules)}', flush=True)
            print(f'[작업 1/{jobs}] CheckList 재측정(미검증 규칙만 --only)', flush=True)
            rc = run(['py', rv, mid, '--only', ','.join(rules)])
            if rc == 3:
                print('[INFO] --only 로 잴 시험이 없는 규칙이 있음(rc 3) → 처음부터 전체 수행', flush=True)
                rc = None; jobs = 3
        else:
            print(f'[INFO] CheckList 재수행 = 처음부터 전체 — {why}', flush=True)
    if rc is None:
        print(f'[작업 {jobs - 1}/{jobs}] CheckList 전체(run_verify)', flush=True)
        rc = run(['py', rv, mid])
    print(f'[작업 {jobs}/{jobs}] 미검증 분류(unverified_resolve)', flush=True)
    run(['py', ur, mid, '--no-rerun'])
    try:
        j = json.load(open(os.path.join(ROOT, 'Doc', 'verify', mid, 'unverified_triage.json'), encoding='utf-8'))
        print(f"[{'OK' if not j.get('actionable') else 'INFO'}] 미검증 {j['after']['total']}행 · 처리 대상 {j.get('actionable')} · 사람 확인 {j.get('human')} · 보완 대기 {j['after'].get('blocked', 0)} · 집계 {j['after'].get('aggregate')}", flush=True)
    except (OSError, ValueError, KeyError):
        pass
    return rc


if __name__ == '__main__':
    sys.exit(main())
