# -*- coding: utf-8 -*-
"""proof_backlog.py — "AS-IS 기능 100% 구현 증명"까지 남은 일의 전수 목록 (2026-11-11 사용자 지시: "누락하지 말고 … 순차적으로 하나씩 · 해야 할 일을 누락하고 완료되었다고 보고하지 말 것")

분모 = 대조표 추적(mapping_trace.py)이 만든 검사 단위(인스턴스) 전부 — FE 대조표 전 행 + AS-IS 액션 대조표 전 문장에서 나온 (검사, 대상).
이 도구는 그 인스턴스를 하나도 빼지 않고 "증명됨 / 조치 필요 / 사람 판정 / 아직 증명 안 됨(사유별)"로 나눈다. 합계가 분모와 다르면 실패(exit 1).
'아직 증명 안 됨'은 사유를 고정 분류(BUCKETS)로 나누고, 어느 분류에도 안 맞는 것은 OTHER 로 남긴다(버리지 않는다).

  python tools/Harness/verify/proof_backlog.py            E2E 판정이 있는 화면 전부(원장 PASS+FAIL > 200)
  python tools/Harness/verify/proof_backlog.py <ID> …     지정 화면
  python tools/Harness/verify/proof_backlog.py --selftest
출력: Doc/verify/_proof_backlog.csv(화면 × 분류 × 층 건수) · _proof_backlog_detail.csv(분류 × 검사 × 사유 건수 — 작업 단위) · Doc/verify/_proof_backlog.md(작업 목록 — 분류별 건수·대표 사유·할 일) · 이력 Doc/verify/_proof_backlog_history.csv
"""
import csv, glob, os, re, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
try:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception:
    pass
csv.field_size_limit(10 ** 8)
# (분류 id, 결과 집합, 사유 정규식, 할 일) — 위에서부터 첫 일치
BUCKETS = [
    ('B01 검사기는 있는데 이 대상을 실행하는 경로 없음', {'NOPATH'}, r'', '대상별 실행 경로 생성(@trace 항목·ledger 항목) — 검사기 연결'),
    ('B02 검사기 있음 · 아직 실행 안 함', {'NOT_RUN'}, r'', '해당 검사 실행(E2E 포함 CheckList) — 실행해도 남으면 사유 재분류'),
    ('B03 구현 후 검증(대조표 상태 미구현)', {'BLOCKED'}, r'', '미구현 기능 구현(작업 모드 범위) 후 검증'),
    ('B04 신규행 전제 미충족(행 추가가 안 돼 입력·연쇄 검사 불가)', {'ERROR'}, r'신규행 없음|행 추가|Insert', '행 추가 전제(조건·필수 선택)를 만들어 측정 — 상태 조성'),
    ('B05 팝업 값 반영 위치 확인 불가', {'ERROR', 'REVIEW'}, r'팝업에서 가져온 값|셀 위치 확인 불가|팝업 선택값', '팝업 선택 → 반영 셀 식별 로직 보강'),
    ('B06 진입점 집계 — 하위 검사 미실행이 남음', {'ERROR'}, r'진입점 집계|행 집계|미실행 검사가 남아', '하위 검사(B01·B02·B04 등) 해소 시 함께 해소 — 집계 행'),
    ('B07 차등 검증·골든 인자 미정/케이스 없음', {'REVIEW', 'ERROR'}, r'파라미터 미정|골든 비교 케이스 없음|SKIP AS-IS', '호출 로그 인자(sqllog_calls)·짝·키로 차등 검증 재실행'),
    ('B08 대조표 서술 보강(구현 위치·제외 사유 미기재)', {'REVIEW', 'NA'}, r'구현 위치.*(없|비어)|사유·근거.*없|대조표 기록 보강|서술 보강', '대조표에 구현 위치(파일:행)·제외 사유 기입 — 기입 뒤 실행 검사로 확인'),
    ('B09 기계 판정 불가 — 시나리오 수동 확인으로 남김', {'REVIEW', 'NA', 'ERROR'}, r'기계 판정 불가|수동 검수|수동 확인|사람 확인|검증 엔진 확장 대상|검사기 구현 대상|미포함 항목', '시나리오를 엔진으로 실행하도록 확장(상태 조성) — 안 되면 사용자 확인 목록'),
    ('N1 해당없음 — 실측 근거 있음(원문·메타로 대상 아님을 확인)', {'NA'}, r'실측.*(대상 아님|양쪽 숨김|현재 그리드에 없음|잠금\(.*\) 없음|메시지 문장 없음|예외 메시지)|적용할 요소\(.*\)가 없다', '확정 — 근거 문장이 원문·메타 실측인지 표본 점검만'),
    ('B10 해당없음 — 연결된 AS-IS 문장·요소 검사 없음', {'NA'}, r'연결된 문장·요소 검사가 없다|문장 추출 0', '진입점 ↔ 문장 연결 복구(추출 0 원인 확인) — 대상 아님이 맞는지 원문으로 확인'),
    ('B11 해당없음 — AS-IS 진입점 미연결(죽은 코드)', {'NA'}, r'진입점 미연결|살아있는 코드 없음|주석 밖 호출 0', '원문 재확인(호출 0 이 맞는지) — 맞으면 근거와 함께 확정'),
    ('B12 해당없음 — 이 대상에 AS-IS 메시지/규칙 없음', {'NA'}, r'메시지 문장 없음|대상 아님|해당 없음|없음 —', '근거(원문 위치)가 붙어 있는지 확인 — 없으면 미증명으로 되돌림'),
    ('B13 해당없음 — 원장 판정 승계(사유는 원장 행)', {'NA'}, r'^\s*원장', '원장 행의 NA 사유를 종류별로 다시 분류(다음 단계에서 세분)'),
    ('B14 측정 실패·판정 못 함(그 밖)', {'ERROR'}, r'', '사유별 원인 확인 — 검사기 결함이면 수정'),
    ('B15 사람 판정 대기(그 밖)', {'REVIEW', 'WARN'}, r'', '판정필요 목록으로 제시 — 사용자 판정'),
    ('B16 해당없음(그 밖)', {'NA'}, r'', '사유 확인 후 근거 있는 해당없음 / 미증명으로 재분류'),
]
DONE = {'PASS': 'A1 증명됨(PASS)', 'FAIL': 'A2 조치 필요(FAIL)'}
FAIL_AGG = 'A3 조치 필요 요소를 묶은 집계 행(중복 계수 · 결함 수 아님)'   # 2026-11-13 T285
FAIL_DOC = "A4 대조표 '미구현' 표기(문서 표기 · 화면 실측 아님)"
RX_FAIL_AGG = re.compile(r'^\s*(행|진입점) 집계')
RX_FAIL_DOC = re.compile(r"의 상태가 '미구현'|^\s*선행 미구현에 종속")


