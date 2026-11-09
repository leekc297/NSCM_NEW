"""화면 정합검증 한 번에 실행 — Vibe_Manager '🔎 화면 정합검증' 이 부르는 진입점

  python tools/Harness/verify/run_verify.py <MENU_ID> [--asis <AS-IS ID>] [--skip-e2e] [--scope DB_ONLY|DB_FE]
  python tools/Harness/verify/run_verify.py <MENU_ID> --resume-docs   # 판정(judge)·추적까지 끝나고 문서 생성(exit 8)에서 멈춘 실행을 문서 단계부터 재개(E2E 재실행 없음)

순서 (실패 단계에서 멈추고 exit≠0 — 미실행을 완료로 보고하지 않는다):
  0 사전 작업         prereq.py — DB 접속 · AS-IS Fact Pack(pack.ps1) · TO-BE 메타(export_tobe_meta.py) · TO-BE 인덱스(TobeFacts run.ps1)
                      · 골든 케이스(gen_golden_cases.py) · E2E plan(gen.js, 적용 없음)·스펙(gen-e2e.js)·smoke(run-e2e.cmd) 를 없거나 오래되면 선수행
                      · FE 대조표·조회조건 기준표 = MANUAL(자동 생성 금지) → Doc/verify/<ID>/prereq.json · 실행 로그(정합검증서에는 넣지 않음 — 사용자 10-28)
  1 AS-IS 사실 보강   facts_cellrules.py · facts_lockrules.py · facts_combosrc.py · facts_sortrules.py(정렬: SQL ORDER BY / 그리드·코드) → Doc/asisfacts/screens/<AS-IS>/cell_rules.csv · lock_rules.csv · edit_expect.csv · combo_src.csv
  1b 자동 기대 행     gen_expect.py(2026-11-04 W8-2) · 데이터 전제 프로필 scenario_env.py(2026-11-05 W8-5)            → Doc/verify/<ID>/auto_expect/ (원장·E2E 는 기본 손 행 ∪ 자동 행 · 2026-11-05 기본 켜짐 · VERIFY_AUTO=0 이면 손 행만)
  2 검증 항목 원장     ledger.py                                 → Doc/verify/<ID>/verify_ledger.csv
  3 동적 판정(E2E)    Playwright Doc/e2e/specs/_verify.spec.ts @verify (VERIFY_ID=<ID>) → Doc/verify/<ID>/e2e_results.json
                      FE(5173)/BE(8080) 미기동이면 exit 5(최대 2분 재시도 뒤) · 같은 화면 E2E 실행 중이면 대기 · 동시 E2E 는 verifyMaxConcurrent(기본 3) 슬롯까지(tools/E2E/runlock.js)
  4 판정              judge.py (E2E 반입 · META I1 · STATIC H5/G4 · 결함 원장 상속)
  2b 대조표 추적      syn_check.py · mapping_trace.py --to-ledger(대조표 전 행 × 검사 카탈로그 → 원장 TRACE 행)
  3' 검증 엔진(E2E)   Doc/e2e/specs/_trace.spec.ts @trace — TRACE 행 중 엔진 구현 검사(A10·X-REOPEN·K4·G6·C1·C4·D6)
  4' 추적·구현 엔진   mapping_trace.py(재계산) · impl_engine.py → work_ledger.md(작업 원장 — PASS·NA 외 전부 할 일 W1~W9)
  5 문서              make_verify_docs.py → 정합검증서 + 보완대상목록 xlsx (보완 적용은 하지 않는다 — 목록 확인 후 🛠️/🧯/🩹)
"""
import argparse
import time
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


