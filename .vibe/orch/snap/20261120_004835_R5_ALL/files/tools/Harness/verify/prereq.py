"""정합검증 사전 작업 점검·선수행 — run_verify.py 1단계 앞에서 실행 (2026-10-28)

사용자 요청(10-28): 다른 화면에 정합검증을 돌렸을 때, 검증에 필요한 사전 작업(파싱·사실 추출·메타·골든 케이스·E2E 스펙·smoke)을
  먼저 수행하고 검증이 진행되어야 한다. 누락된 사전 작업은 정합검증이 찾아서 선수행한다.

항목마다 상태 하나로 남긴다(Doc/verify/<ID>/prereq.json · 실행 로그 — 정합검증서에는 넣지 않는다, 사용자 10-28):
  OK       이미 있음(최신)
  DONE     없거나 오래돼 이번에 생산자를 실행해 만들었음
  MANUAL   자동 생성 불가 — 사람이 만들어야 함(FE 대조표 · 조회조건 기준표 xlsx). 검증은 진행하되 그 범위는 비어 있음
  ERROR    생산자를 실행했는데 산출이 없음 / DB 접속 실패 — 그 입력에 기대는 검사는 판정 근거 없음
  SKIP     이번 실행 대상 아님(--skip-e2e 일 때 E2E 사전 항목)
  FAIL     없으면 검증 자체가 성립하지 않음(AS-IS Fact Pack) → run_verify 중단(rc 6)

  python tools/Harness/verify/prereq.py <MENU_ID> [--asis <AS-IS ID>] [--skip-e2e]

선수행 범위(사용자 10-28: 정합검증 시 소스를 수정하면 안 된다 — 소스 수정은 생성·보완·테스트 절차로만):
  실행하는 생산자 = 읽기 전용 추출(AS-IS pack · TO-BE 메타 export(SELECT) · TO-BE 인덱스 추출 · 골든 케이스 목록) + 테스트 절차(gen-e2e 스펙 · smoke)
  실행하지 않는 것 = 생성 절차(gen.js · pipeline.js) · FE/BE/DB 객체 변경 → 해당 입력이 없으면 MANUAL
"""
import argparse, csv, datetime, glob, json, os, re, subprocess, sys, time
HERE_PR = os.path.dirname(os.path.abspath(__file__))

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
PY = sys.executable
D = lambda *a: os.path.join(ROOT, *a)  # noqa: E731
PACK_CORE = ['controls.csv', 'actions.csv', 'files.csv', 'endpoints.csv']   # ledger·facts_*·combo 원천이 읽는 Fact Pack 핵심
TOBE_META = ['menu.csv', 'msg_master.csv', 'sheet_columns.csv', 'btn_auth.csv', 'proc_meta.csv']  # judge·ledger·gen-e2e 가 읽는 TO-BE 메타
META_MAX_AGE_H = 12  # TO-BE 메타는 DB 작업으로 바뀐다(DB 작업 = 새로 조회한 최신 원문 원칙) — 이보다 오래되면 다시 export


def golden_missing_sps(mid, asis, have):
    """endpoints.csv(현행 · status MATCH · 'SP 이름') SP 중 golden_cases 화면 행에 없는 것, gen_golden_cases.py 와 같은 선택 규칙"""
    d = D('Doc', 'asisfacts', 'screens', asis or mid)
    if not os.path.exists(os.path.join(d, 'endpoints.csv')):
        return []
    try:
        sys.path.insert(0, HERE_PR); from asis_variant import is_main
    except Exception:
        return []
    got = {(r.get('asis_sp') or '').split('.')[-1].upper() for r in have}
    out = []
    for r in read_csv(os.path.join(d, 'endpoints.csv')):
        m = re.match(r'^SP\s+(\S+)', r.get('sp_or_sql', '') or '')
        if m and r.get('status') == 'MATCH' and is_main(r, d):
            sp = m.group(1).split('.')[-1].upper()
            if sp not in got and sp not in out:
                out.append(sp)
    return out


def read_csv(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))


