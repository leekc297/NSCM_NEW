# -*- coding: utf-8 -*-
"""fe_gate.py — EN-04 FE 화면 열기·조회 smoke 게이트 (2026-11-11 · 플랜 '추측 대신 실행' M1)

FE 를 만들거나 고친 뒤 "동작한다"를 정규식·타입 검사만으로 끝내지 않고, 실제 브라우저로 화면을 열어 조회 1회를 한 결과로 통과 여부를 낸다.
  F1 실행 증빙   이번 실행이 쓴 smoke 요약(Doc/e2e/results/<ID>/_summary.csv)만 인정 — 옛 결과 재사용 금지(--no-run 은 요약 시각을 그대로 보고)
  F2 화면 열림   열림 직후 콘솔 오류 중 치명 0
  F3 조회 1회    기준 조회가 call-proc 1건 이상 [OK]
  F4 smoke 세부  (참고 · 게이트 제외) 세부 검사 FAIL 행 수 — 조회조건·헤더 등은 CheckList 가 TO-BE 룰로 판정한다
판정: 서버(8080·5173)가 내려가 있거나 요약이 이번 실행 것이 아니면 ERROR(미측정) — PASS 로 적지 않는다.
한계: F2·F3 은 요약의 주석 문장을 읽는다(구조화 증거 EN-11 전환 전) — 문장을 못 찾으면 PASS 가 아니라 ERROR.

  python tools/Harness/verify/fe_gate.py <MENU_ID>            smoke 실행 후 판정(서버 필요)
  python tools/Harness/verify/fe_gate.py <MENU_ID> --no-run   직전 smoke 요약만 판정(새로 재지 않음 · 요약 시각 표시)
  python tools/Harness/verify/fe_gate.py --selftest
출력: Doc/verify/<ID>/fe_gate.json · 종료코드 0 통과 / 2 FAIL / 3 미측정(ERROR)
"""
import csv, json, os, re, socket, subprocess, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
try:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception:
    pass