def classify(result, why):
    if result == 'FAIL':   # 2026-11-13 T285: 집계 행·문서 표기를 요소 FAIL 과 따로 센다
        if RX_FAIL_AGG.search(why or ''):
            return FAIL_AGG
        if RX_FAIL_DOC.search(why or ''):
            return FAIL_DOC
    if result in DONE:
        return DONE[result]
    for name, results, rx, _ in BUCKETS:
        if result in results and re.search(rx, why or ''):
            return name
    return 'OTHER 분류 안 됨(' + result + ')'


def pick_screens(cands, ever):
    """집계 대상 화면. cands = [(화면, 원장 PASS·FAIL 행 수)], ever = 화면별 이력에 오른 화면 집합. T298"""
    return [s for s, n in cands if n > 200 or s in ever]


def selftest():
    st = {'ok': 0, 'n': 0}

    def t(name, cond):
        st['n'] += 1
        st['ok'] += bool(cond)
        print(('PASS ' if cond else 'FAIL ') + name)
    t('PASS·FAIL 은 고정 분류', classify('PASS', '') == 'A1 증명됨(PASS)' and classify('FAIL', 'x').startswith('A2'))
    t('NOPATH → B01', classify('NOPATH', '검사기는 있으나 경로 없음').startswith('B01'))
    t('T298 이력에 오른 화면은 행 수가 줄어도 남는다', pick_screens([('A', 193), ('B', 500)], {'A'}) == ['A', 'B'])
    t('T298 이력에 없는 화면은 200 초과일 때만', pick_screens([('A', 193), ('B', 500)], set()) == ['B'])
    t('T298 경계값 200 은 새 화면에 포함하지 않는다(변이)', pick_screens([('C', 200)], set()) == [])
    t('T285 집계 행 FAIL → A3', classify('FAIL', "행 집계 — 대조표 X 의 G4 15요소: FAIL:9 · ERROR:6").startswith('A3'))
    t('T285 진입점 집계 FAIL → A3', classify('FAIL', '진입점 집계 3검사 — FAIL:2 · NA:1').startswith('A3'))
    t('T285 대조표 미구현 표기 FAIL → A4', classify('FAIL', "대조표 D00-3-045 'x' 의 상태가 '미구현' — 사유: y").startswith('A4'))
    t('T285 요소 FAIL 은 A2 그대로', classify('FAIL', "원장 V-1 SEARCH / 실측: 라벨 다름").startswith('A2'))
    t('T285 문장 중간의 집계 낱말은 A3 아님(변이)', classify('FAIL', '실측: 합계 행 집계 값이 다름').startswith('A2'))
    t('T285 PASS 집계 행은 A1 그대로', classify('PASS', '행 집계 — 전부 PASS').startswith('A1'))
    t('신규행 없음 ERROR → B04', classify('ERROR', '실측: 조회 후 Insert 했으나 신규행 없음').startswith('B04'))
    t('구현 위치 미기재 REVIEW → B08', classify('REVIEW', '이 표에 구현 위치 열이 없고 행에도 파일 참조 없음').startswith('B08'))
    t('문장 추출 0 NA → B10(해당없음으로 확정하지 않음)', classify('NA', '검사 대상 아님 — 이 진입점에 연결된 문장·요소 검사가 없다').startswith('B10'))
    t('실측 근거가 붙은 해당없음 → N1', classify('NA', '실측[T-1]: X: 그리드 미표시 — 양쪽 숨김(표시 여부는 A5 PASS)').startswith('N1'))
    t('근거 없는 해당없음은 N1 이 아니다(변이)', not classify('NA', '검사 대상 아님 — 이 진입점에 연결된 문장·요소 검사가 없다').startswith('N1'))
    t('모르는 결과값은 버리지 않고 OTHER', classify('XYZ', '').startswith('OTHER'))
    t('사유 없는 ERROR 도 분류에 남는다', classify('ERROR', '').startswith('B14'))
    names = [b[0] for b in BUCKETS]
    t('분류 이름 중복 없음', len(names) == len(set(names)))
    print(f"{st['ok']}/{st['n']}")
    return 0 if st['ok'] == st['n'] else 1


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='', errors='replace') as f:
        return list(csv.DictReader(f))


