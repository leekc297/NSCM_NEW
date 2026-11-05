# -*- coding: utf-8 -*-
"""3개 문서(defects_classified.csv) 기준 검증엔진 입증 현황 — 진행율의 단일 출처(2026-10-31 사용자: 감·예측 금지, 3개 문서 전체 확인 가능해야 함)

  규칙 입증 등급(원장 실측만 · 상속·집계 행 제외)
    F  PASS·FAIL 모두 실측    D  PASS 만(결함 검출 미입증)    E  FAIL 만(정상 판정 미입증)
    C  행은 있으나 실측 0     B  원장 행 없음                 A  규칙 정의 없음
  변이 입증: Doc/verify/<ID>/selftest/ 에서 주입한 오류를 FAIL 로 잡은 규칙이면 D 라도 결함 검출이 입증된 것으로 F* 표시
    2026-11-05 W8-4 교정: 이전엔 selftest/*.csv 만 읽었는데 실제 결과는 checklist_selftest.json(report[].kind·verdict) → 한 번도 읽히지 않았음
    Fm = 실측 PASS 만(D) + 검사기 함수 변이 시험 입증(_engine_gap.csv 그 규칙 세부 항목(해당없음 제외) 전부 build_status=변이입증) — 화면 주입(F*)과 구분 · 일부만이면 D(func_mutation 열 k/n)
         실측 0(C)·행 없음(B)은 함수 변이만으로 올리지 않는다(측정 경로가 그 검사기에 닿는다는 증거가 없음)
  문서 행 입증 = 그 행의 규칙이 전부 F/F*

  python tools/Harness/verify/doc_proof.py   → Doc/verify/_doc_proof.csv · _doc_proof_rows.csv · 콘솔 요약
"""
import collections, csv, datetime, glob, json, os, re
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
V = os.path.join(ROOT, 'Doc', 'verify')
TARGET = {'DEFECT', '', 'REQ', 'OPEN'}
RX = re.compile(r'^(E2E|STATIC|META|SYN|DB|W1 |sort)')
INH = re.compile(r'^규칙 |상속|^행 집계|^진입점 집계|규칙 \S+ 판정 \d+행')


def rd(f):
    with open(f, encoding='utf-8-sig') as fh:
        return list(csv.DictReader(fh))


def split_rules(s):
    return [x for x in re.split(r'[;,\s]+', (s or '').strip()) if x]


AGG_SRC = {'GENERAL', 'DEFECT', 'CONFIRMED', 'ASIS'}  # 결함·확정·일반화·AS-IS 대조 행 = 화면 실측 행 결과를 받는 집계 행(스스로 측정하지 않음)