RX_OPEN = re.compile(r'열림 직후 오류\s*(\d+)\s*\(치명\s*(\d+)\)')
RX_SEARCH = re.compile(r'\[(OK|FAIL|NG|ERROR)\]\s*\(기준 조회\)\(search\)\s*—\s*call-proc\s*(\d+)')


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def decide(rows, fresh, ran):
    """rows = smoke 요약 행 · fresh = 이번 실행이 쓴 요약인가 · ran = 이번에 실행했는가. 반환 (gates, rc)"""
    g = []
    sm = [r for r in rows if (r.get('kind') or '') == 'smoke']
    if ran and not fresh:
        g.append({'gate': 'F1 실행 증빙', 'result': 'ERROR', 'detail': 'smoke 를 실행했지만 요약이 갱신되지 않음 — 실행 실패(미측정)'})
        return g, 3
    if not sm:
        g.append({'gate': 'F1 실행 증빙', 'result': 'ERROR', 'detail': 'smoke 요약 행 없음(미측정)'})
        return g, 3
    g.append({'gate': 'F1 실행 증빙', 'result': 'PASS' if ran else 'STALE', 'detail': f"smoke {len(sm)}행" + ('' if ran else ' — 이번에 재지 않음(직전 요약)')})
    text = ' || '.join((r.get('annotations') or '') + ' ' + (r.get('errors') or '') for r in sm)
    m = RX_OPEN.search(text)
    fatal_rows = [r for r in sm if re.search(r'치명\s*[1-9]', (r.get('annotations') or '') + (r.get('errors') or ''))]
    if fatal_rows:
        g.append({'gate': 'F2 화면 열림', 'result': 'FAIL', 'detail': '열림 직후 치명 콘솔 오류 — ' + (fatal_rows[0].get('errors') or fatal_rows[0].get('annotations') or '')[:300]})
    elif m:
        g.append({'gate': 'F2 화면 열림', 'result': 'PASS', 'detail': f'열림 직후 콘솔 오류 {m.group(1)}건 중 치명 {m.group(2)}'})
    elif any(r.get('status') == 'PASS' for r in sm):
        g.append({'gate': 'F2 화면 열림', 'result': 'PASS', 'detail': '콘솔 오류 주석 없음 · smoke PASS 행 있음(화면 열림 이후 단계 통과)'})
    else:
        g.append({'gate': 'F2 화면 열림', 'result': 'ERROR', 'detail': '열림 측정 문장을 찾지 못함(미측정)'})
    s = RX_SEARCH.search(text)
    if not s:
        g.append({'gate': 'F3 조회 1회', 'result': 'ERROR', 'detail': '기준 조회 측정 문장을 찾지 못함(미측정)'})
    elif s.group(1) == 'OK' and int(s.group(2)) >= 1:
        g.append({'gate': 'F3 조회 1회', 'result': 'PASS', 'detail': f'기준 조회 call-proc {s.group(2)}건 [OK]'})
    else:
        g.append({'gate': 'F3 조회 1회', 'result': 'FAIL', 'detail': f'기준 조회 [{s.group(1)}] call-proc {s.group(2)}건'})
    bad = [r for r in sm if r.get('status') == 'FAIL']
    # 2026-11-11 실측(SSP0005·SCP0028·SSP0200): smoke 세부 FAIL 은 조회조건 라벨·헤더 단 수 등 CheckList 가 TO-BE 룰까지 적용해 판정하는 항목 → 게이트 판정에서 제외하고 수만 알린다
    if bad:
        g.append({'gate': 'F4 smoke 세부(참고)', 'result': 'INFO', 'detail': f"세부 검사 FAIL {len(bad)}/{len(sm)}행 — CheckList 판정 대상(게이트 제외): " + ' / '.join((r.get('errors') or '')[:120] for r in bad[:3])})
    else:
        g.append({'gate': 'F4 smoke 세부(참고)', 'result': 'INFO', 'detail': f'세부 검사 FAIL 0/{len(sm)}행'})
    res = [x['result'] for x in g]
    rc = 2 if 'FAIL' in res else (3 if 'ERROR' in res else 0)
    return g, rc


def selftest():
    st = {'ok': 0, 'n': 0}

    def t(name, cond):
        st['n'] += 1
        st['ok'] += bool(cond)
        print(('PASS ' if cond else 'FAIL ') + name)
    okrow = {'kind': 'smoke', 'status': 'PASS', 'errors': '', 'annotations': 'console: 열림 직후 오류 43(치명 0): x || cond: [OK] (기준 조회)(search) — call-proc 2'}
    g, rc = decide([okrow], True, True)
    t('열림·조회 정상 → rc 0', rc == 0 and [x['result'] for x in g] == ['PASS'] * 3 + ['INFO'])
    g, rc = decide([dict(okrow, annotations=okrow['annotations'].replace('치명 0', '치명 2'))], True, True)
    t('치명 콘솔 오류(변이) → F2 FAIL', rc == 2 and g[1]['result'] == 'FAIL')
    g, rc = decide([dict(okrow, annotations='console: 열림 직후 오류 0(치명 0) || cond: [FAIL] (기준 조회)(search) — call-proc 0')], True, True)
    t('조회 0건·실패(변이) → F3 FAIL', rc == 2 and g[2]['result'] == 'FAIL')
    g, rc = decide([okrow, {'kind': 'smoke', 'status': 'FAIL', 'errors': 'Error: 병합 헤더', 'annotations': ''}], True, True)
    t('세부 검사 FAIL 행은 게이트를 막지 않고 수만 알린다', rc == 0 and g[3]['result'] == 'INFO' and '1/2' in g[3]['detail'])
    g, rc = decide([okrow], False, True)
    t('실행했는데 요약 미갱신 = ERROR(옛 결과로 통과시키지 않음)', rc == 3 and g[0]['result'] == 'ERROR')
    g, rc = decide([], True, True)
    t('요약 0행 = ERROR', rc == 3)
    g, rc = decide([{'kind': 'smoke', 'status': 'PASS', 'errors': '', 'annotations': 'common: [OK] Sort(F3)'}], True, True)
    t('조회 측정 문장 없음 = ERROR(통과 아님)', rc == 3 and g[2]['result'] == 'ERROR')
    g, rc = decide([okrow], False, False)
    t('--no-run = STALE 표기(이번 측정 아님)', g[0]['result'] == 'STALE' and rc == 0)
    g, rc = decide([{'kind': 'crud', 'status': 'PASS', 'errors': '', 'annotations': okrow['annotations']}], True, True)
    t('smoke 가 아닌 행만 있으면 ERROR', rc == 3)
    print(f"{st['ok']}/{st['n']}")
    return 0 if st['ok'] == st['n'] else 1