def reachable(url, tries=12, wait=5):
    """FE/BE 응답 확인 — 2026-10-29: 5초 단발 점검은 BE 기동 직후·동시 실행 5개 부하에서 떠 있는 서버를 '미기동' 으로 오판했다(SCP0041 exit 5 21:19:46,
    같은 서버를 5초 전 SCP0100 은 정상으로 봄). 최대 tries×(5초 타임아웃+wait초) 동안 재시도하고 매 실패를 찍어 어느 쪽이 안 되는지 남긴다."""
    for i in range(1, tries + 1):
        try:
            urllib.request.urlopen(url, timeout=5)
            return True
        except urllib.error.HTTPError:
            return True  # 401 등 = 응답함(기동됨)
        except OSError as e:
            print(f'[WAIT] {url} 응답 없음({i}/{tries}: {e.__class__.__name__}) — {wait}초 뒤 재시도', flush=True)
            if i < tries:
                time.sleep(wait)
    return False


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id')
    ap.add_argument('--asis', default='')
    ap.add_argument('--skip-e2e', action='store_true')
    ap.add_argument('--tier', choices=['all', 'fast', 'slow'], default='all', help='fast = 오래 걸리는 W4c 제외 · slow = W4c 만 실행해 fast 결과에 합침(2026-10-31 사용자: 오래 걸리는 것은 따로)')
    ap.add_argument('--force-e2e', action='store_true', help='시노님·권한 누락(차단)이 있어도 E2E 를 실행')
    ap.add_argument('--scope', choices=['DB_ONLY', 'DB_FE'])
    ap.add_argument('--resume-docs', action='store_true', help='exit 8(문서 생성) 복구 — 원장·판정은 그대로 두고 make_verify_docs → regress 만 다시 실행(2026-10-30 SCP0100)')
    a = ap.parse_args()
    mid = a.menu_id.upper()
    asis = (a.asis or asis_of(mid)).upper()
    py = sys.executable
    print(f'== UI CheckList {mid} (AS-IS {asis}) ==')

    if a.resume_docs:
        # 문서 단계 재개(2026-10-30 SCP0100: K1 증거의 제어문자로 xlsx 쓰기 중단 exit 8 — E2E 57분·판정은 모두 유효). 원장·E2E 결과가 있어야만 허용.
        vdir = os.path.join(ROOT, 'Doc', 'verify', mid)
        for need in ('verify_ledger.csv', 'e2e_results.json'):
            if not os.path.exists(os.path.join(vdir, need)):
                print(f'[FAIL] --resume-docs: Doc/verify/{mid}/{need} 없음 — 처음부터 실행(run_verify.py {mid})')
                return 3
        print('[INFO] --resume-docs — 판정·추적 산출물은 그대로, 문서 생성(make_verify_docs)·회귀 게이트(regress)만 다시 실행')
        cmd = [py, os.path.join(HERE, 'make_verify_docs.py'), mid] + (['--scope', a.scope] if a.scope else [])
        if run(cmd):
            return 8
        rc_reg = run([py, os.path.join(HERE, 'regress.py'), mid, '--harvest'])
        if rc_reg: print('⚠ 검사기 회귀 위반 — Doc/verify/_regress_report.md 확인(검사기 결함 재발 가능성)')
        print('\n다음: ActionItemList xlsx 를 확인한 뒤 보완 범위(🧭 보완 범위 설정)를 정하고 🛠️/🧯 로 보완을 적용한다.')
        return 0

    # 0 사전 작업 점검·선수행(2026-10-28 사용자 요청) — Fact Pack·TO-BE 메타·TO-BE 인덱스·골든 케이스·E2E plan/스펙·smoke 가
    #   없거나 오래되면 생산자를 먼저 실행한다. 대조표·조회조건 기준표처럼 사람이 만드는 것은 MANUAL 로 prereq.json·실행 로그에만 남긴다(정합검증서 미포함)
    rc_pre = run([py, os.path.join(HERE, 'prereq.py'), mid, '--asis', asis] + (['--skip-e2e'] if a.skip_e2e else []))
    if rc_pre:
        # 2026-10-30: E2E plan·스펙·smoke 가 없으면 FAIL(종전엔 MANUAL/ERROR 로 기록만 하고 진행 → SCP0111 smoke 근거 규칙 전부 미측정 · T13). rc 5 = 서버/잠금(환경)
        print(f"[FAIL] 사전 작업 미충족 — Doc/verify/{mid}/prereq.json 확인({'FE/BE 미기동 또는 다른 E2E 실행 중' if rc_pre == 5 else 'AS-IS Fact Pack·TO-BE 화면·E2E plan/스펙/smoke 중 생산 실패'})")
        return 5 if rc_pre == 5 else 6
    # 순서: gridcols(프레임워크 기본값 CSV 기록) → dyncols(기본값 인용) → cellrules/lockrules(동적 패밀리 키 공유) — 2026-10-30 WP1/WP7
    for s in ('facts_gridcols.py', 'facts_dyncols.py', 'facts_cellclear.py', 'facts_cellrules.py', 'facts_lockrules.py', 'facts_combosrc.py', 'facts_combovalues.py', 'facts_sortrules.py'):  # combovalues = AS-IS 원천 후보 값(2026-10-28 C2 분기 후보 대조)
        if run([py, os.path.join(HERE, s), asis]):
            return 6
    # 2026-11-04 W8-2 ②: 자동 기대 행 재생성 — 방금 보강한 AS-IS 사실·TO-BE 메타로 Doc/verify/<ID>/auto_expect/ 를 다시 만든다(손 행 불변).
    #   자동 행은 기본으로 원장·E2E 가 읽는다(2026-11-05 사용자 지시) → 생성 실패 시 낡은 행 측정 방지로 중단 · VERIFY_AUTO=0(끔)이면 경고만.
    if run([py, os.path.join(HERE, 'gen_expect.py'), mid, '--asis', asis]):
        if os.environ.get('VERIFY_AUTO', '1') != '0':
            print('[FAIL] 자동 기대 행 생성 실패(gen_expect.py) — 자동 행 켜짐(기본)이라 낡은 자동 행 측정을 막으려고 중단')
            return 6
        print('[WARN] 자동 기대 행 생성 실패(gen_expect.py) — VERIFY_AUTO=0(자동 행 끔)이라 이번 판정에는 영향 없음')
    # 2026-11-05 W8-5: 데이터 전제 프로필(Doc/verify/<ID>/scenario_env.json) — 시나리오 '조회 0행' ERROR 근거에 전제 요약 첨부용 · 실패해도 판정 영향 없음(근거 문구만 빠짐)
    if run([py, os.path.join(HERE, 'scenario_env.py'), mid]):
        print('[WARN] 데이터 전제 프로필 생성 실패(scenario_env.py) — 0행 ERROR 근거에 전제 요약이 빠진다')
    if run([py, os.path.join(HERE, 'ledger.py'), mid, '--asis', asis]):
        return 6
    # 2026-10-26 사용자 지시 — 대조표 전 행이 검증 대상(오류 수정 아님, 검증의 빈틈 0 이 목적)
    #   syn_check: BE 계정(SCMP_APP)이 부르는 PKG·콤보 SQL 객체의 시노님/권한(Doc/verify/<ID>/syn_check.csv)
    #   mapping_trace --to-ledger: 대조표 행 × 검사 카탈로그 → 원장 연결 없는 검사 인스턴스를 source=TRACE 행으로 편입(정적 검사 결과 포함)
    #     → 아래 E2E 에서 검증 엔진(_trace.spec.ts @trace)이 실행 · judge 가 반입
    run([py, os.path.join(HERE, 'syn_check.py'), mid])
    # 차단 게이트(2026-10-29): 앱 계정이 접근 못 하는 객체(SYN_MISSING·PRIV_MISSING·TARGET_MISSING·INVALID)가 있으면 화면 조회·콤보가 ORA-00942 로 전부 막혀
    #   검증엔진 테스트가 줄줄이 중단되고(SCP0020 17/22 · SCP0111 18/22) 그 결과가 허위 FAIL 수백 건으로 번진다 → E2E 를 생략하고 차단 원인 1건을 조치 필요 1번으로 올린다(--force-e2e 로 강행 가능)
    blockers = []
    try:
        import csv as _csv
        with open(os.path.join(ROOT, 'Doc', 'verify', mid, 'syn_check.csv'), encoding='utf-8-sig') as f:
            blockers = [x for x in _csv.DictReader(f) if x.get('kind') != 'NOTE' and (x.get('verdict') or 'OK') != 'OK']
    except Exception:
        blockers = []
    if blockers:
        # 2026-10-29 사용자: 시노님이 없어 실행이 안 되면 시노님을 추가하고 오류 이력을 남긴다 → syn_fix(SCM_MGR 로 CREATE SYNONYM · 권한 가능하면 GRANT · 이력 _synonym_history.csv) 뒤 재검사
        print(f"\n⚠ 앱 계정 접근 불가 객체 {len(blockers)}건 → 시노님 자동 보완(syn_fix) 실행")
        run([py, os.path.join(HERE, 'syn_fix.py'), mid])
        try:
            with open(os.path.join(ROOT, 'Doc', 'verify', mid, 'syn_check.csv'), encoding='utf-8-sig') as f:
                blockers = [x for x in _csv.DictReader(f) if x.get('kind') != 'NOTE' and (x.get('verdict') or 'OK') != 'OK']
        except Exception:
            pass
        if not blockers:
            print('   → 시노님 보완으로 해소 — E2E 진행(이력: Doc/verify/_synonym_history.csv)')
    # 2026-10-29(사용자 승인): 콤보 SQL 객체(kind=COMBO)만 문제면 메인 조회(DEFINER 패키지)는 정상이므로 E2E 를 진행하고 콤보 의존 검사만 차단 영향으로 — PROC·META 문제만 전면 차단
    hard_blockers = [x for x in blockers if x.get('kind') in ('PROC', 'META')]
    if blockers and not hard_blockers:
        print(f"   → 콤보 SQL 객체 {len(blockers)}건만 문제(메인 조회는 DEFINER 패키지로 정상) — E2E 진행 · 해당 콤보 의존 검사는 '부분 차단' 으로 판정")
    blocked = bool(hard_blockers) and not a.force_e2e
    if blockers:
        print(f"\n⛔ [차단] 앱 계정(SCMP_APP)이 접근할 수 없는 DB 객체 {len(blockers)}건 — " + ' · '.join(f"{x['name']}({x['verdict']}, {x['source']})" for x in blockers[:6]))
        print('   → ' + ('E2E 생략 · CheckList 는 차단 원인 1건(조치 필요)과 미검증(차단)으로 작성 · 시노님 생성 후 재실행' if blocked else '--force-e2e: 차단 상태로 E2E 강행(테스트 중단·허위 FAIL 가능)'))
        if blocked:
            pj = os.path.join(ROOT, 'Doc', 'verify', mid, 'e2e', 'results.json')
            if os.path.exists(pj):
                os.replace(pj, pj + '.prev')  # 이전 실행의 테스트 결과가 이번 차단 판정에 섞이지 않게
            ej = os.path.join(ROOT, 'Doc', 'verify', mid, 'e2e_results.json')
            if os.path.exists(ej):
                os.replace(ej, ej + '.prev')  # 차단된 이전 실행의 E2E 판정도 반입하지 않는다(미실행 = ERROR 로 남김)
    run([py, os.path.join(HERE, 'sort_check.py'), mid, '--asis', asis])  # A6 결과 정렬 — AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY(ALL_SOURCE 새로 조회)
    run([py, os.path.join(HERE, 'align_check.py'), mid, '--asis', asis])  # H1 가로 정렬 — AS-IS 정렬 ↔ TO-BE 메타 HORIZONTAL_ALIGN_CODE (2026-10-27)
    run([py, os.path.join(HERE, 'popup_args_check.py'), mid, '--asis', asis])  # G5 팝업 조건 연동 — AS-IS 팝업 인자 ↔ TO-BE 모달 전달값·조회조건 연동 (2026-10-29)
    run([py, os.path.join(HERE, 'popup_data_check.py'), mid, '--asis', asis])
    run([py, os.path.join(HERE, 'f10_check.py'), mid])  # F10 저장 트랜잭션 원자성 — 저장 PROC+하위 호출 본문 COMMIT/TRUNCATE/DDL(2026-10-30 WP9)  # M3 팝업 목록 — AS-IS 개인화 팝업 ↔ TO-BE 메타 PROC Division 값별 행수(2026-10-30 SCP0100 Measure 0건)
    run([py, os.path.join(ROOT, 'tools', 'DbConn', 'golden.py'), mid])  # A1 건수·A7 컬럼별 값 — AS-IS SP ↔ TO-BE PROC 같은 인자 동시 실행(GET 만, 2026-10-27 체인 편입)
    run([py, os.path.join(HERE, 'b7_check.py'), mid, '--asis', asis])  # B7(a) 저장 대상 ∩ 콤보 원천 — E2E B7 테스트가 결과를 싣는다(2026-10-28)
    if run([py, os.path.join(HERE, 'mapping_trace.py'), mid, '--asis', asis, '--to-ledger']):
        return 9

    if not a.skip_e2e and not blocked:
        with open(os.path.join(E2E, 'e2e.config.json'), encoding='utf-8-sig') as f:
            cfg = json.load(f)
        urls = {'FE': cfg['feUrl'], 'BE': cfg['beUrl']}
        down = [n for n, u in urls.items() if not reachable(u)]
        if down:
            print(f"[FAIL] {' · '.join(f'{n}({urls[n]})' for n in down)} 미응답(최대 2분 재시도 뒤) — 서버 기동 후 다시 실행(☕ BE Start / 🎨 FE Start). E2E 판정 없이 문서를 만들려면 --skip-e2e")
            return 5
        # 2026-10-28: 화면별 잠금(runlock 'verify <ID>') — 다른 화면의 CheckList 는 동시에 돌고, 같은 화면만 끝나기를 기다린다(최대 120분 · 30초 폴링)
        waited = 0
        while True:
            lock = subprocess.run(['node', 'runlock.js', 'acquire', 'verify', mid], cwd=E2E, capture_output=True, text=True, encoding='utf-8')
            if not lock.returncode:
                break
            if waited == 0:
                print(lock.stderr.strip()); print(f'[WAIT] 같은 화면({mid})의 E2E 가 진행 중 — 끝나면 이어서 실행(최대 120분 대기)', flush=True)
            if waited >= 120 * 60:
                print(f'[FAIL] {mid} E2E 잠금 대기 120분 초과 — 이전 실행을 확인(tools/E2E: node runlock.js status)')
                return 4
            time.sleep(30); waited += 30
        if waited: print(f'[INFO] {mid} 잠금 획득 — {waited // 60}분 대기 후 시작', flush=True)
        # 2026-10-29: 동시 E2E 상한(슬롯 잠금) — 5화면 동시 실행에서 BE 커넥션 풀(maxPoolSize 10) 고갈 → 로그인 401(-9998)·콤보 60초 대기 → 검증엔진(@trace) 미기동(SCP0020·SCP0096·SCP0111 21:24~26)
        #   + CPU 포화로 15분 타임아웃(SCP0111 B1·B2). e2e.config.json verifyMaxConcurrent(기본 3 · 환경변수 VERIFY_MAX_CONCURRENT) 개까지만 동시에 E2E 를 돌리고 넘치면 빈 슬롯까지 대기(30초 폴링 · 최대 120분).
        max_par = int(os.environ.get('VERIFY_MAX_CONCURRENT') or cfg.get('verifyMaxConcurrent') or 3)
        slot, waited = None, 0
        while slot is None:
            for i in range(max_par):
                s = subprocess.run(['node', 'runlock.js', 'acquire', 'slot', str(i)], cwd=E2E, capture_output=True, text=True, encoding='utf-8')
                if not s.returncode:
                    slot = i
                    break
            if slot is not None:
                break
            if waited == 0:
                print(f'[WAIT] 동시 E2E 상한 {max_par}개가 모두 실행 중 — 빈 슬롯이 나면 이어서 실행(최대 120분 대기 · tools/E2E: node runlock.js status)', flush=True)
            if waited >= 120 * 60:
                print(f'[FAIL] {mid} E2E 슬롯 대기 120분 초과 — 실행 중인 E2E 를 확인(tools/E2E: node runlock.js status)')
                subprocess.run(['node', 'runlock.js', 'release', 'verify', mid], cwd=E2E, capture_output=True)
                return 4
            time.sleep(30); waited += 30
        if waited: print(f'[INFO] {mid} E2E 슬롯 {slot} 획득 — {waited // 60}분 대기 후 시작', flush=True)
        else: print(f'[INFO] {mid} E2E 슬롯 {slot}/{max_par} 사용', flush=True)
        try:
            out_dir = os.path.join(ROOT, 'Doc', 'verify', mid)
            res_json = os.path.join(out_dir, 'e2e_results.json')
            if os.path.exists(res_json) and a.tier != 'slow':  # slow 는 fast 결과에 합친다
                os.replace(res_json, res_json + '.prev')  # 이전 실행 결과가 이번 판정에 섞이지 않게
            with open(os.path.join(out_dir, 'tier.json'), 'w', encoding='utf-8') as tf:
                json.dump({'tier': a.tier, 'slow_pending': a.tier == 'fast'}, tf)
            shots_dir = os.path.join(out_dir, 'e2e', 'shots')  # 2026-10-30 테스트결과서 FAIL 캡처 — 이전 실행분 제거
            if os.path.isdir(shots_dir):
                import shutil
                shutil.rmtree(shots_dir, ignore_errors=True)
            # 동적 포트 고갈이면 E2E·DB 가 전부 네트워크 오류로 무너져 측정이 무의미하다(2026-10-29·11-01 SMSNotifier 소켓 16,000+ 재발)
            #   2026-11-05: netstat 은 Bound 소켓을 안 보여 준다(SMSNotifier 16,161개 전부 Bound · netstat 184줄 → 게이트 통과 → Chromium ERR_CONNECTION_FAILED)
            #   → Get-NetTCPConnection 전체 수(Bound 포함)를 기준으로 하고, 실패할 때만 netstat 으로 대체
            ns, src = -1, 'Get-NetTCPConnection'
            try:
                o = subprocess.run(['powershell', '-NoProfile', '-Command', '(Get-NetTCPConnection).Count'], capture_output=True, text=True, timeout=180, errors='replace').stdout.strip()
                ns = int(o.splitlines()[-1]) if o else -1
            except Exception:
                ns = -1
            if ns < 0:
                src = 'netstat(Bound 미포함)'
                try:
                    ns = subprocess.run(['netstat', '-an', '-p', 'TCP'], capture_output=True, text=True, timeout=60, errors='replace').stdout.count('\n')
                except Exception:
                    ns = -1
            print(f'[INFO] TCP 항목 {ns}개({src})', flush=True)
            if ns >= 14000:
                print(f'[FAIL] 동적 포트 고갈 의심 — TCP {ns}개. E2E 를 시작하지 않는다. 점유 프로세스 확인(Get-NetTCPConnection · 사내 보안 에이전트는 임의 종료 금지)', flush=True)
                return 5
            env = dict(os.environ, VERIFY_ID=mid, E2E_RESULTS=os.path.join(out_dir, 'e2e'),
                       PLAYWRIGHT_JSON_OUTPUT_NAME=os.path.join(out_dir, 'e2e', 'results.json'))
            tier_args = ['--grep', 'W4c'] if a.tier == 'slow' else (['--grep', '@verify|@trace', '--grep-invert', 'W4c'] if a.tier == 'fast' else ['--grep', '@verify|@trace'])
            rc = run(['node', os.path.join('node_modules', '@playwright', 'test', 'cli.js'), 'test', '_verify', '_trace', *tier_args, '--workers', '1',
                      '--reporter=list,json'], env=env, cwd=E2E)
            if not os.path.exists(res_json):
                print(f'[FAIL] E2E 결과 파일 없음({res_json}) — Playwright 가 판정 없이 끝남(rc={rc}). 로그 확인')
                return 3
            print(f'E2E 종료 rc={rc} (테스트 실패는 판정 결과로 원장에 반영된다)')
            if a.tier in ('all', 'slow'):  # 엔진 갭 팝업·권한 검사기 — 오래 걸려 fast 에서는 돌지 않는다. 화면 잠금을 쥔 채 실행(2026-11-01)
                run([py, os.path.join(HERE, 'eg_chain.py'), mid, '--asis', asis])
        finally:
            subprocess.run(['node', 'runlock.js', 'release', 'verify', mid], cwd=E2E, capture_output=True)
            subprocess.run(['node', 'runlock.js', 'release', 'slot', str(slot)], cwd=E2E, capture_output=True)
    else:
        print('\n[INFO] --skip-e2e — E2E 판정 행은 미검증(NOT_RUN)으로 남는다')

    # W1 콤보 AS-IS 원천 비교 — E2E 덤프(combo_runtime.json)가 있으면 AS-IS DB 에서 원천을 실행해 B4·B3 판정 근거를 만든다(실패해도 다음 단계 진행 = 판정필요로 남음)
    if os.path.exists(os.path.join(ROOT, 'Doc', 'verify', mid, 'combo_runtime.json')):
        run([py, os.path.join(HERE, 'combo_oracle.py'), mid, '--asis', asis])
    # CRUD 실제 저장 마커 행 정리(사내 DB) — 백업·건수 단언·SQL 기록. 정의 없는 화면은 SKIP(2026-10-24 BOD 잔존 행 사고 재발 방지)
    if not a.skip_e2e and not blocked:
        run([py, os.path.join(HERE, 'restore_touched.py'), mid])  # 시험이 원복 못 한 기존 행 DB 복원(T39)
        run([py, os.path.join(HERE, 'cleanup_marker.py'), mid])
    # F8 감사 필드 · F7 저장 연계 테이블 — 정리 백업(실제 저장이 남긴 행) ↔ AS-IS 저장 SP DML 대상 (2026-10-27)
    run([py, os.path.join(HERE, 'save_audit.py'), mid, '--asis', asis])
    run([py, os.path.join(HERE, 'sp_branch_check.py'), mid])  # 저장 SP 검증 분기 정적 대조(EG161)
    run([py, os.path.join(HERE, 'a1_live.py'), mid])  # 화면 실전송 인자 AS-IS 조회 대조(EG006)
    run([py, os.path.join(HERE, 'sp_dml_check.py'), mid])  # 저장 SP 쓰기 컬럼 대조(EG238·EG230·EG223)
    run([py, os.path.join(HERE, 'i18n_static.py'), mid])  # 다국어 정적 점검(EG451·EG356·EG364)
    run([py, os.path.join(HERE, 'lookup_check.py'), mid])  # Lookup 편집 후보 ↔ 기준 코드(EG066)
    run([py, os.path.join(HERE, 'sort_ci_check.py'), mid])  # 문자 정렬 키 대소문자 무시·NULL 먼저(EG034)
    run([py, os.path.join(HERE, 'i18n_lang_check.py'), mid])  # 언어 전환 문구 ↔ SCM_ADM_MSG_M(EG361)
    run([py, os.path.join(HERE, 'measure_sweep.py'), mid])  # Measure 기준 코드 정합(EG453)
    run([py, os.path.join(HERE, 'db_ref_check.py'), mid])  # TB_FX 참조·ATTRIBUTE9 콤보 실존(EG142·EG143)
    run([py, os.path.join(HERE, 'display_sort_check.py'), mid])  # 콤보 후보 표시명 정렬(EG053)
    run([py, os.path.join(HERE, 'all_cols_check.py'), mid])  # 전 컬럼 선택 조회 SQL 오류(EG213)
    run([py, os.path.join(HERE, 'combo_live_check.py'), mid])  # 콤보 응답 ↔ DB 최신 후보(EG075 B7)
    run([py, os.path.join(HERE, 'measure_by_site_check.py'), mid])  # Sales Site 유형별 Measure 허용 목록(EG068 B5)
    run([py, os.path.join(HERE, 'bg_style_check.py'), mid])  # AS-IS 조건부 셀 색 ↔ TO-BE 스타일 코드(EG312 H2 정적)
    run([py, os.path.join(HERE, 'master_sweep.py'), mid])  # 기준정보 키 존재·활성 후보(EG455)
    run([py, os.path.join(HERE, 'titleset_check.py'), mid])  # 사용자 칸 설정 이관·필수 컬럼(EG025·EG399)
    run([py, os.path.join(HERE, 'eg_ingest.py'), mid])  # 팝업·권한 검사기 결과 → 원장 행·판정 입력
    if run([py, os.path.join(HERE, 'judge.py'), mid]):
        return 7
    # 판정 반입 후 추적표 재계산 + 원장 TRACE 행(행·진입점 집계·정적 판정) 갱신 → 다시 반입(2026-10-27: E2E 전에 만든 집계 행이 낡은 채 남아 판정필요로 보이던 결함)
    if run([py, os.path.join(HERE, 'mapping_trace.py'), mid, '--asis', asis, '--to-ledger']):
        return 9
    run([py, os.path.join(HERE, 'eg_ingest.py'), mid])
    if run([py, os.path.join(HERE, 'judge.py'), mid]):
        return 7
    if run([py, os.path.join(HERE, 'mapping_trace.py'), mid, '--asis', asis]):
        return 9
    run([py, os.path.join(HERE, 'impl_engine.py'), mid])
    # 커버리지(2026-10-30 WP8-b): 규칙별 측정/미실행/NA 집계 + AS-IS 에 기능이 있는데 측정 0 인 규칙(SUSPECT_NA100) — 봉투 summary.coverage · hold
    global COVERAGE_RC
    COVERAGE_RC = run([py, os.path.join(HERE, 'coverage.py'), mid, '--asis', asis])
    cmd = [py, os.path.join(HERE, 'make_verify_docs.py'), mid] + (['--scope', a.scope] if a.scope else [])
    if run(cmd):
        return 8
    # 검사기 회귀 게이트(2026-10-29): 사용자가 '판정오류/중복/대상아님' 으로 판정한 행이 검사기에서 다시 FAIL/별도 항목으로 나오면 여기서 드러난다(위반은 결과 봉투·콘솔)
    #   2026-10-30: 놓친 결함 오라클(_missed_oracle.csv) 포함 — 위반이면 rc 10 으로 중단(CheckList 는 만들어졌지만 검사기가 알려진 결함을 못 잡거나 허위 FAIL 을 냈다는 뜻)
    rc_reg = run([py, os.path.join(HERE, 'regress.py'), mid, '--harvest'])
    if rc_reg:
        print('⚠ 검사기 회귀 위반 — Doc/verify/_regress_report.md 확인(검사기 결함 재발 또는 알려진 결함 미검출) — 이 CheckList 는 검사기 결함을 안고 있다')
        return 10
    if COVERAGE_RC:
        print(f'⚠ 커버리지 게이트 — Doc/verify/{mid}/coverage.csv SUSPECT_NA100: AS-IS 에 기능이 있는데 측정 0 인 규칙이 있다(검사기 대상 생성·측정 경로 누락)')
        return 10
    print('\n다음: ActionItemList xlsx 를 확인한 뒤 보완 범위(🧭 보완 범위 설정)를 정하고 🛠️/🧯 로 보완을 적용한다.')
    return 0