def c_reasons(V, rules, refs):
    """W8-4(2026-11-05) — C 등급(원장 행은 있으나 실측 PASS/FAIL 0) 규칙마다 측정 0 원인을 원장에서 분류 → _doc_proof_c.csv
      원인(행 수 · 측정 행만 = 집계 행 제외):
        미실행    = 측정 행 결과 NOT_RUN(행이 마지막 E2E 뒤에 생겼거나 그 시험이 돌지 않음)
        대상없음  = 측정 행 NA(측정 화면에 그 규칙 대상 요소가 없음 — 데이터·화면 구성)
        경로오류  = 측정 행 ERROR(측정 경로 누락·재측정 필요·검증엔진 미기동)
        검사기없음 = 근거에 '자동 검사기 없음'(수동 검수 대상 · 작업 원장 W#)
        자동행대기 = 그 규칙을 만드는 자동 기대 패턴(gen_expect PATTERN_INFO)의 소비 행이 있는 화면 수(다음 CheckList 에서 실측)
    """
    import sys as _s
    _s.path.insert(0, HERE)
    try:
        import gen_expect as _G
        pat = {pid: v[1] for pid, v in _G.PATTERN_INFO.items()}
    except Exception:  # 생성기 import 실패 = 자동행대기 미측정(0 으로 두지 않고 표시)
        pat = None
    st = {x: collections.Counter() for x in rules}
    ev = {x: collections.Counter() for x in rules}
    scr = {x: collections.defaultdict(set) for x in rules}
    for f in sorted(glob.glob(os.path.join(V, '*', 'verify_ledger.csv'))):
        m = os.path.basename(os.path.dirname(f))
        for r in rd(f):
            x = r.get('rule_id')
            if x not in st:
                continue
            e = r.get('evidence') or ''
            if '자동 검사기 없음' in e:
                st[x]['검사기없음'] += 1
                scr[x]['검사기없음'].add(m)
                ev[x][re.sub(r'\d+', '#', e[:90])] += 1
                continue
            if r.get('source') in AGG_SRC:
                st[x]['집계행'] += 1
                continue
            k = {'NA': '대상없음', 'ERROR': '경로오류', '판정필요': '판정필요'}.get(r.get('result') or '', '미실행' if not r.get('result') or r['result'] == 'NOT_RUN' else '기타')
            st[x][k] += 1
            scr[x][k].add(m)
            if k in ('대상없음', '경로오류'):
                ev[x][f"{k}: " + re.sub(r'\d+', '#', e[:90])] += 1
    auto = collections.Counter()
    if pat is not None:
        for f in glob.glob(os.path.join(V, '*', 'auto_expect', '*.csv')):
            m = os.path.basename(os.path.dirname(os.path.dirname(f)))
            seen = set()
            for r in rd(f):
                x = pat.get(r.get('pattern_id', ''))
                if x in st and (x, m) not in seen:
                    seen.add((x, m))
                    auto[x] += 1
    with open(os.path.join(V, '_doc_proof_c.csv'), 'w', encoding='utf-8-sig', newline='') as fo:
        w = csv.writer(fo)
        w.writerow(['rule_id', 'doc_rows', '미실행', '대상없음', '경로오류', '판정필요', '검사기없음', '집계행', '자동행대기_화면', 'next', 'top_evidence'])
        for x in rules:
            c = st[x]
            nxt = []
            if pat is not None and auto[x]:
                nxt.append(f'자동 행 {auto[x]}화면 — 다음 CheckList 에서 실측')
            if c['미실행']:
                nxt.append(f"미실행 측정 행 {c['미실행']}({len(scr[x]['미실행'])}화면: {','.join(sorted(scr[x]['미실행'])[:6])}) — 그 화면 E2E 재실행")
            if c['경로오류']:
                nxt.append(f"경로오류 {c['경로오류']} — 측정 경로 보완")
            if c['검사기없음'] and not (c['미실행'] or c['경로오류'] or auto[x]):
                nxt.append('자동 검사기 없음 — 검사기 신설 또는 수동 검수')
            if c['대상없음'] and not nxt:
                nxt.append(f"측정 화면 {len(scr[x]['대상없음'])}개 모두 대상 없음 — 대상 요소 있는 화면에서 실측 필요")
            w.writerow([x, refs[x], c['미실행'], c['대상없음'], c['경로오류'], c['판정필요'], c['검사기없음'], c['집계행'],
                        auto[x] if pat is not None else '미측정(생성기 import 실패)', ' / '.join(nxt), ' ‖ '.join(f'{k}({n})' for k, n in ev[x].most_common(3))[:400]])
    print(f"  C 등급 {len(rules)}개 원인 → {os.path.relpath(os.path.join(V, '_doc_proof_c.csv'), ROOT)}")