def main():
    a = sys.argv[1:]
    if '--selftest' in a:
        return selftest()
    mids = [x.upper().strip('/') for x in a if not x.startswith('--')]
    if not mids:
        cands_ = []
        for f in sorted(glob.glob(os.path.join(ROOT, 'Doc', 'verify', '*', 'mapping_trace_instances.csv'))):
            s = os.path.basename(os.path.dirname(f))
            led = rd(os.path.join(ROOT, 'Doc', 'verify', s, 'verify_ledger.csv'))
            cands_.append((s, sum(1 for r in led if r.get('result') in ('PASS', 'FAIL'))))
        ever_ = {r.get('menu_id', '') for r in rd(os.path.join(ROOT, 'Doc', 'verify', '_proof_backlog_screen_history.csv'))}
        mids = pick_screens(cands_, ever_)   # 2026-11-13 T298: 이력에 오른 화면은 재지 못해도 집계에 남긴다
    rows, total, examples = [], 0, {}
    detail = {}; detail_scr = {}
    per = {}
    for mid in mids:
        inst = rd(os.path.join(ROOT, 'Doc', 'verify', mid, 'mapping_trace_instances.csv'))
        if not inst:
            print(f'[proof_backlog] {mid}: mapping_trace_instances.csv 없음 — 분모를 만들 수 없음(미측정) · mapping_trace.py {mid} 먼저')
            continue
        led = {x.get('row_id'): x for x in rd(os.path.join(ROOT, 'Doc', 'verify', mid, 'verify_ledger.csv'))}
        for r in inst:
            total += 1
            why = r.get('why') or ''
            m0 = re.match(r'^\s*원장\s+(\S+)(?:\s+[A-Z_]+)?\s*$', why)
            if m0 and m0.group(1) in led:   # 사유가 '원장 <행 ID>' 뿐이면 그 원장 행의 근거를 사유로 읽는다(2026-11-11: B13 1,950건의 실제 사유가 가려져 있었다)
                lx = led[m0.group(1)]
                why = f"원장 {m0.group(1)}: " + ((lx.get('applicable_why') or '') + ' ' + (lx.get('evidence') or '')).strip()
                r = dict(r, why=why)
            c = classify(r.get('result') or '', why)
            k = (mid, c, r.get('layer') or '')
            per[k] = per.get(k, 0) + 1
            if not c.startswith('A'):
                wk = re.sub(r'\[[^\]]*\]', '', why)
                wk = re.sub(r"'[^']*'", '~', wk)
                wk = re.sub(r'^\s*원장\s+\S+:?\s*', '', wk)
                wk = re.sub(r'[A-Za-z0-9_.:\-]{5,}', '~', wk)
                dk = (c, r.get('check') or '', re.sub(r'\s+', ' ', wk).strip()[:110])
                d0 = detail.setdefault(dk, [0, mid, re.sub(r'\s+', ' ', why)[:300]])
                d0[0] += 1
                detail_scr[(dk, mid)] = detail_scr.get((dk, mid), 0) + 1  # 2026-11-12: 화면별 건수(대표 화면만 적던 것 보완)
            examples.setdefault(c, {})
            w = re.sub(r'\s+', ' ', (r.get('why') or '').strip())[:160]
            if w and len(examples[c]) < 3:
                examples[c].setdefault(w, mid)
    for (mid, c, layer), n in sorted(per.items()):
        rows.append({'menu_id': mid, 'bucket': c, 'layer': layer, 'count': n})
    vd = os.path.join(ROOT, 'Doc', 'verify')
    with open(os.path.join(vd, '_proof_backlog.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['menu_id', 'bucket', 'layer', 'count'])
        w.writeheader()
        w.writerows(rows)
    with open(os.path.join(ROOT, 'Doc', 'verify', '_proof_backlog_detail_by_screen.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f)
        w.writerow(['bucket', 'check', 'reason', 'menu_id', 'count'])
        for ((c, chk, wk), m_), n in sorted(detail_scr.items(), key=lambda kv: (kv[0][0][0], kv[0][0][1], kv[0][0][2], kv[0][1])):
            w.writerow([c, chk, wk, m_, n])
    with open(os.path.join(ROOT, 'Doc', 'verify', '_proof_backlog_detail.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f)
        w.writerow(['bucket', 'check', 'reason', 'count', 'example_screen', 'example'])
        for (c, chk, wk), (n, m1, ex1) in sorted(detail.items(), key=lambda kv: (kv[0][0], -kv[1][0])):
            w.writerow([c, chk, wk, n, m1, ex1])
    by = {}
    for r in rows:
        by[r['bucket']] = by.get(r['bucket'], 0) + r['count']
    if sum(by.values()) != total:
        print(f'[proof_backlog] 합계 불일치 — 분류 합 {sum(by.values())} ≠ 인스턴스 {total}')
        return 1
    at = time.strftime('%Y-%m-%d %H:%M:%S')
    proven = by.get(DONE['PASS'], 0)
    todo = {b[0]: b[3] for b in BUCKETS}
    md = [f'# AS-IS 기능 구현 증명 — 남은 일 전수 목록 ({at})', '',
          '분모 = 대조표 추적(mapping_trace)의 검사 단위 전부. 아래 분류의 합 = 분모(하나도 빼지 않음). **증명됨이 분모와 같아질 때까지 완료가 아니다.**', '',
          f'- 대상 화면 {len(mids)}개 · 검사 단위 **{total}** · 증명됨 **{proven}** · 조치 필요(FAIL) {by.get(DONE["FAIL"], 0)} · 그 밖(아직 증명 안 됨·사람 판정) **{total - proven - by.get(DONE["FAIL"], 0)}**', '',
          f'- 조치 필요 읽는 법(2026-11-13): **요소 단위 {by.get(DONE["FAIL"], 0)}** 가 확인 대상 수. 그것을 묶은 집계 행 {by.get(FAIL_AGG, 0)} 은 같은 요소를 대조표 행·진입점 단위로 한 번 더 센 것이고, 대조표 미구현 표기 {by.get(FAIL_DOC, 0)} 는 문서에 적힌 상태다(화면을 재서 나온 값 아님). 요소 단위도 결함 수가 아니라 검사 단위 수 — 같은 원인 하나가 여러 요소에 걸릴 수 있다.', '',
          '| 분류 | 건수 | 할 일 | 대표 사유(화면) |', '|---|---|---|---|']
    for c in sorted(by, key=lambda k: ({'A': 0, 'N': 1}.get(k[:1], 2), k)):
        ex = ' / '.join(f'{w[:90]}({m})' for w, m in list(examples.get(c, {}).items())[:2]).replace('|', '/')
        md.append(f'| {c} | {by[c]} | {todo.get(c, "-")} | {ex} |')
    md += ['', '## 화면별', '', '| 화면 | 검사 단위 | 증명됨 | 조치 필요 | 그 밖 |', '|---|---|---|---|---|']
    for mid in mids:
        t_ = sum(r['count'] for r in rows if r['menu_id'] == mid)
        p_ = sum(r['count'] for r in rows if r['menu_id'] == mid and r['bucket'] == DONE['PASS'])
        f_ = sum(r['count'] for r in rows if r['menu_id'] == mid and r['bucket'] == DONE['FAIL'])
        if t_:
            md.append(f'| {mid} | {t_} | {p_} | {f_} | {t_ - p_ - f_} |')
    with open(os.path.join(vd, '_proof_backlog.md'), 'w', encoding='utf-8') as f:
        f.write('\n'.join(md) + '\n')
    hp = os.path.join(vd, '_proof_backlog_history.csv')
    new = not os.path.exists(hp)
    with open(hp, 'a', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f)
        if new:
            w.writerow(['at', 'screens', 'total', 'proven', 'fail', 'rest'] + [b[0][:3] for b in BUCKETS] + ['OTHER'])
        w.writerow([at, len(mids), total, proven, by.get(DONE['FAIL'], 0), total - proven - by.get(DONE['FAIL'], 0)] + [by.get(b[0], 0) for b in BUCKETS]
                   + [sum(v for k, v in by.items() if k.startswith('OTHER'))])
    # 2026-11-12: 화면별 추이 — 11-11 22:37 → 11-12 09:05 에 증명됨이 4,681 → 4,490 으로 줄었는데 화면별 직전 수치가 없어 어느 화면인지 가르지 못했다.
    #   화면의 수치가 직전 기록과 달라졌을 때만 한 줄 추가(같으면 쓰지 않음 — 파일이 실행 횟수만큼 불어나지 않게)
    sp = os.path.join(vd, '_proof_backlog_screen_history.csv')
    last = {}
    if os.path.exists(sp):
        with open(sp, encoding='utf-8-sig', newline='') as f:
            for r in csv.DictReader(f):
                last[r['menu_id']] = (r['total'], r['proven'], r['fail'])
    new = not os.path.exists(sp)
    with open(sp, 'a', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f)
        if new:
            w.writerow(['at', 'menu_id', 'total', 'proven', 'fail', 'rest', 'd_proven'])
        for mid in mids:
            t_ = sum(r['count'] for r in rows if r['menu_id'] == mid)
            p_ = sum(r['count'] for r in rows if r['menu_id'] == mid and r['bucket'] == DONE['PASS'])
            f_ = sum(r['count'] for r in rows if r['menu_id'] == mid and r['bucket'] == DONE['FAIL'])
            if t_ and last.get(mid) != (str(t_), str(p_), str(f_)):
                dp = (p_ - int(last[mid][1])) if mid in last else ''
                w.writerow([at, mid, t_, p_, f_, t_ - p_ - f_, dp])
                if dp != '' and dp < 0:
                    print(f'[proof_backlog] ⚠ {mid} 증명됨 감소 {last[mid][1]} → {p_} ({dp}) — 원인 확인 필요')
    print(f"[proof_backlog] {at} · 화면 {len(mids)} · 검사 단위 {total} · 증명됨 {proven} · 조치 필요 {by.get(DONE['FAIL'], 0)} · 그 밖 {total - proven - by.get(DONE['FAIL'], 0)} → Doc/verify/_proof_backlog.md")
    for c in sorted(by, key=lambda k: ({'A': 0, 'N': 1}.get(k[:1], 2), k)):
        print(f'   {by[c]:>6}  {c}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