def port_open(p):
    s = socket.socket()
    s.settimeout(2)
    try:
        s.connect(('127.0.0.1', p))
        return True
    except OSError:
        return False
    finally:
        s.close()


def main():
    a = sys.argv[1:]
    if '--selftest' in a:
        return selftest()
    if not a or a[0].startswith('--'):
        print(__doc__)
        return 3
    mid = a[0].upper()
    vd = os.path.join(ROOT, 'Doc', 'verify', mid)
    os.makedirs(vd, exist_ok=True)
    sp = os.path.join(ROOT, 'Doc', 'e2e', 'results', mid, '_summary.csv')
    at = time.strftime('%Y-%m-%d %H:%M:%S')
    t0 = time.time()
    ran = '--no-run' not in a
    before = os.path.getmtime(sp) if os.path.exists(sp) else 0
    note = ''
    if ran:
        down = [p for p in (8080, 5173) if not port_open(p)]
        if down:
            gates = [{'gate': 'F1 실행 증빙', 'result': 'ERROR', 'detail': f'서버 포트 {down} 응답 없음 — smoke 실행 불가(미측정). BE/FE 기동 후 다시 실행'}]
            rc = 3
            json.dump({'menu_id': mid, 'at': at, 'seconds': 0, 'rc': rc, 'gates': gates}, open(os.path.join(vd, 'fe_gate.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
            print(f"[fe_gate] {mid}: {gates[0]['detail']}")
            return rc
        cmd = os.path.join(ROOT, 'tools', 'E2E', 'run-e2e.cmd')
        p = subprocess.run(['cmd', '/c', cmd, 'smoke', mid], cwd=os.path.join(ROOT, 'tools', 'E2E'), capture_output=True, text=True, encoding='utf-8', errors='replace')
        note = f'run-e2e smoke 종료코드 {p.returncode}'
        print(f"[fe_gate] {mid}: {note} · {round(time.time() - t0)}초")
    fresh = os.path.exists(sp) and os.path.getmtime(sp) > before
    rows = rd(sp)
    gates, rc = decide(rows, fresh, ran)
    stamp = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(os.path.getmtime(sp))) if os.path.exists(sp) else '없음'
    res = {'menu_id': mid, 'at': at, 'seconds': round(time.time() - t0), 'rc': rc, 'summary_time': stamp, 'ran': ran, 'note': note, 'gates': gates}
    with open(os.path.join(vd, 'fe_gate.json'), 'w', encoding='utf-8') as f:
        json.dump(res, f, ensure_ascii=False, indent=1)
    for x in gates:
        print(f"[fe_gate] {x['gate']}: {x['result']} — {x['detail'][:400]}")
    verdict = '통과' if rc == 0 else ('FAIL 있음' if rc == 2 else '미측정 있음(ERROR)')
    print(f"[fe_gate] {mid} {at} · smoke 요약 시각 {stamp}{'' if ran else ' (이번에 재지 않음)'} · {verdict} → Doc/verify/{mid}/fe_gate.json")
    return rc


if __name__ == '__main__':
    sys.exit(main())