def main():
    D = rd(os.path.join(V, 'defects_classified.csv')); T = [r for r in D if r['status'] in TARGET]
    defs = {d['check']: d for d in rd(os.path.join(HERE, 'mapping_checkdefs.csv'))}
    leds = sorted(glob.glob(os.path.join(V, '*', 'verify_ledger.csv')))
    st = collections.defaultdict(collections.Counter); scr = collections.defaultdict(set); run = {}
    for f in leds:
        m = os.path.basename(os.path.dirname(f)); run[m] = datetime.datetime.fromtimestamp(os.path.getmtime(f)).strftime('%m-%d %H:%M')
        for r in rd(f):
            if not r.get('rule_id'):
                continue
            meas = r['result'] in ('PASS', 'FAIL') and RX.match(r.get('tobe_ref') or '') and not INH.search(r.get('evidence') or '')
            k = ('mP' if r['result'] == 'PASS' else 'mF') if meas else (r['result'] or 'NOT_RUN')
            st[r['rule_id']][k] += 1
            if meas:
                scr[r['rule_id']].add(m)
    mut = collections.defaultdict(set)
    mut_miss = collections.defaultdict(set)  # 화면 주입했는데 미검출(검사기 결함) — 그 규칙 PASS 신뢰 불가 표시
    for f in glob.glob(os.path.join(V, '*', 'selftest', 'checklist_selftest.json')):
        try:
            with open(f, encoding='utf-8') as fh:
                j = json.load(fh)
        except (OSError, ValueError):
            continue
        for x in j.get('report') or []:
            k = x.get('kind') or ''
            if not k:
                continue
            if x.get('verdict') == '검출 증명':
                mut[k].add(j.get('menu_id') or os.path.basename(os.path.dirname(os.path.dirname(f))))
            elif x.get('verdict') == '미검출':
                mut_miss[k].add(j.get('menu_id') or '')
    fmut = collections.defaultdict(list)  # 검사기 함수 변이 시험(_engine_gap.csv) — 규칙의 세부 항목(해당없음 제외)이 '전부' 변이입증일 때만 Fm
    fsub = collections.defaultdict(collections.Counter)
    for g in rd(os.path.join(V, '_engine_gap.csv')) if os.path.exists(os.path.join(V, '_engine_gap.csv')) else []:
        if g.get('rule_id') and g.get('build_status') in ('구현', '변이입증'):
            fsub[g['rule_id']][g['build_status']] += 1
            if g['build_status'] == '변이입증':
                fmut[g['rule_id']].append(g.get('gap_id', ''))
    ffull = {x for x, c in fsub.items() if c['변이입증'] and not c['구현']}  # 2026-11-05: 일부만 입증(예 A1 2/8)을 규칙 입증으로 세지 않음
    for f in glob.glob(os.path.join(V, '*', 'selftest', '*.csv')):
        try:
            for r in rd(f):
                txt = ' '.join(str(v) for v in r.values())
                rid = r.get('rule_id') or r.get('kind') or r.get('종류') or ''
                if rid and '검출 증명' in txt:
                    mut[rid].add(os.path.basename(os.path.dirname(os.path.dirname(f))))
        except (OSError, UnicodeDecodeError, csv.Error):
            continue

    def grade(x):
        s = st.get(x, {})
        if x not in defs:
            return 'A'
        if x not in st:
            return 'B'
        p, f = s.get('mP', 0), s.get('mF', 0)
        if p + f == 0:
            return 'C'
        if p and f:
            return 'F'
        if p:
            return 'F*' if x in mut else 'Fm' if x in ffull else 'D'
        return 'E'
    refs = collections.Counter(x for r in T for x in split_rules(r['rule_ids']))
    with open(os.path.join(V, '_doc_proof.csv'), 'w', encoding='utf-8-sig', newline='') as fo:
        w = csv.writer(fo); w.writerow(['rule_id', 'grade', 'doc_rows', 'measured_pass', 'measured_fail', 'ERROR', 'NA', '판정필요', 'NOT_RUN', 'screens_measured', 'mutation_proved', 'checker', 'func_mutation', 'mutation_missed'])
        for x, n in refs.most_common():
            s = st.get(x, {})
            w.writerow([x, grade(x), n, s.get('mP', 0), s.get('mF', 0), s.get('ERROR', 0), s.get('NA', 0), s.get('판정필요', 0), s.get('NOT_RUN', 0), ';'.join(sorted(scr.get(x, []))), ';'.join(sorted(mut.get(x, []))), (defs.get(x) or {}).get('checker', ''), (f"{fsub[x]['변이입증']}/{fsub[x]['변이입증'] + fsub[x]['구현']} " + ';'.join(fmut.get(x, []))) if x in fsub else '', ';'.join(sorted(mut_miss.get(x, [])))])
    L = collections.Counter(); menus = collections.Counter(); menu_run = 0
    with open(os.path.join(V, '_doc_proof_rows.csv'), 'w', encoding='utf-8-sig', newline='') as fo:
        w = csv.writer(fo); w.writerow(['src', 'no', 'menu_id', 'rule_ids', 'grades', 'state', 'screen_run', 'target'])
        for r in T:
            xs = split_rules(r['rule_ids']); gs = [grade(x) for x in xs]
            state = '기계검출불가' if r['detectable'] == 'N' else '입증' if gs and all(g in ('F', 'F*', 'Fm') for g in gs) else '반쪽' if gs and all(g in ('F', 'F*', 'Fm', 'D', 'E') for g in gs) else '미입증'
            L[state] += 1; menus[r['menu_id']] += 1; has = r['menu_id'] in run; menu_run += has
            w.writerow([r['src'], r['no'], r['menu_id'], r['rule_ids'], ';'.join(gs), state, 'Y' if has else 'N', r['target'][:80]])
    gr = collections.defaultdict(list)
    for x, n in refs.most_common():
        gr[grade(x)].append(f'{x}({n})')
    print(f"[실측 {datetime.datetime.now():%Y-%m-%d %H:%M}] 문서 {len(D)}행 중 대상 {len(T)}행 · 원장 {len(leds)}화면: " + ' '.join(f'{k}@{v}' for k, v in run.items()))
    for k in ('입증', '반쪽', '미입증', '기계검출불가'):
        print(f"  {k}: {L[k]}행 ({100 * L[k] / len(T):.1f}%)")
    print(f"  문서 대상 메뉴 {len(menus)}개 중 원장 있는 메뉴 {sum(1 for m in menus if m in run)}개 · 그 메뉴의 문서 행 {menu_run}/{len(T)}")
    for g in ('F', 'F*', 'Fm', 'D', 'E', 'C', 'B', 'A'):
        if gr[g]:
            print(f"  등급 {g} 규칙 {len(gr[g])}: {' '.join(gr[g])}")
    c_reasons(V, [x for x in refs if grade(x) == 'C'], refs)
    mm = [f"{x}({grade(x)} · {';'.join(sorted(mut_miss[x]))})" for x in refs if x in mut_miss]
    if mm:
        print(f"  ⚠ 화면 주입 시험에서 '미검출'(검사기 결함 기록) 규칙: {' '.join(mm)} — 그 뒤 재시험 전까지 이 규칙의 PASS 는 신뢰 근거 약함")
    print('  ※ 등급은 규칙 단위 입증이다. 문서의 개별 결함을 그 화면에서 재현했다는 뜻이 아니다.')


if __name__ == '__main__':
    main()