STEP_OF_RC = {2: '인자', 3: 'E2E 판정(결과 파일 없음)', 4: 'E2E 잠금(다른 E2E 실행 중)', 5: 'E2E 서버 미기동', 6: 'AS-IS 사실 보강·원장·사전 작업', 7: '판정(judge)', 8: '문서 생성', 9: '대조표 추적', 10: '검사기 회귀 오라클 위반(문서는 생성됨)'}


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
    resume = '--resume-docs' in sys.argv
    started = STARTED
    if resume and os.path.exists(out):
        try:
            with open(out, encoding='utf-8') as f:
                started = json.load(f).get('started') or STARTED  # 원 실행(E2E·판정)의 시작 시각 유지
        except Exception:
            pass
    base = {'producer': 'run_verify', 'id': mid, 'skip_e2e': skip, 'started': started}  # started = 정합검증 시작 시각(verify_if_stale 최신 판정 기준, 2026-10-28)
    if rc != 0 and rc != 10:  # rc 10 = 문서까지 만든 뒤 회귀 오라클 위반 — 결과 봉투는 완료로 쓰되 note 에 위반을 남긴다(아래)
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
    for kind in ('CheckList', 'ActionItemList'):  # 2026-10-28 정합검증서 → CheckList · 폴더 Doc/CheckList
        import glob
        fs = sorted(glob.glob(os.path.join(ROOT, 'Doc', 'CheckList', f'{mid}_*_{kind}_v*.xlsx')), key=os.path.getmtime)
        if fs:
            docs[kind] = os.path.relpath(fs[-1], ROOT).replace('\\', '/')
    cov = {}
    try:
        with open(os.path.join(ROOT, 'Doc', 'verify', mid, 'coverage.json'), encoding='utf-8') as f:
            cj = json.load(f); cov = {'rules': len(cj.get('rules') or []), 'measured': sum(r['measured'] for r in cj.get('rules') or []), 'not_run_error': sum(r['not_run_error'] for r in cj.get('rules') or []), 'na': sum(r['na'] for r in cj.get('rules') or []), 'suspect_na100': cj.get('suspect_na100') or []}
    except Exception:
        pass
    verdict = 'fail' if cnt.get('FAIL', 0) else ('hold' if unv or pend or cov.get('suspect_na100') else 'pass')
    ev = [{'kind': 'exec', 'ref': 'tools/Harness/verify/run_verify.py'}] + ([{'kind': 'test', 'ref': f'Doc/verify/{mid}/e2e_results.json'}] if not skip else [])
    envelope.write(out, dict(base, state='completed', verdict=verdict, issues=fails[:300],
                             summary={'rows': len(rows), 'PASS': cnt.get('PASS', 0), 'FAIL': cnt.get('FAIL', 0), '판정필요': pend, '미검증': unv, '해당없음': cnt.get('NA', 0),
                                      'AI판단만_강등': demoted, 'grade': gcnt, 'fail_listed': min(len(fails), 300), 'coverage': cov},
                             docs=docs, evidence=ev, note=('E2E 미실행(--skip-e2e) — E2E 행은 이전 결과 또는 미검증' if skip else '') + (f'문서 단계 재개(--resume-docs {STARTED}) — E2E·판정은 원 실행 {started} 결과' if resume else '')
                             + ('⚠ 검사기 회귀 오라클 위반(rc 10) — Doc/verify/_regress_report.md: 알려진 결함 미검출 또는 허위 FAIL 재발 · 이 CheckList 는 검사기 결함을 안고 있음' if rc == 10 else '')))
    print(f"결과 봉투: {os.path.relpath(out, ROOT)} — verdict {verdict} · FAIL {cnt.get('FAIL', 0)} · 판정필요 {pend} · 미검증 {unv}" + (f' · AI 판단만 강등 {demoted}' if demoted else ''))


STARTED = ''
COVERAGE_RC = 0

if __name__ == '__main__':
    import datetime
    STARTED = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    rc = main()
    try:
        write_envelope(rc)
    except Exception as e:  # 봉투 기록 실패가 본 작업 결과를 바꾸지 않게 — 단, 알린다
        print(f'[WARN] 결과 봉투 기록 실패: {e}')
    sys.exit(rc)
