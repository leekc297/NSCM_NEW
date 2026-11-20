# -*- coding: utf-8 -*-
"""E2E 테스트 결과 중 CheckList 판정에 들어가지 않던 기능 시험 → 원장 ES- 행 (2026-11-18 사용자 지시
   "누락된 기능테스트가 있으면 CheckList에 넣도록")

  python tools/Harness/verify/e2e_suite_ingest.py <MENU_ID>
  run_verify 가 eg_ingest 바로 뒤에 부른다(원장을 다시 만들 때마다 같이 다시 넣는다 · 이전 ES- 행은 지우고 다시 만든다).

  2026-11-18 전 화면 E2E 요약(Doc/e2e/results/*/_summary.csv) 실측: judge 가 읽는 기록 = smoke cond·common·columns·i18n, auth·authcrud access·buttons·authcrud·cascade.
  읽지 않던 기능 시험 기록을 여기서 옮긴다.
    crud(crud 종류·authcrud 안의 crud) → F1 저장 후 DB 반영(마커 행 추가 → 저장 → 재조회 → 수정 → 삭제 · 편집 저장형은 값 변경 → 복원)
    auth division                    → J1 Division 별 조회
    dberr(BE 5xx)                    → F4 저장·조회 SQL 오류 0 (이 화면 호출 경로만 · 공통 경로는 참고)
    auth·authcrud gap                → J4 메뉴 권한 없는 계정의 직접 접근(참고 · 판정 근거는 eg_auth 새 세션 측정, 계정 순회 탭은 앞 계정 화면을 물려받아 허위 FAIL, 11-17 SSP0020)
    smoke labels                     → G4 조회조건 라벨 표시
    smoke header                     → H3 그리드 헤더 행 구성
  옮기지 않는 기록 = calls·condsum·commonsum(요약) · console(FE 게이트 fe_gate.py 가 판정) · dynamic(기대값 없는 목록)

  판정 원칙(허위 오류 금지)
    - 실행 예외(클릭 시간 초과·테스트 시간 초과·브라우저 닫힘)나 시험 행 저장 불가만으로 실패한 기록 = ERROR(측정 전제 미충족 · 미검증). FAIL 아님
    - 복원 실패(restored=N)는 ERROR + '[수동 복원 확인 필요]'
    - 실행 예외 없이 저장 요청이 갔는데 반영·삭제가 확인되지 않으면 FAIL
    - 결과 기록이 없는 종류는 e2e_suite.json 의 사유로 ERROR 행 1개(미검증)를 만든다
"""
import csv, hashlib, io, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
import safe_io  # noqa: E402
csv.field_size_limit(10 ** 8)
RX_EXC = re.compile(r'예외|Timeout|timeout|exceeded|has been closed|locator\.', re.I)
RX_MARKER = re.compile(r'마커 행 저장|재조회 후 신규 행 존재|SAVE call-proc 없음|마커 행 정리|Insert 후 행 증가 없음|첫 저장 호출 0건')


def rid(mid, *parts):
    return 'ES-' + hashlib.md5('|'.join([mid] + [str(x) for x in parts]).encode('utf-8')).hexdigest()[:8]


def kv(text):
    return dict(re.findall(r'(\w+)=([^\s·]*)', text or ''))


def crud_verdict(ann, errors, status):
    """crud 기록 1건 → (결과, 근거)"""
    d = kv(ann); errs = (errors or '').strip(); both = f'{ann} {errs}'
    if (status or '').upper() == 'PASS' and d.get('restored', 'Y') != 'N':
        return 'PASS', f"저장 왕복 확인 · {ann[:300]}"
    if d.get('restored') == 'N':
        return 'ERROR', f"[수동 복원 확인 필요] 시험 값 복원 실패 · {ann[:300]} · 오류: {errs[:300]}"
    if RX_EXC.search(both):
        return 'ERROR', f"[측정 전제 미충족: 실행 예외] 저장 기능 판정 못 함 · {ann[:300]} · 오류: {errs[:300]}"
    parts = [p.strip() for p in re.split(r'\|\||<br>|\n', errs) if p.strip()]
    if (d.get('saveCalls') in ('0', None) or d.get('saved') == 'N') and (not parts or all(RX_MARKER.search(p) for p in parts)):
        return 'ERROR', f"[측정 전제 미충족: 시험 행 저장 요청 없음(saveCalls={d.get('saveCalls', '?')})] 화면 검증·필수 칸에 막혔을 수 있음 · {ann[:300]} · 오류: {errs[:300]}"
    return 'FAIL', f"저장 왕복 실패 · {ann[:300]} · 오류: {errs[:400]}"