def mtime(p):
    return os.path.getmtime(p) if os.path.exists(p) else 0


def run(cmd, cwd=None, timeout=1800):
    """생산자 실행 — (rc, 출력 끝 400자). 출력은 그대로 흘려 보낸다(무엇을 돌렸는지 로그에 남김)"""
    print(f"  $ {' '.join(cmd)}", flush=True)
    t0 = time.time()
    try:
        p = subprocess.run(cmd, cwd=cwd or ROOT, capture_output=True, text=True, encoding='utf-8', errors='replace', timeout=timeout)
        out = (p.stdout or '') + (p.stderr or '')
        print('\n'.join('    ' + x for x in out.strip().splitlines()[-6:]), flush=True)
        return p.returncode, f"rc={p.returncode} · {round(time.time() - t0)}s · " + re.sub(r'\s+', ' ', out.strip())[-400:]
    except subprocess.TimeoutExpired:
        return -1, f'시간 초과 {timeout}s'


def ps(script, *args):
    return ['powershell', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', script, *args]


def page_dir(mid):
    """TO-BE 화면 폴더 — ① TO-BE 인덱스(Doc/tobefacts/screens/_index.csv 의 feature·page_dir) ② 없으면 MENU_ID 리터럴을 가진 pages/<폴더>
    (②만 쓰면 다른 화면이 그 ID 를 참조하는 폴더를 고를 수 있다 — 2026-10-28 DMF0005)"""
    for r in read_csv(D('Doc', 'tobefacts', 'screens', '_index.csv')):
        if (r.get('menu_id') or '').upper() == mid and r.get('feature') and r.get('page_dir'):
            p = D('nscm-fe', 'features', r['feature'], 'src', 'pages', *r['page_dir'].split('/'))
            if os.path.isdir(p):
                return p
    lit = re.compile(rf"['\"]{re.escape(mid)}['\"]")
    for f in glob.glob(D('nscm-fe', 'features', '*', 'src', 'pages', '**', '*.ts*'), recursive=True):
        try:
            if lit.search(open(f, encoding='utf-8', errors='ignore').read()):
                rel = os.path.relpath(f, ROOT).split(os.sep)
                return os.path.join(ROOT, *rel[:rel.index('pages') + 2])
        except (OSError, ValueError):
            continue
    return ''


def newest(d):
    return max((mtime(f) for f in glob.glob(os.path.join(d, '**', '*.ts*'), recursive=True)), default=0)



# 2026-10-28: 공용 생산자 잠금 — 여러 창(화면)이 동시에 CheckList 를 돌릴 때 TO-BE 메타 export·TobeFacts 인덱스 같은 공용 산출물은 1개 실행만 만든다.
#   다른 실행이 만들고 있으면 끝날 때까지 기다리고(최대 30분), 기다린 뒤에는 호출자가 최신 여부를 다시 판단한다.
def producer_lock(name, work, timeout_s=7200, skip_if_waited=True):
    """2026-11-06 보완(사용자 지시 '동시 수행이 안 되는 항목은 대기 후 진행'):
    · 잠금 파일을 원자적으로 만든다(O_CREAT|O_EXCL — 종전 '있나 확인 → 만들기' 사이에 두 실행이 동시에 들어올 수 있었다)
    · 살아 있는 실행의 잠금은 지우지 않는다(종전 30분 지나면 삭제 → 공용 파일 동시 쓰기). 보유 프로세스가 죽었으면 잠금을 치운다
    · skip_if_waited=True(공용 생산물 — 메타·인덱스): 기다린 뒤에는 작업 없이 ('WAITED', 사유) → 호출자가 최신 여부 재판단
      skip_if_waited=False(화면별로 내용이 다른 공용 파일 — golden_cases.csv·스펙 색인): 기다린 뒤 이어서 작업한다
    · timeout_s(기본 120분) 초과 = (4, 사유) — 4 = 잠금(환경)"""
    lk = D('Doc', 'tobefacts', f'_producer.{name}.lock'); waited = 0; pid = 0
    os.makedirs(os.path.dirname(lk), exist_ok=True)
    while True:
        try:
            fd = os.open(lk, os.O_CREAT | os.O_EXCL | os.O_WRONLY)
            with os.fdopen(fd, 'w', encoding='utf-8') as f:
                json.dump({'pid': os.getpid(), 'name': name, 'at': datetime.datetime.now().isoformat(timespec='seconds')}, f)
            break
        except FileExistsError:
            try:
                info = json.load(open(lk, encoding='utf-8')); pid = int(info.get('pid') or 0)
                alive = subprocess.run(['tasklist', '/FI', f'PID eq {pid}', '/FO', 'CSV', '/NH'], capture_output=True, text=True, timeout=20).stdout.find(f'"{pid}"') >= 0 if pid else False
            except json.JSONDecodeError:
                alive = True  # 다른 실행이 막 쓰는 중(내용 아직 없음) — 살아 있는 것으로 본다
            except Exception:
                alive = True  # tasklist 지연·오류를 '죽음' 으로 보지 않는다(runlock 과 같은 보수 판정)
            if not alive:
                try: os.remove(lk)
                except Exception: pass
                continue
            if waited >= timeout_s:
                return (4, f'[WAIT 초과] 다른 실행(PID {pid})이 {name} 을 {waited // 60}분째 사용 중 — 잠금 {os.path.relpath(lk, ROOT)}')
            if waited == 0: print(f'[WAIT] 다른 실행(PID {pid})이 {name} 을 사용 중 — 끝나면 이어서 진행(최대 {timeout_s // 60}분)', flush=True)
            time.sleep(10); waited += 10
    try:
        if waited and skip_if_waited:
            return ('WAITED', f'다른 실행(PID {pid})이 {name} 생산 중이라 {waited // 60}분 대기')
        if waited: print(f'[INFO] {name} 잠금 획득 — {waited // 60}분 {waited % 60}초 대기 후 진행', flush=True)
        return work()
    finally:
        try: os.remove(lk)
        except Exception: pass

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id')
    ap.add_argument('--asis', default='')
    ap.add_argument('--skip-e2e', action='store_true')
    ap.add_argument('--docs', action='store_true', help='문서 생성 체인 사전 준비(파싱·메타만 — 골든·E2E·대조표 점검 없음 · GAP 분석은 2026-10-30 폐지)')
    a = ap.parse_args()
    mid = a.menu_id.upper()
    asis = (a.asis or next((m['asis_id'] for m in read_csv(D('tools', 'Harness', 'rules', 'map_screen.csv')) if m.get('tobe_id', '').upper() == mid), mid)).upper()
    items = []
    # 2026-11-06(사용자 지시 · CheckList 진행 표시): 사전 작업 = run_verify 단계 1 — 항목마다 '[세부 j/M] 항목 — 상태' 줄(VM Flow 카드가 읽는다)
    #   M = 이 실행에서 점검할 항목 수: DB·Fact Pack·TO-BE 메타·TO-BE 인덱스·FE 대조표·골든(6) + 조회조건 기준표(SCP·SSP) + E2E(--skip-e2e 면 1, 아니면 plan·스펙·smoke 3)
    #   --docs(문서 체인)는 항목 구성이 달라 표시하지 않는다
    pre_total = 0 if a.docs else 6 + (1 if mid.startswith(('SCP', 'SSP')) else 0) + (1 if a.skip_e2e else 3)

    def put(key, what, status, producer='', evidence=''):
        items.append({'key': key, 'what': what, 'status': status, 'producer': producer, 'evidence': evidence[:600]})
        if pre_total:
            print(f"[세부 {min(len(items), pre_total)}/{pre_total}] {what} — {status}", flush=True)
        print(f"[{status}] {what} — {evidence[:200]}", flush=True)

    print(f'== UI CheckList 사전 작업 점검 {mid} (AS-IS {asis})', flush=True)

    # P1 DB 접속 — golden(A1·A7)·combo_oracle(B3·B4·G7)·sort_check·save_audit·I1/I4 가 직접 조회한다
    rc, ev = run([PY, D('tools', 'DbConn', 'probe.py')], timeout=180)
    put('db', 'DB 접속(AS-IS MSSQL · TO-BE Oracle)', 'OK' if rc == 0 else 'ERROR', 'tools/DbConn/probe.py',
        '전부 접속' if rc == 0 else f'접속 실패 있음 — DB 조회 검사는 ERROR 로 남는다 · {ev}')

    # P2 AS-IS Fact Pack — 없으면 검증 불성립
    sd = D('Doc', 'asisfacts', 'screens', asis)
    lack = [n for n in PACK_CORE if not os.path.exists(os.path.join(sd, n))]
    if lack:
        rc, ev = run(ps(D('tools', 'AsisFacts', 'pack.ps1'), asis), timeout=900)
        lack2 = [n for n in PACK_CORE if not os.path.exists(os.path.join(sd, n))]
        if lack2:
            # 2026-11-19 사용자: "파싱이 없으면 무조건 파싱부터 수행" — 화면 재생성(pack)으로도 없으면 파서 전체 실행(run.ps1 = 빌드·함정 시험·scan·교차검증·pack) 뒤
            #   다시 pack 하고 CheckList 를 계속한다(멈추지 않고 먼저 수행). 공용 결과라 잠금으로 한 번만 · 다른 실행이 돌리는 중이면 끝난 뒤 pack 만
            print(f"[INFO] AS-IS 파싱 결과에 {asis} 없음({', '.join(lack2)}) → 파서 전체 실행 후 다시 생성", flush=True)
            _skip = ['-SkipBuild'] if os.path.exists(D('tools', 'AsisFacts', '_bin', 'AsisFacts.dll')) else []
            pr = producer_lock('asisfacts_parse', lambda: run(ps(D('tools', 'AsisFacts', 'run.ps1'), *_skip), cwd=D('tools', 'AsisFacts'), timeout=5400), timeout_s=5400)
            prc, pev = (pr[0], pr[1]) if isinstance(pr, tuple) else (pr, '')
            rc, ev2 = run(ps(D('tools', 'AsisFacts', 'pack.ps1'), asis), timeout=900)
            ev = f"파서 전체 실행 rc={prc}{' · ' + pev[-160:] if pev else ''} · 다시 pack rc={rc} · {ev2}"
            lack = lack + [n for n in lack2 if n not in lack]
            lack2 = [n for n in PACK_CORE if not os.path.exists(os.path.join(sd, n))]
        put('asis_pack', f'AS-IS Fact Pack({asis})', 'FAIL' if lack2 else 'DONE', 'tools/AsisFacts/pack.ps1 <AS-IS ID>',
            (f"pack 후에도 {', '.join(lack2)} 없음 — scan 결과에 화면이 없으면 '🔬 파서 전체 실행'(tools/AsisFacts/run.ps1) 필요 · "
             + (f"map_screen.csv 에 {mid}→AS-IS ID 짝이 없어 같은 ID 로 찾음 · " if asis == mid else '') + ev) if lack2 else f"없던 {', '.join(lack)} 생성 · {ev}")
    else:
        put('asis_pack', f'AS-IS Fact Pack({asis})', 'OK', 'tools/AsisFacts/pack.ps1', f"{', '.join(PACK_CORE)} 있음")
    if any(i['status'] == 'FAIL' for i in items):
        return finish(mid, asis, items, 6)

    # (AS-IS 셀·잠금·콤보·정렬·그리드 컬럼 사실 = run_verify 1단계 facts_*.py 가 매번 다시 만든다 — 여기서 중복 실행하지 않음)

    # P4 TO-BE DB 메타 — 오래되면 다시 export(SELECT 만)
    mp = [D('Doc', 'tobefacts', 'db', n) for n in TOBE_META]
    age = (time.time() - min(mtime(p) for p in mp)) / 3600
    if age > META_MAX_AGE_H:
        _r = producer_lock('tobe_meta', lambda: run([PY, D('tools', 'DbConn', 'export_tobe_meta.py')], timeout=1800))
        rc, ev = (0, _r[1]) if _r[0] == 'WAITED' else _r
        age2 = (time.time() - min(mtime(p) for p in mp)) / 3600
        put('tobe_meta', 'TO-BE DB 메타(Doc/tobefacts/db)', 'DONE' if age2 <= META_MAX_AGE_H else 'ERROR', 'tools/DbConn/export_tobe_meta.py',
            f'{round(age)}시간 지난 메타 → 다시 export · {ev}')
    else:
        put('tobe_meta', 'TO-BE DB 메타(Doc/tobefacts/db)', 'OK', 'tools/DbConn/export_tobe_meta.py', f'{round(age, 1)}시간 전 export(기준 {META_MAX_AGE_H}시간)')

    # P5 TO-BE 화면 인덱스(TobeFacts) — 화면이 없거나 FE 소스가 인덱스보다 새로우면 재추출
    pdir = page_dir(mid)
    ip = D('Doc', 'tobefacts', 'screens', '_index.csv')
    inx = [r for r in read_csv(ip) if (r.get('menu_id') or '').upper() == mid]
    if not pdir and a.docs:  # 문서는 TO-BE 화면이 없어도 AS-IS 기준으로 만든다
        put('tobe_index', 'TO-BE 화면 소스·인덱스', 'SKIP', '-', f'nscm-fe 에 {mid} 화면 없음 — AS-IS 기준 문서만(TO-BE 열은 "원천 없음")')
    elif not pdir:
        put('tobe_index', 'TO-BE 화면 소스·인덱스', 'FAIL', '-', f'nscm-fe 에서 {mid} 를 쓰는 화면 폴더를 찾지 못함 — TO-BE 화면 미개발이면 CheckList 대상 아님')
        return finish(mid, asis, items, 6)
    elif not inx or newest(pdir) > mtime(ip):
        _r = producer_lock('tobe_index', lambda: run(ps(D('tools', 'TobeFacts', 'run.ps1')), timeout=1800))
        rc, ev = (0, _r[1]) if _r[0] == 'WAITED' else _r
        ok = any((r.get('menu_id') or '').upper() == mid for r in read_csv(ip)) and mtime(ip) >= newest(pdir)
        put('tobe_index', 'TO-BE 화면 인덱스(Doc/tobefacts/screens)', 'DONE' if ok else 'ERROR', 'tools/TobeFacts/run.ps1',
            f"{'인덱스에 화면 없음' if not inx else 'FE 소스가 인덱스보다 최신'} → 재추출 · {ev}")
    else:
        put('tobe_index', 'TO-BE 화면 인덱스(Doc/tobefacts/screens)', 'OK', 'tools/TobeFacts/run.ps1', f'{os.path.relpath(pdir, ROOT)} · 인덱스 최신')

    # --docs(문서 생성 체인 사전 준비, 2026-10-28 사용자: 다른 PC 에서 만든 UI 도 생성 절차 없이 파싱부터 필요한 절차만 거쳐 문서 생성)
    #   GAP 은 '없을 때만'이 아니라 TO-BE 인덱스·AS-IS Pack 보다 오래되면 다시 만든다(옛 UI 기준 GAP 으로 문서가 나오는 것 방지). 생성 절차는 돌리지 않는다
    if a.docs:
        # 2026-10-30 사용자: GAP 분석 폐지(CheckList 로 대체) — gap.js 재생성 단계 제거
        reg = D('Doc', 'gen', mid, 'register.json')
        put('gen_register', '생성 절차 산출물(Doc/gen/<ID>/register.json)', 'OK' if os.path.exists(reg) else 'SKIP', '생성 절차(gen.js)',
            '있음' if os.path.exists(reg) else '없음(다른 PC·생성 절차 밖 UI) — 생성 절차는 돌리지 않음. 문서의 페이지 폴더는 TO-BE 인덱스로 찾는다(make_docs)')
        return finish(mid, asis, items, 0, 'prereq_docs.json')

    # P6 FE 대조표 — 자동 생성 금지(커밋본 페이지 덮어쓰기 금지) → MANUAL
    mm = os.path.join(pdir, '__asis-mapping__.md')
    put('mapping_md', 'FE 대조표(__asis-mapping__.md)', 'OK' if os.path.exists(mm) else 'MANUAL', '화면 개발 시 작성(하네스 gen.js 초안 = Doc/gen/<ID>)',
        os.path.relpath(mm, ROOT) if os.path.exists(mm) else f'{os.path.relpath(pdir, ROOT)} 에 대조표 없음 — 대조표 행 검사 0건(AS-IS 액션 기준만 검사). 화면 담당이 작성해야 함(자동 생성·덮어쓰기 금지)')

    # P7 조회조건 기준표(SCP·SSP 만 — TO-BE 룰 CR-071)
    if mid.startswith(('SCP', 'SSP')):
        hit = any((r.get('menu_id') or '').upper() == mid for r in read_csv(D('tools', 'Harness', 'rules', 'search_cond.csv')))
        put('search_cond', '조회조건 기준표(search_cond.csv)', 'OK' if hit else 'MANUAL', 'tools/Harness/refs/build_search_cond.py(원천 = 사용자 xlsx)',
            '화면 행 있음' if hit else '기준표 xlsx 에 이 화면 행 없음 — 조회조건 순서·라벨(CR-071)은 AS-IS 기준으로만 판정. 기준표 xlsx 보강 후 build_search_cond.py')

    # P8 골든 케이스 — A1 건수·A7 컬럼별 값·F7/F8 저장 대조·B7(a) 의 입력
    gc = D('Doc', 'golden', 'golden_cases.csv')
    have = [r for r in read_csv(gc) if (r.get('screen') or '').upper() == mid]
    # 2026-11-19 SCP0096 F7·F8 미검증: 화면 행이 1건이라도 있으면 다시 만들지 않아, 뒤에 추가된 AS-IS 호출 SP(저장 SP 등)가 골든에 빠진 채 남았다
    #   (golden_cases 11-17 생성본에 SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP 없음 → save_audit F7 '저장 SP 없음'). endpoints.csv 의 현행 MATCH SP 가 빠졌으면 다시 만든다(수동 지정 행·다른 화면 행은 생성기가 보존)
    missing = golden_missing_sps(mid, asis, have)
    if missing:
        print(f"[prereq] 골든 케이스에 없는 AS-IS 호출 SP {len(missing)}개({', '.join(missing[:5])}), gen_golden_cases.py 다시 실행")
        have = []
    if not have:
        rc, ev = producer_lock('golden_cases', lambda: run([PY, D('tools', 'DbConn', 'gen_golden_cases.py'), mid]), skip_if_waited=False)  # 공용 golden_cases.csv 동시 쓰기 방지(11-06)
        have = [r for r in read_csv(gc) if (r.get('screen') or '').upper() == mid]
        put('golden', '골든 케이스(golden_cases.csv)', 'DONE' if have else 'ERROR', 'tools/DbConn/gen_golden_cases.py <ID>',
            (f"{len(have)}건 생성 (GET {sum(1 for r in have if r.get('kind') != 'SAVE')} · SAVE {sum(1 for r in have if r.get('kind') == 'SAVE')}) · {ev}") if have else f'생성 0건 — endpoints.csv 에 짝지을 AS-IS SP 없음 또는 TO-BE PROC 미매칭 · {ev}')
    else:
        put('golden', '골든 케이스(golden_cases.csv)', 'OK', 'tools/DbConn/gen_golden_cases.py', f'{len(have)}건 있음')
    empty = [r.get('case_id', '') for r in have if not (r.get('tobe_proc') or '').strip()]
    if empty:
        items[-1]['evidence'] += f" · TO-BE PROC 미매칭 {len(empty)}건({', '.join(empty[:5])}) — golden.py 가 SKIP(사람이 tobe_proc 지정)"

    # P9~P11 E2E 사전 — plan(gen.js, 적용 없이 Doc/gen 에만) → 스펙(gen-e2e.js) → smoke 결과(judge 가 K2·I2·F4 근거로 읽음)
    if a.skip_e2e:
        put('e2e', 'E2E 사전(plan·스펙·smoke)', 'SKIP', '-', '--skip-e2e')
        return finish(mid, asis, items, 0)
    # E2E plan — 2026-10-30: 없으면 `gen.js --plan-only` 로 만든다(Doc/gen/<ID> 를 지우지 않고 e2e_plan.json 만 · 소스·FE 무변경). 그래도 없으면 FAIL(rc 6).
    #   (종전 MANUAL + rc 0 → SCP0111 은 plan·스펙·smoke 가 한 번도 없이 CheckList 가 만들어져 G3/K4/SC1/K1/K2 전부 '검사기가 실행하지 못함' NA — 검사기 결함 T13)
    plan = D('Doc', 'gen', mid, 'e2e_plan.json')
    if not os.path.exists(plan):
        rc, ev = run(['node', D('tools', 'Harness', 'gen.js'), mid, '--plan-only'], cwd=D('tools', 'Harness'))
        put('e2e_plan', 'E2E plan(Doc/gen/<ID>/e2e_plan.json)', 'DONE' if os.path.exists(plan) else 'FAIL', 'tools/Harness/gen.js <ID> --plan-only',
            ('plan-only 생성 · ' + ev) if os.path.exists(plan) else f'plan 생성 실패(AS-IS Fact Pack·TO-BE 메타 확인) — smoke 근거 규칙을 측정할 수 없어 검증을 중단한다 · {ev}')
        if not os.path.exists(plan):
            return finish(mid, asis, items, 6)
    else:
        put('e2e_plan', 'E2E plan(Doc/gen/<ID>/e2e_plan.json)', 'OK', 'tools/Harness/gen.js', '있음')
    spec = D('Doc', 'e2e', 'specs', f'{mid}.plan.json')
    if not os.path.exists(spec) or mtime(spec) < max(mtime(plan), mtime(D('Doc', 'tobefacts', 'db', 'menu.csv'))):
        rc, ev = producer_lock('e2e_specs', lambda: run(['node', D('tools', 'E2E', 'gen-e2e.js'), mid], cwd=D('tools', 'E2E')), skip_if_waited=False)  # 공용 specs/_index.csv·_matrix.csv 동시 쓰기 방지(11-06)
        put('e2e_spec', 'E2E 스펙(Doc/e2e/specs/<ID>.*)', 'DONE' if os.path.exists(spec) and mtime(spec) >= mtime(plan) else 'FAIL', 'tools/E2E/gen-e2e.js <ID>', ev)
        if not os.path.exists(spec):
            return finish(mid, asis, items, 6)
    else:
        put('e2e_spec', 'E2E 스펙(Doc/e2e/specs/<ID>.*)', 'OK', 'tools/E2E/gen-e2e.js', '최신')
    # smoke — 결과가 없거나 FE 소스보다 오래되면 실행(run-e2e.cmd 가 자기 잠금·서버 점검을 한다 → run_verify 의 E2E 잠금보다 먼저 끝난다)
    # 2026-11-06(사용자 지시): smoke 결과·로그는 화면 폴더(Doc/e2e/results/<ID>/ · Doc/e2e/logs/<ID>/) — 없으면(전환 전) 공용 위치. 찾는 규칙 = e2e_paths
    import e2e_paths
    last = e2e_paths.summary_rows(mid, 'smoke')
    # _summary.csv 에는 시각 열이 없다 → 이 화면 smoke 실행 로그(run_<RUNID>_smoke.log 첫 줄 '==== … run-e2e smoke <ID>')의 시각 = 마지막 smoke 시각
    smoke_at = max((mtime(f) for f in e2e_paths.run_logs(mid, 'smoke')), default=0)
    # 2026-11-06 T65(SCP0084 K-SA): 기준이 FE 소스뿐이라 smoke 엔진 보완(T57 smoke-extra.ts 11-05 10:49) 전 결과(11-05 06:24)를 그대로 재사용 → 고친 결함이 다시 ERROR.
    #   smoke 엔진 파일·이 화면 smoke 스펙이 결과보다 새로우면 다시 실행한다.
    eng = [D('tools', 'E2E', 'lib', 'smoke-extra.ts'), D('tools', 'E2E', 'lib', 'nscm.ts'), D('Doc', 'e2e', 'specs', f'{mid}.smoke.spec.ts')]
    eng_at = max((mtime(f) for f in eng if os.path.exists(f)), default=0)
    if os.path.exists(spec) and (not last or smoke_at < newest(pdir) or smoke_at < eng_at):
        # 2026-11-06: run-e2e.cmd smoke <ID> 는 화면별 잠금(_run.e2e.<ID>.lock)·화면 폴더라 다른 화면 smoke 와 동시에 돈다.
        #   잠금(rc 4)은 같은 화면 E2E 또는 공용(여러 화면·전체) E2E 가 도는 중일 때만 — 그때는 풀릴 때까지 30초 간격 재시도(최대 120분) 후 진행
        sw = 0
        while True:
            rc, ev = run(['cmd', '/c', D('tools', 'E2E', 'run-e2e.cmd'), 'smoke', mid], cwd=D('tools', 'E2E'), timeout=7200)
            if rc != 4 or sw >= 7200:
                break
            if sw == 0: print(f'[WAIT] 같은 화면({mid}) E2E 또는 공용(여러 화면·전체) E2E 가 실행 중 — 끝나면 이어서 smoke 실행(30초 간격 · 최대 120분 · tools/E2E: node runlock.js status)', flush=True)
            time.sleep(30); sw += 30
        if sw and rc != 4: print(f'[INFO] smoke 잠금 획득 — {sw // 60}분 대기 후 실행', flush=True)
        last = e2e_paths.summary_rows(mid, 'smoke')
        # rc 1 = smoke 안에 FAIL 이 있음(실행은 됨) · 4 = 다른 E2E 실행 중 · 5 = 서버 미기동
        st = 'DONE' if last and rc in (0, 1) else 'FAIL'
        why = {4: '다른 E2E 실행 중(잠금)', 5: 'FE/BE 미기동'}.get(rc, '')
        put('smoke', 'smoke 결과(Doc/e2e/results/<ID>/_summary.csv · 없으면 공용)', st, 'tools/E2E/run-e2e.cmd smoke <ID>',
            (f"smoke {len(last)}건 실행{' (FAIL 포함 — 결과는 판정 근거로 반입)' if rc == 1 else ''} · {ev}") if st == 'DONE' else f'{why or "실행 실패"} — smoke 근거 규칙(G3·K4·SC1·K1·K2·I2)을 측정할 수 없어 검증을 중단한다 · {ev}')
        if st == 'FAIL':
            return finish(mid, asis, items, 5 if rc in (4, 5) else 6)  # 5 = 서버/잠금(환경) · 6 = 생산 실패
    else:
        put('smoke', 'smoke 결과(Doc/e2e/results/<ID>/_summary.csv · 없으면 공용)', 'OK' if last else 'FAIL', 'tools/E2E/run-e2e.cmd smoke',
            f"{len(last)}건 · 마지막 smoke {datetime.datetime.fromtimestamp(smoke_at).strftime('%m-%d %H:%M') if smoke_at else '-'} (FE 소스·smoke 엔진보다 최신)" if last else 'smoke 결과 행 없음(스펙은 있음) — 검증 중단')
        if not last:
            return finish(mid, asis, items, 6)
    return finish(mid, asis, items, 0)


def finish(mid, asis, items, rc, name='prereq.json'):
    od = D('Doc', 'verify', mid)
    os.makedirs(od, exist_ok=True)
    out = {'menu_id': mid, 'asis_id': asis, 'generated': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), 'rc': rc, 'items': items}
    json.dump(out, open(os.path.join(od, name), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    from collections import Counter
    print(f"== 사전 작업 {dict(Counter(i['status'] for i in items))} → {os.path.join(od, name)}", flush=True)
    return rc


if __name__ == '__main__':
    sys.exit(main())