def main():
    mid = sys.argv[1].upper()
    import e2e_paths
    vd = os.path.join(ROOT, 'Doc', 'verify', mid)
    lp = os.path.join(vd, 'verify_ledger.csv')
    if not os.path.exists(lp):
        print(f'[e2e_suite_ingest] {mid}: 원장 없음, 생략'); return 0
    summ = e2e_paths.summary_rows(mid)
    try:
        suite = json.load(open(os.path.join(vd, 'e2e_suite.json'), encoding='utf-8'))
    except Exception:
        suite = {}
    with open(lp, encoding='utf-8-sig', newline='') as f:
        rd = csv.DictReader(f); fields = rd.fieldnames; rows = [r for r in rd if not r['row_id'].startswith('ES-')]
    out = {}

    def add(key, rule, target, cond, expected, asis, result, evidence, tag):
        r = {k: '' for k in fields}
        r.update({'row_id': rid(mid, key), 'source': 'RULE_SCREEN', 'family': rule[:1], 'rule_id': rule, 'target': target, 'condition': cond, 'expected': expected,
                  'asis_ref': asis, 'method': 'E2E', 'result': 'NOT_RUN', 'area': tag})
        rows.append(r); out[r['row_id']] = {'row_id': r['row_id'], 'result': result, 'evidence': evidence[:1500], 'tobe_ref': f'E2E @{tag}'}

    have = {k: 0 for k in ('crud', 'auth', 'authcrud')}
    for i, x in enumerate(summ):
        kind = x.get('kind') or ''; st = x.get('status') or ''; errs = x.get('errors') or ''
        if kind in have:
            have[kind] += 1
        acc = ''; roster = (re.search(r'roster=(\S+(?: \S+)*?) \(', x.get('annotations') or '') or [None, ''])[1]
        for part in (x.get('annotations') or '').split(' || '):
            t, _, desc = part.partition(': '); t = t.strip()
            if t == 'authcrud' and kind == 'authcrud':
                m = re.match(r'(\S+) div=', desc); acc = m.group(1) if m else acc
            if t == 'crud' and kind in ('crud', 'authcrud'):
                res, ev = crud_verdict(desc, errs, st if kind == 'crud' else ('PASS' if 'saved=Y' in desc and 'found=Y' in desc else 'FAIL'))
                d = kv(desc)
                # 2026-11-18 미검증 해소(SCP0096 ES-e648b9a6 lucky-alex): 권한별 CRUD 에서 Save 가 안 보이는 계정(no-save)은 저장 권한이 없는 계정이다 —
                #   저장 왕복(F1) 대상이 아니다(버튼 권한 일치 여부는 J2·authcrud 권한 행이 판정). 관리자 crud(kind=crud)의 Save 비노출은 그대로 미검증·FAIL 경로
                if kind == 'authcrud' and d.get('mode') == 'no-save' and 'Save 비노출' in desc and not (errs or '').strip():
                    res, ev = 'NA', f"이 계정({acc or '?'}) Save 비노출 = 저장 권한 없음 — 저장 왕복 대상 아님(버튼 권한 일치는 J2 행) · {desc[:300]}"
                add(f'crud|{kind}|{i}|{d.get("mode")}', 'F1', f"{mid} E2E {kind} 저장 왕복({d.get('mode', '-')}){' ' + acc if acc else ''}",
                    '마커 행 추가 → 저장 → 재조회 → 수정 → 삭제 · 편집 저장형은 값 변경 → 저장 → 복원', '저장 요청 1건 이상, 재조회 반영, 정리와 복원 완료',
                    'AS-IS 저장 동작(저장 버튼, 저장 SP), tools/E2E/lib/crud.ts', res, ev, f'e2e-{kind}')
            elif t == 'division' and kind.startswith('auth'):
                m = re.match(r'(\S+)\s+set=(\w+)\s+rows=(\d+|\?)\s*alert=(.*)', desc.strip())
                if not m:
                    continue
                div, setv, n, alert = m.groups()
                if setv != 'true':
                    res, ev = 'ERROR', f'[측정 전제 미충족] Division {div} 선택 못 함 · {desc[:200]}'
                elif n in ('0', '?'):
                    res, ev = 'ERROR', f'[측정 전제 미충족: 조회 0행] Division {div} 데이터 없음, 범위 판정 못 함' + (f' · 알림 {alert[:120]}' if alert.strip() else '')
                else:
                    res, ev = 'PASS', f'Division {div} 조회 {n}행' + (f' · 알림 {alert[:120]}' if alert.strip() else '')
                add(f'div|{kind}|{i}|{div}', 'J1', f"{mid} E2E {kind} Division {div} 조회" + (f' · 계정 {roster}' if roster else ''), f'Division {div} 선택 후 조회', '조회 성공 · 데이터 범위 = 선택 Division',
                    'AS-IS Division 권한 조회 · tools/E2E auth 스펙', res, ev, f'e2e-{kind}')
            elif t == 'dberr':
                paths = re.findall(r'500 (\S+)', desc)
                mine = [p for p in paths if mid in p.upper()]
                if mine:
                    res, ev = 'FAIL', f'이 화면 호출 BE 5xx {len(mine)}건: {", ".join(sorted(set(mine)))[:300]} · {desc[:300]}'
                else:
                    res, ev = 'NA', f'BE 5xx 가 이 화면 밖 공통 경로만({", ".join(sorted(set(paths)))[:200]}), 화면 판정 대상 아님(참고) · {desc[:200]}'
                add(f'dberr|{kind}|{i}', 'F4', f"{mid} E2E {kind} BE 서버 오류", f'E2E {kind} 실행 중 BE 응답', '이 화면 호출 5xx 0건', 'AS-IS 조회·저장 정상(공통 규칙)', res, ev, f'e2e-{kind}')
            elif t == 'gap' and kind.startswith('auth'):
                add(f'gap|{kind}|{i}', 'J4', f"{mid} E2E {kind} 메뉴 권한 없는 계정 직접 접근", '메뉴 권한 없는 계정으로 /view/<ID> 직접 접근', '접근 차단 또는 기능 비노출',
                    'AS-IS 메뉴 권한', 'NA', f'[참고] {desc[:300]}, 계정 순회 탭 측정이라 판정 근거 아님. J4 판정 = eg_auth 새 브라우저 세션 측정(사용자 지시 2026-11-17)', f'e2e-{kind}')
            elif t == 'labels' and kind == 'smoke':
                m = re.search(r'일치 (\d+) / 누락 (\d+)(?::\s*(.*))?', desc)
                if not m:
                    continue
                ok_n, miss_n, names = m.group(1), int(m.group(2)), (m.group(3) or '').split(' / ')[0].strip()  # ' / 제외 n: …' 는 측정 제외 목록(누락 아님)
                res = 'PASS' if miss_n == 0 else '판정필요'
                ev = f'조회조건 라벨 일치 {ok_n} · 누락 {miss_n}' + (f': {names[:200]}' if names else '') + ('' if miss_n == 0 else ', TO-BE 룰(라벨 변경 CR-092 · 필수 표시 CR-077 등) 해당 여부 확인 필요')
                add(f'labels|{i}', 'G4', f"{mid} E2E smoke 조회조건 라벨", '화면 열기 · 접힌 조건 펼침', '기대 라벨(TO-BE LBL · AS-IS 라벨) 전부 표시', 'AS-IS 조회조건 라벨 · msg_master', res, ev, 'e2e-smoke')
            elif t == 'header' and kind == 'smoke':
                m = re.search(r'As-is 헤더 (\d+)행.*?To-Be 행 (\d+)', desc)
                if not m:
                    continue
                a_n, t_n = m.groups()
                res = 'PASS' if a_n == t_n else '판정필요'
                add(f'header|{i}', 'H3', f"{mid} E2E smoke 그리드 헤더 행", '화면 열기 · 그리드 헤더', 'AS-IS 헤더 행 수 = TO-BE', 'AS-IS SetSheetHeaderColumn·ColumnHeaderSpan',
                    res, f'{desc[:300]}' + ('' if res == 'PASS' else ', 행 수 차이: 디자인 룰 여부 확인 필요'), 'e2e-smoke')
    # 실행 기록이 없는 종류 = 미검증 행(사유 = e2e_suite.json)
    for kind, n in have.items():
        if n:
            continue
        s = suite.get(kind) or {}
        why = s.get('reason') or 'E2E 결과 없음, CheckList 전체 실행(E2E 포함)에서 e2e_suite.py 가 실행'
        add(f'none|{kind}', {'crud': 'F1', 'auth': 'J1', 'authcrud': 'J2'}[kind], f"{mid} E2E {kind} 실행", f'run-e2e.cmd {kind} {mid}', f'{kind} 시험 실행 · 결과 기록',
            'AS-IS 저장·권한 동작 · tools/E2E', 'ERROR', f'[미측정] {why}', f'e2e-{kind}')
    seen = {}
    for r in rows:
        seen[r['row_id']] = r
    rows = list(seen.values())
    try:
        import applicability as _AP
        need = [r for r in rows if r['row_id'].startswith('ES-') and not (r.get('applicable') or '').strip()]
        if need:
            _AP.apply(need, mid, '')
    except Exception as _ex:
        print(f'[e2e_suite_ingest] 적용성 보충 실패(무시): {_ex}')
    buf = io.StringIO(newline='')
    w = csv.DictWriter(buf, fieldnames=fields); w.writeheader(); w.writerows(rows)
    safe_io.write_text(lp, buf.getvalue(), 'utf-8-sig', log=print)
    ej = os.path.join(vd, 'e2e_results.json')
    try:
        prev = json.load(open(ej, encoding='utf-8'))
    except Exception:
        prev = []
    keep = [e for e in prev if not str(e.get('row_id', '')).startswith('ES-')]
    safe_io.write_text(ej, json.dumps(keep + list(out.values()), ensure_ascii=False, indent=1).replace('\n', os.linesep), 'utf-8', log=print)
    import collections
    print(f"[e2e_suite_ingest] {mid}: E2E 기록 crud {have['crud']} · auth {have['auth']} · authcrud {have['authcrud']} → 원장 ES- 행 {len(out)} · "
          f"{dict(collections.Counter(o['result'] for o in out.values()))}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
